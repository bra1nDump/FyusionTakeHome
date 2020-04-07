import Foundation
import Combine

struct Fyuse: Codable {
    let uid: String
    let path: String
    let thumb: String
    let category: [String]
    let description: String?
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
        .eraseToAnyPublisher()
    }
}
