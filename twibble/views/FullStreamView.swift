import SwiftUI

struct FullStreamView: View {
    var stream: Stream
    var viewer_count : String
    var ago: String
    
    var body: some View {
            HStack(){
                AsyncImage(url: URL(string: stream.thumbnail_url.replacingOccurrences(of: "{width}x{height}", with: "90x45"))){ image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .cornerRadius(5)
                .frame(width: 90, height: 45)
                .padding(4)

                VStack(alignment: .leading, spacing: 0){
                        HStack(){
                            Text(stream.user_name).font(.system(size: 14)).lineLimit(1)
                            Spacer()
                            HStack(alignment: .center ,spacing: 4){
                                Text(viewer_count)
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
                        Text(ago).foregroundColor(Color("textSecondary")) .font(.system(size: 12)).lineLimit(1).clipped()
                    }
                }
        }
    }
}





