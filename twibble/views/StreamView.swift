import SwiftUI

struct StreamView: View {
    @Binding var stream: Stream
    var index: Int
    var selectedIndex: Int
    
    @State private var isHovered = false
    @Binding var lastHoveredId: String
    @AppStorage("isCompact") var isCompact = false
    
    func formatNumber(number: Int) -> String {
        return Formatter.number.string(for: number) ?? ""
    }
    
    func timeAgoDisplay(string:String) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        
        let date = dateFormatter.date(from: string)
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        if(date != nil){
            return "started \(formatter.localizedString(for: date!, relativeTo: Date()))"
        }
        return "started unkown"
    }
    
    
    
    
    var body: some View {
        Link(destination: URL(string: "https://www.twitch.tv/\(stream.user_name)")!){
            if(isCompact){
                CompactStreamView(
                    stream: stream,
                    viewer_count: formatNumber(number:stream.viewer_count)
                )
            } else {
                FullStreamView(
                    stream: stream,
                    viewer_count: formatNumber(number:stream.viewer_count),
                    ago: timeAgoDisplay(string:stream.started_at))
            }
            
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(selectedIndex == index ? Color("accentPrimary") : isHovered ? Color("accentSecondary") : .clear)
        .onChange(of: lastHoveredId) {
            isHovered = $0 == stream.id
        }
        
    }
    
        
}


extension Formatter {
    static let number: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: NSLocale.current.languageCode ?? "en-US")
        return formatter
    }()
}



