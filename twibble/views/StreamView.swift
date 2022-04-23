import Foundation
import SwiftUI
import LaunchAtLogin


struct StreamView: View {
    
    @ObservedObject var twitch: Twitch
    
    @State private var lastHoveredId = ""

    
    
    var body: some View {
        
            VStack{
                if(twitch.streams.count > 0){
                    ForEach($twitch.streams, id: \.self) { stream in
                        StreamItem(stream: stream,id: stream.id, lastHoveredId: $lastHoveredId)
                            .onHover { isHovered in
                                if isHovered {
                                    lastHoveredId = stream.id
                                } else if lastHoveredId == stream.id {
                                    lastHoveredId = stream.id
                                }
                            }
                    }
                    
                } else {
                    Spacer()
                    Text("No stream online")
                }
            }
        }
}





