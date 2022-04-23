import SwiftUI



struct MainView: View {
    @State var twitch = Twitch()
    
    let timer = Timer.publish(every: 90, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing:0){
            HeaderView(twitch: twitch)
            if  twitch.isLoggedIn {
                ScrollView {
                    StreamView(twitch: twitch)
                        .padding(.trailing)
                        .onReceive(timer) { time in
                            if twitch.user != nil {
                                Task {
                                    await self.twitch.getFollowedStreams(user: self.twitch.user!)
                                }
                                
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
        
        .frame(width: 420, height: 600)
        .background(Color("bgPrimary"))
        .foregroundColor(Color("textPrimary"))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(twitch: Twitch())
            
    }
}


