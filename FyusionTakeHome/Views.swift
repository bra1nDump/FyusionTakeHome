import SwiftUI
import Combine

struct AppView: View {
    var body: some View {
        NavigationView {
            FyuseList()
        }
    }
}

struct FyuseList: View {
    class Model: ObservableObject {
        @Published var fyuses: [Fyuse] = []
        private var handle: AnyCancellable?
        
        init () {
            handle = Api().fyuses()
                .sink { self.fyuses = $0 }
        }
    }
    
    @ObservedObject var model = Model()
    
    var body: some View {
        List.init(model.fyuses, rowContent: FyuseRow.init)
    }
}

struct FyuseRow: View {
    var fyuse: Fyuse
    var body: some View {
        NavigationLink(destination: FyuseDetail(fyuse: fyuse)) {
            HStack {
                RemoteImage(urlString: fyuse.thumb)
                    .frame(width: 80, height: 60, alignment: .center)
                Text(fyuse.uid)
            }
        }
    }
}

struct FyuseDetail: View {
    var fyuse: Fyuse
    
    var category: String {
        "Categor\(fyuse.category.count > 1 ? "ies" : "y"): "
        + fyuse.category.joined(separator: ", ")
    }
    var description: String { fyuse.description ?? "No description" }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                RemoteImage(urlString: self.fyuse.path)
                    .frame(width: geometry.size.width)
                Text(self.category)
                Text(self.description)
            }
        }
        .navigationBarTitle(fyuse.uid)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Helpers
            RemoteImage(urlString: "https://i.fyuse.com/group/qkfxcn9nlvee7ip3/jlp75qdubezgc/snaps/img_oDLiEj3QxhWdRwJS_thumb.jpg")
                .frame(width: 80, height: 60, alignment: .center)
            
            // App UI elements
            FyuseList()
            FyuseRow(fyuse: Fyuse.sample)
            FyuseDetail(fyuse: Fyuse.sample)
        }
    }
}
#endif
