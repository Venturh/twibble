import Foundation
import SwiftUI
import LaunchAtLogin


struct StreamListView: View {
    
    @ObservedObject var twitch: Twitch
    
    @State private var lastHoveredId = ""

    
    
    var body: some View {
        
            VStack{
                if(twitch.streams.count > 0){
                    ForEach($twitch.streams, id: \.self) { stream in
                        StreamView(stream: stream,id: stream.id, lastHoveredId: $lastHoveredId)
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





