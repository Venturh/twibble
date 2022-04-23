import Foundation

struct Users: Decodable {
    let data: [User]
}


struct User: Decodable, Equatable {
    let id: String
    let login: String
    let display_name: String
    let type: String
    let broadcaster_type: String
    let description: String
    let profile_image_url: String
    let offline_image_url: String
    let view_count: Int
    let created_at: String
}
