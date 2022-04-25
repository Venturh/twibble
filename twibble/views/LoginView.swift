import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var twitch: Twitch
    var body: some View {
        VStack(){
            HStack(alignment: .top){
                Spacer()
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
            Spacer()
            VStack{
                VStack{
                    Image("logo").resizable().frame(width: 64, height: 64)
                    Text("Welcome to Twibble").fontWeight(.medium)
                }
                Button(action: {twitch.login()}) {
                    Text("Login with Twitch").fontWeight(.medium)
                }
                .controlSize(.large)
                .foregroundColor(.black)
                .background(Color("brand"))
                
                
            }
            Spacer()
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
