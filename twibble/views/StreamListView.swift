import Foundation
import SwiftUI
import KeyboardShortcuts

struct StreamListView: View {
    
    @ObservedObject var twitch: Twitch
    
    @State private var selectedIndex = 0
    @State private var lastHoveredId = ""
        
    @Environment(\.openURL) var openURL
    

    var body: some View {
        VStack{
            if(twitch.streams.count > 0){
                ScrollViewReader { scrollView in
                    ScrollView(.vertical) {
                        ForEach(Array($twitch.streams.enumerated()), id: \.0) { (index, stream) in
                            StreamView(stream: stream, index: index, selectedIndex: selectedIndex, lastHoveredId: $lastHoveredId)
                                .onHover { isHovered in
                                    if isHovered {
                                        lastHoveredId = stream.id
                                    } else if lastHoveredId == stream.id {
                                        lastHoveredId = stream.id
                                    }
                                }
                            
                        }
                    }
                    .onChange(of: selectedIndex) { target in
                        withAnimation {
                            scrollView.scrollTo(target, anchor: .bottom)
                        }
                    }
                }
            } else {
                Spacer()
                Text("No stream online")
            }
        }
        .background(KeyAware(onEvent: {
            if $0 == .downArrow{
                if selectedIndex + 1 < twitch.streams.count  {
                    selectedIndex += 1
                } else {
                    selectedIndex = 0
                }
            } else if $0 == .upArrow {
                if selectedIndex - 1 >= 0 {
                    selectedIndex -= 1
                } else {
                    selectedIndex = (twitch.streams.count-1)
                }
            } else if $0 == .return{
                let selectedStream = twitch.streams[selectedIndex]
                if(selectedStream != nil) {
                    openURL(URL(string:"https://www.twitch.tv/\(selectedStream.user_name)")!)
                }
            }
            
        }))
        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
    }
}





