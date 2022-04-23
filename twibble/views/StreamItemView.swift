import SwiftUI

struct StreamItem: View {
    @Binding var stream: Stream
    var id: String
    
    @State private var isHovered = false
    @Binding var lastHoveredId: String
    
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
            HStack(){
                AsyncImage(url: URL(string: stream.thumbnail_url.replacingOccurrences(of: "{width}x{height}", with: "90x50")))
                    .frame(maxWidth: 90, maxHeight: 50)
                    .padding(4)
                
                VStack(alignment: .leading, spacing: 0){
                        HStack(){
                            Text(stream.user_name).font(.system(size: 14)).lineLimit(1)
                            Spacer()
                            HStack(alignment: .center ,spacing: 4){
                                Text(formatNumber(number:stream.viewer_count))
                                    .font(.system(size: 12))
                                Image(systemName: stream.type == "live" ? "circle.fill" : "return")
                                    .resizable()
                                    .frame(width: 8, height: 8)
                                    .foregroundColor(stream.type == "live" ? .red : Color("textSecondary"))
                            }
                            
                        }
                        
                    Text(stream.title).foregroundColor(Color("textSecondary"))
                        .font(.system(size: 12)).lineLimit(1)
                        .padding(.top,4)
                        .clipped()
                    HStack{
                        Text(stream.game_name).foregroundColor(Color("textSecondary")) .font(.system(size: 12)).lineLimit(1).clipped()
                        Spacer()
                        Text(timeAgoDisplay(string:stream.started_at)).foregroundColor(Color("textSecondary")) .font(.system(size: 12)).lineLimit(1).clipped()
                    }
                }
                
            }
            .padding(4)
        }
        .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .background(isHovered ? Color("accent") : .clear)
        .onChange(of: lastHoveredId) {
            isHovered = $0 == id
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



