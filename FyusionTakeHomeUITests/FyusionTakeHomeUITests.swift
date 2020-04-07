import XCTest

class FyusionTakeHomeUITests: XCTestCase {

    func testNavigateToDetailAndBack() {
        let app = XCUIApplication()
        app.launch()
        
        app.tables.buttons["external_front_head_on"].tap()
        app.navigationBars["external_front_head_on"].buttons["Back"].tap()
    }
}
