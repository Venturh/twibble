import SwiftUI
import KeyboardShortcuts

struct HeaderView: View {
    @ObservedObject var twitch: Twitch
    @AppStorage("isCompact") var isCompact = false
    @Binding var currentView: String
    
    var toogleDescription = KeyboardShortcuts.Name.toogleApp.shortcut?.description ?? KeyboardShortcuts.Name.toogleApp.defaultShortcut!.description
    
    var body: some View {
        HStack(alignment: .center) {
            HStack(alignment: .center){
                Text("Twibble").fontWeight(.medium)
                Text("\(toogleDescription) to toggle")
            }
           .font(.system(size: 12))
            .foregroundColor(Color("textSecondary"))

            Spacer()
            
            Button(action: {
                if currentView == "streamList" {
                    currentView = "settings"
                } else {
                    currentView = "streamList"
                }
            } ){
                Image(systemName: "gearshape").foregroundColor(Color("textSecondary"))
            }
            .buttonStyle(.borderless)
            .help(KeyboardShortcuts.Name.toggleView.shortcut!.description )

            .fixedSize()
        }
    }
}


struct PopoverView: View {
    var body: some View {
        VStack {
            Text("Some text here ").padding()
            Button("Resume") {
            }
        }.padding()
    }
}





