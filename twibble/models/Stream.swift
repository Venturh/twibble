import Foundation

struct Streams: Decodable {
    struct Pagination: Decodable {
        let cursor: String?
    }

    let data: [Stream]
    let pagination: Pagination
}


struct Stream: Decodable, Identifiable, Hashable {
    let id: String
    let user_id: String
    var profile_image_url: String?
    let game_name: String
    var type: String
    let title: String
    let user_name: String
    let viewer_count: Int
    let started_at: String
    let thumbnail_url: String
}

