import SwiftUI
import KeyboardShortcuts


struct MainView: View {
    @State var twitch = Twitch()
    @AppStorage("isCompact") var isCompact = false
    @State var currentView = "streams"
    
    let timer = Timer.publish(every: 90, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack{
            VStack{
                VStack(){
                    if  twitch.isLoggedIn {
                        if currentView == "streams" {
                            StreamListView(twitch: twitch)
                                .onReceive(timer) { time in
                                    if twitch.user != nil {
                                        Task {
                                            await self.twitch.getFollowedStreams(user: self.twitch.user!)
                                        }
                                        
                                    }
                                }
                            
                        } else {
                            SettingsView(twitch: twitch, currentView: $currentView)
                        }
                    } else {
                        Spacer()
                        LoginView()
                            .environmentObject(twitch)
                    }
                    Spacer()
                    HeaderView(twitch: twitch, currentView: $currentView)
                }
            }
            .padding(12)
        }
        
        .frame(width: isCompact ? 300 : 360, height: 522)
        .background(Color("bgPrimary"))
        .foregroundColor(Color("textPrimary"))
        .onAppear{
            KeyboardShortcuts.onKeyUp(for: .toggleView) { [self] in
                if currentView == "streams" {
                    currentView = "settings"
                } else {
                    currentView = "streams"
                }
            }
        }
        
    }
        
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(twitch: Twitch()) 
    }
}


