import SwiftUI

struct StreamCompact: View {
    var stream: Stream
    var viewer_count : String
    
    var body: some View {
        HStack(){
            AsyncImage(url: URL(string: stream.profile_image_url!)){ image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 32, height: 32)
            .clipShape(Circle())
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
                Text(stream.game_name).foregroundColor(Color("textSecondary")) .font(.system(size: 12)).lineLimit(1).clipped()
            }
        }
    }
}





