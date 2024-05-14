//
//  FilterReducerTest.swift
//  BeMyFamilyTests
//
//  Created by Gucci on 5/14/24.
//

import XCTest
@testable import BeMyFamily

final class FilterReducerTest: XCTestCase {
    private var filterReducer: FilterReducer!

    override func setUpWithError() throws {
        try super.setUpWithError()
        self.filterReducer = DIContainer.makeFilterReducer()
    }

    override func tearDownWithError() throws {
        self.filterReducer = nil
        try super.tearDownWithError()
    }

    func testReset() throws {
        filterReducer.reset()
        XCTAssertEqual(filterReducer.kinds.count, 0, "kinds는 reset 이후 초기화되어야 합니다.")
        XCTAssertFalse(filterReducer.onProcessing, "onProcessing는 reset 이후 false여야 합니다.")
    }

    func testMakeFilter() throws {
        filterReducer.kinds.insert(.example)

        let madeFilter = filterReducer.makeFilter()
        XCTAssertNotNil(madeFilter[0].kind, "kind가 특정되지 않았습니다.")
        XCTAssertTrue(filterReducer.onProcessing, "진행상태가 true여야 합니다.")
    }
}
