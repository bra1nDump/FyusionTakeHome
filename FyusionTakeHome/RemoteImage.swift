import SwiftUI
import Combine

struct RemoteImage: View {
    class Model: ObservableObject {
        var image: UIImage { loadedImage ?? UIImage(named: "placeholder")! }
        @Published private var loadedImage: UIImage?
        private var downloadHandle: AnyCancellable?
        
        private let urlString: String
        
        init(urlString: String) {
            self.urlString = urlString
        }
        
        func load() {
            // avoid loading on repeated appearance
            guard loadedImage == nil else { return }
            guard let url = URL(string: self.urlString) else { return }
            self.downloadHandle =
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
        .scaledToFit()
        .onAppear(perform: model.load)
    }
}
