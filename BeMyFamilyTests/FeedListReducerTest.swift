//
//  FeedListReducerTest.swift
//  FeedListReducerTest
//
//  Created by Gucci on 5/12/24.
//

import XCTest
@testable import BeMyFamily

final class FeedListReducerTest: XCTestCase {

    private var feedListReducer: FeedListReducer!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let testService = TestFamilyService()
        let filterReducer = DIContainer.makeFilterReducer()
        self.feedListReducer = DIContainer.makeFeedListReducer(filterReducer,
                                                               service: testService)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.feedListReducer = nil
        try super.tearDownWithError()
    }

    // MARK: - Fetch Throttling Test
    func testFetchAnimalsIfCan() async throws {
        await feedListReducer.fetchAnimalsIfCan()
        XCTAssertNotNil(feedListReducer.animalDict[.feed])

    }

    func testTabTouched() throws {
        feedListReducer.setMenu(.favorite)
        XCTAssertEqual(feedListReducer.menu, FriendMenu.favorite, "탭 변환이 실패했습니다.")
    }

    // TODO: - Multi Filter Fetch는 어떻게 테스트를 할 것인가?
    func testFetchingMultiFilteredAnimals() async throws {
        // Test시에는 하나의 필터 엘리먼트마다 10개의 리소스가 로드됨, 필터 3개를 요청하니 결과는 30이여야함
        feedListReducer.setMenu(.filter)
        await feedListReducer.fetchAnimalsIfCan([.example, .example, .example])
        let fetchedAnimals = feedListReducer.animalDict[.filter]
        XCTAssertNotNil(fetchedAnimals)
        XCTAssertEqual(fetchedAnimals?.count, 30)
    }
}
