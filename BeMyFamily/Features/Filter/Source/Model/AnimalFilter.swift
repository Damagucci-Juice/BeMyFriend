//
//  AnimalFilter.swift
//  BeMyFamily
//
//  Created by Gucci on 4/13/24.
//

import Foundation

struct AnimalFilter: Codable {          // MARK: 데이터 항목 설명 친구
                                        // 설명::필수여부(1-필,0-선택)::예시::
    let beginDate: Date?                // 시작날짜::0::YYYYMMDD
    let endDate: Date?                  // 종료날짜::0::YYYYMMDD
    let upkind: String?                 // 상위종(개고양이기타)::0::개-"417000", 고양이-"422400", 기타-"429900"
    let kind: String?                   // 품종코드::0::라브라도 리트리버-"000069"
    let sido: String?                   // 시도코드::0::제주특별자치도-"6500000"
    let sigungu: String?                // 시군구코드::0::서귀포시-   "6520000"
    let shelterNumber: String?          // 보호소번호::0::우리동물병원생명사회-"311322202000001"
    let processState: String?           // 전체: nil(빈값):: 공고중::"notice"::보호중"protect"
    let neutralizationState: String?    // 중성화여부::0::전체-nil,예:"Y",아니오:"N",미상:"U"
//    let pageNumber: String?             // 페이지번호::0::"4"
//    let numOfRows: String?              // 페이지당 보여줄 개수::0::"10"(기본10개)
    
    static let example: Self = .init(beginDate: .now,
                                     endDate: .now,
                                     upkind: "417000",
                                     kind: nil,
                                     sido: nil,
                                     sigungu: nil,
                                     shelterNumber: nil,
                                     processState: nil,
                                     neutralizationState: nil)
    
    func toParams() -> [String: String] {
        var dict = [String: String]()
        if let beginDate {
            dict.updateValue(dateFommater.string(from: beginDate), forKey: "bgnde")
        }
        if let endDate {
            dict.updateValue(dateFommater.string(from: endDate), forKey: "endde")
        }
        if let upkind {
            dict.updateValue(upkind, forKey: "upkind")
        }
        if let kind {
            dict.updateValue(kind, forKey: "kind")
        }
        if let sido {
            dict.updateValue(sido, forKey: "upr_cd")
        }
        if let sigungu {
            dict.updateValue(sigungu, forKey: "org_cd")
        }
        if let shelterNumber {
            dict.updateValue(shelterNumber, forKey: "care_reg_no")
        }
        if let processState {
            dict.updateValue(processState, forKey: "state")
        }
        if let neutralizationState {
            dict.updateValue(neutralizationState, forKey: "neuter_yn")
        }
        return dict
    }
}

fileprivate let dateFommater: DateFormatter = {
    let formmater = DateFormatter()
    formmater.locale = Locale(identifier: "ko_KR")
    formmater.dateFormat = "yyyyMMdd"
    return formmater
}()
