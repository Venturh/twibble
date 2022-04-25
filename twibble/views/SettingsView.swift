import SwiftUI
import KeyboardShortcuts
import LaunchAtLogin

struct SettingsView: View {
    
    @ObservedObject var twitch: Twitch
    @AppStorage("isCompact") var isCompact = false
    @ObservedObject private var launchAtLogin = LaunchAtLogin.observable
    @Binding var currentView: String
    
    var body: some View {
        let user = twitch.user
        VStack(alignment: .leading ,spacing: 12){
            HStack{
                Button(
                    action: {
                        currentView = "streams"
                    },
                    label: {
                        Image(systemName: "arrow.left").foregroundColor(Color("textSecondary"))
                    }
                )
                .buttonStyle(.plain)
                Text("Preferences").font(.body)
            }
            HStack(alignment:.top){
                AsyncImage(url: URL(string: twitch.user?.profile_image_url ?? "")){ image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .padding(4)
                if user != nil {
                    VStack(alignment: .leading){
                        Text(user!.display_name).lineLimit(1).font(.system(size: 14))
                        Text("Online").font(.system(size: 12)).foregroundColor(Color("textSecondary"))
                    }
                    
                }
                Spacer()
                HStack{
                    Button(
                        action: {
                            Task{
                                await twitch.logout()
                            }
                        },
                        label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right").foregroundColor(Color("textSecondary"))
                        }
                    )
                    .buttonStyle(.plain)
                    Button(
                        action: {
                            NSApplication.shared.terminate(nil)
                        },
                        label: {
                            Image(systemName: "xmark").foregroundColor(Color("textSecondary"))
                        }
                    )
                    .buttonStyle(.plain)
                }
                
            }
            
            VStack(spacing:12){
                Toggle(isOn: $isCompact){
                    Text("Compact").frame(maxWidth: .infinity, alignment: .leading)
                }
                .toggleStyle(.switch).tint(.accentColor)
                Toggle(isOn: $launchAtLogin.isEnabled){
                    Text("Launch at login").frame(maxWidth: .infinity, alignment: .leading)
                }
                .toggleStyle(.switch).tint(.accentColor)
            }
            Form {
                KeyboardShortcuts.Recorder(for: .toogleApp) {
                    Text("Toggle App").frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            Form {
                KeyboardShortcuts.Recorder(for: .toggleView) {
                    Text("Toggle View").frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
}


extension NSSwitch {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
