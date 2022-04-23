import AuthenticationServices
import Foundation
import KeychainAccess

class Twitch: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    @Published var isLoggedIn = false
    @Published var token: String?
    @Published var user: User?
    @Published var streams: [Stream] = []
    
    private let decoder = JSONDecoder()
    private let keychain = Keychain(server: "https://twitch.tv", protocolType: .https)
    
    let clientID = "fcuw7vdwr2syhkreuf9upamwboxz0b"
    private let secret = "dwdgkupbmhcctnr52vrk0aukx1gq0a"
    private var refreshToken: String?
    
    var tokenIsValid: Bool = false
    
    override init() {
        super.init()
        self.streams = []
        
        if let userToken = keychain["userToken"] {
            token = userToken
            isLoggedIn = true
            Task {
                await validateToken()
                await getUserInfo()
            }
        }
    }
    
    func clearTokens() {
        print("removing tokens")
        do {
            try keychain.remove("userToken")
        } catch {
            print("No user token in keychain")
        }
    }
    
    func getUserInfo() async {
        let url = "https://api.twitch.tv/helix/users"
        let headers = ["Authorization": "Bearer \(token!)", "Client-Id": clientID]
        
        if let data = await Request.perform(.GET, url: url, headers: headers) {
            if let response = try? decoder.decode(Users.self, from: data) {
                DispatchQueue.main.async {
                    let user = response.data[0]
                    self.user = user
                    Task{
                        await self.getFollowedStreams(user: user)
                    }
                }
            } else {
                print("Failed to get user info")
            }
        }
    }
    
    func login() {
        if let userToken = keychain["userToken"] {
            token = userToken
            isLoggedIn = true
            Task {
                await getUserInfo()
            }
            return
        }
        
        var newLoginUrl = URLComponents()
        newLoginUrl.scheme = "https"
        newLoginUrl.host = "id.twitch.tv"
        newLoginUrl.path = "/oauth2/authorize"
        
        let clientQuery = URLQueryItem(name: "client_id", value: clientID)
        let redirectQuery = URLQueryItem(name: "redirect_uri", value: "auth://")
        let responseQuery = URLQueryItem(name: "response_type", value: "token")
        let scopesQuery = URLQueryItem(name: "scope", value: "chat:read chat:edit user:read:follows")
        
        newLoginUrl.queryItems = [clientQuery, redirectQuery, responseQuery, scopesQuery]
        
        let session = ASWebAuthenticationSession(url: newLoginUrl.url!, callbackURLScheme: "auth") { callbackURL, error in
            guard let callbackURL = callbackURL else {
                return
            }
            
            let fragment = "?" + callbackURL.fragment!
            let queryItems = URLComponents(string: fragment)?.queryItems
            let token = queryItems?.filter { $0.name == "access_token" }.first?.value
            
            
            
            self.keychain["userToken"] = token!
            self.token = token!
            
            
            self.isLoggedIn = true
            Task {
                await self.getUserInfo()
            }
        }
        session.presentationContextProvider = self
        // session.prefersEphemeralWebBrowserSession = true
        if !session.start() {
            print("fail")
        }
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    func logout() async {
        isLoggedIn = false
        do {
            try keychain.remove("userToken")
            DispatchQueue.main.async {
                self.streams = []
                let userInfo: [String: Any] = ["count": 0, "streams": [] ]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "onStreamChange"), object: nil, userInfo: userInfo)
                
            }
        } catch {
            print("No values in keychain", error.localizedDescription)
        }
    }
    
    func validateToken() async {
        let url = "https://id.twitch.tv/oauth2/validate"
        
        let headers = ["Authorization": "OAuth \(token!)"]
        
        if let data = await Request.perform(.GET, url: url, headers: headers) {
            if (try? decoder.decode(ValidateResponse.self, from: data)) != nil {
                print("Token validated")
                tokenIsValid = true
                return
            }
        }
        print("Token invalid")
        tokenIsValid = false
        await logout()
    }
    
    
    func getStreams(user_ids: [String]) async -> [Stream]{
        let url = "https://api.twitch.tv/helix/streams"
        let headers = ["Authorization": "Bearer \(token!)", "Client-Id": clientID]
        let queryItems = user_ids.map({ (id) -> URLQueryItem in
            URLQueryItem(name: "user_id", value: id)
        })
        
        if let data = await Request.perform(.GET, url: url, headers: headers, queries: queryItems) {
            let streams = try! decoder.decode(Streams.self, from:data)
            return streams.data
        }
        return []
    }
    
    
    func getUsers(ids: [String]) async -> [User]{
        let url = "https://api.twitch.tv/helix/users"
        let headers = ["Authorization": "Bearer \(token!)", "Client-Id": clientID]
        let queryItems = ids.map({ (id) -> URLQueryItem in
            URLQueryItem(name: "id", value: id)
        })
        
        if let data = await Request.perform(.GET, url: url, headers: headers, queries: queryItems) {
            let users = try! decoder.decode(Users.self, from:data)
            return users.data
        }
        return []
    }
    
    func getFollowedStreams(user: User) async {
        
        DispatchQueue.main.async{
            self.streams = []
        }
        
        let cursor:String?=nil
        let url = "https://api.twitch.tv/helix/streams/followed?user_id=\(user.id)"
        let headers = ["Authorization": "Bearer \(token!)", "Client-Id": clientID]
        
        repeat{
            do {
                if let data = await Request.perform(.GET, url: url, headers: headers) {
                    let followedStreamsData = try! decoder.decode(Streams.self, from:data)
                    let user_ids = followedStreamsData.data.map {(stream)-> String in
                        stream.user_id
                    }
                    let streams =  await getStreams(user_ids: user_ids)
                    let users = await getUsers(ids: user_ids)
                    let followedStreams = followedStreamsData.data.map { (followedStream) -> Stream in
                        let stream = streams.first(where: { $0.user_id == followedStream.user_id })
                        let user = users.first(where: { $0.id == followedStream.user_id })
                        let type = stream == nil ? "rerun" : "live"
                        return Stream(id: followedStream.id,
                                      user_id: followedStream.user_id,
                                      profile_image_url: user?.profile_image_url,
                                      game_name: followedStream.game_name,
                                      type: type,
                                      title: followedStream.title,
                                      user_name: followedStream.user_name,
                                      viewer_count: followedStream.viewer_count,
                                      started_at: followedStream.started_at, thumbnail_url:followedStream.thumbnail_url)
                        
                    }
                    DispatchQueue.main.async{
                        self.streams += followedStreams
                    }
                    
                }
            }
        } while(cursor != nil)
        
        
        
        DispatchQueue.main.async {
            [] in
            let userInfo: [String: Any] = ["count": self.streams.count, "streams": self.streams ]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "onStreamChange"), object: nil, userInfo: userInfo)
        }
        
    }
}

private struct ValidateResponse: Decodable {
    let client_id: String
    let login: String?
    let scopes: [String]
    let user_id: String?
    let expires_in: Int
}
