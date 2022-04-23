import SwiftUI
import LaunchAtLogin

struct HeaderView: View {
    @ObservedObject var twitch: Twitch
    @AppStorage("isCompact") var isCompact = false
    var body: some View {
        HStack {
            
                HStack{
                    Text("Twibble").fontWeight(.medium)
                }
                .font(.callout)
                .foregroundColor(Color("textSecondary"))
                
            
            Spacer()
            Menu {
                if  twitch.isLoggedIn {
                    Link(destination: URL(string: "https://www.twitch.tv/\(twitch.user?.display_name ?? "")")!, label: {
                        Text(twitch.user?.display_name ?? "")
                    }
                    )
                } else {
                    Text("Not logged in")
                }
                Divider()
                Toggle(isOn: $isCompact){
                    Text("Compact")
                }
                LaunchAtLogin.Toggle {
                    Text("Launch at login")
                }
                Divider()
                if twitch.isLoggedIn{
                    Button("Logout", action: {
                        Task {
                            await twitch.logout()
                        }
                    })
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
