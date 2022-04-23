import SwiftUI
import LaunchAtLogin

struct HeaderView: View {
    @ObservedObject var twitch: Twitch
    
    var body: some View {
        HStack {
            if(twitch.isLoggedIn){
                HStack{
                    Image("logo").resizable().frame(width: 24, height: 24, alignment: .center)
                    Text("Twibble")
                }
            }
            Spacer()
            Menu {
                if  twitch.isLoggedIn {
                    Link(destination: URL(string: "https://www.twitch.tv/\(twitch.user?.display_name ?? "")")!, label: {
                        Text(twitch.user?.display_name ?? "")
                    }
                    )
                    
                    Button("Logout", action: {
                        Task {
                            await twitch.logout()
                        }
                    })
                    
                } else {
                    Text("Not logged in")
                }
                Divider()
                
                LaunchAtLogin.Toggle {
                    Text("Launch at login")
                }
                Button("Quit", action: {
                    NSApplication.shared.terminate(nil)
                })
            } label: {
                Image(systemName: "gearshape.fill")
            }
            
            .menuIndicator(.hidden)
            .menuStyle(.borderlessButton)
            .fixedSize()
            
        }
        
        .padding(8)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(twitch:Twitch())
    }
}




extension NSButton {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
