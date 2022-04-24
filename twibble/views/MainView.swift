import SwiftUI



struct MainView: View {
    @State var twitch = Twitch()
    @AppStorage("isCompact") var isCompact = false
    
    let timer = Timer.publish(every: 90, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing:0){
            HeaderView(twitch: twitch)
            if  twitch.isLoggedIn {
                
                    StreamListView(twitch: twitch)
                        .onReceive(timer) { time in
                            if twitch.user != nil {
                                Task {
                                    await self.twitch.getFollowedStreams(user: self.twitch.user!)
                                }
                                
                            }
                        }
                
                
            } else {
                Spacer()
                LoginView()
                    .environmentObject(twitch)
            }
            Spacer()
        }
        
        .frame(width: isCompact ? 300 : 360, height: isCompact ? 420 : 522)
        .background(Color("bgPrimary"))
        .foregroundColor(Color("textPrimary"))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(twitch: Twitch())
            
    }
}


