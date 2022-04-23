//
//  Request.swift
//  Frosty
//
//  Created by Tommy Chow on 6/3/21.
//
import Foundation

struct Request {
    private static let session = URLSession.shared
    static let decoder = JSONDecoder()

    enum HTTPMethod: String {
        case GET
        case POST
    }

    static func perform(_ method: HTTPMethod, url: String, headers: [String: String]? = nil,  queries: [URLQueryItem]? = nil) async -> Data? {
        
        var urlComponent = URLComponents(string: url)!
        if let queries = queries {
            urlComponent.queryItems = queries
        }
        
        
        

        var request = URLRequest(url: urlComponent.url!)
        
        switch method {
        case .GET:
            request.httpMethod = "GET"
        case .POST:
            request.httpMethod = "POST"
        }

        if let headers = headers {
            for header in headers {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, (200 ... 299).contains(httpResponse.statusCode) else {
                print("ERROR: NON 200-LEVEL RESPONSE", response)
                return nil
            }
            
            return data
        } catch {
            print("Request failed to \(url)")
            return nil
        }
    }
}
