import SwiftUI
import Combine

struct RemoteImage: View {
    class Model: ObservableObject {
        var image: UIImage { loadedImage ?? UIImage(named: "placeholder")! }
        @Published private var loadedImage: UIImage?
        private var downloadHandle: AnyCancellable?
        
        init(urlString: String) {
            guard let url = URL(string: urlString) else { return }
            downloadHandle =
                URLSession.shared
                .dataTaskPublisher(for: url)
                .map { result -> Data? in result.0 }
                .replaceError(with: nil)
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .sink { self.loadedImage = UIImage(data: $0) }
        }
    }
    
    @ObservedObject private var model: Model
    
    init(urlString: String) {
        model = Model(urlString: urlString)
    }
    
    var body: some View {
        Image(uiImage: model.image)
        .resizable()
        .scaledToFill()
    }
}
