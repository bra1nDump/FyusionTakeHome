import XCTest
@testable import FyusionTakeHome

class FyusionTakeHomeTests: XCTestCase {

    func testApi() {
        let expecation = expectation(description: "wait for api to return")
        let api = Api()
        let handle =
            api.fyuses()
            .sink { fyuses in
                XCTAssert(fyuses.count > 1)
                expecation.fulfill()
            }
        
        wait(for: [expecation], timeout: 1)
        handle.cancel()
    }
}
