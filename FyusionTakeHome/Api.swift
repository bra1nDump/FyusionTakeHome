import Foundation
import Combine

struct Fyuse: Codable {
    let uid: String
    let path: String
    let thumb: String
    let category: [String]
    let description: String?
    
    #if DEBUG
    static var sample =
        Fyuse(
            uid: "inside_trunk",
            path: "https://i.fyuse.com/group/qkfxcn9nlvee7ip3/jlp75qdubezgc/snaps/img_oDLiEj3QxhWdRwJS.jpg",
            thumb: "https://i.fyuse.com/group/qkfxcn9nlvee7ip3/jlp75qdubezgc/snaps/img_oDLiEj3QxhWdRwJS_thumb.jpg",
            category: [ "interior" ],
            description: nil
        )
    #endif
}

extension Fyuse: Identifiable {
    var id: String { uid }
}

fileprivate struct Response: Codable {
    struct Data: Codable {
        let list: [Fyuse]
    }
    
    let data: Data
    
    static func parse(_ data: Foundation.Data) throws -> Self {
        try JSONDecoder().decode(Response.self, from: data)
    }
}

class Api {
    func fyuses() -> AnyPublisher<[Fyuse], Never> {
        URLSession.shared.dataTaskPublisher(
            for: URL(string: "https://api.fyu.se/1.4/group/web/jlp75qdubezgc?abspath=1")!)
        .tryMap { try Response.parse($0.0).data.list }
        .replaceError(with: [])
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
