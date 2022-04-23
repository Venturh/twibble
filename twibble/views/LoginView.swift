//
//  LoginView.swift
//  twibble
//
//  Created by Max on 23.04.22.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var twitch: Twitch
    var body: some View {
        VStack(spacing: 48){
            VStack(spacing: 8){
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
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
