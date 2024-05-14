//
//  ProvinceReducerTest.swift
//  BeMyFamilyTests
//
//  Created by Gucci on 5/14/24.
//

import XCTest
@testable import BeMyFamily

final class ProvinceReducerTest: XCTestCase {

    private var provinceReducer: ProvinceReducer!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let testService = TestFamilyService()
        self.provinceReducer = DIContainer.makeProvinceReducer(service: testService)
    }

    override func tearDownWithError() throws {
        self.provinceReducer = nil
        try super.tearDownWithError()
    }

    func testHasInfos() async throws {
        await self.provinceReducer.loadInfos()
        XCTAssertFalse(self.provinceReducer.sido.isEmpty, "Sido 값을 불러오는데 실패했습니다..")
        XCTAssertFalse(self.provinceReducer.province.isEmpty, "Sigungu 값을 불러오는데 실패했습니다.")
        XCTAssertFalse(self.provinceReducer.kind.isEmpty, "Kin 값을 불러오는데 실패했습니다..")
        XCTAssertFalse(self.provinceReducer.shelter.isEmpty, "Shelter 값을 불러오는데 실패했습니다.")
    }
}
