//
//  Animal.swift
//  BeMyFamily
//
//  Created by Gucci on 4/17/24.
//

import Foundation

struct Animal: Codable, Identifiable {
    let id: String
    let thumbnailURL: String
    let happenDt, happenPlace, kindCD, colorCD: String
    let age, weight, noticeNo, noticeSdt: String
    let noticeEdt: String
    let animalPhotoURL: String
    let processState: String
    let sexCD: String
    let neuterYn: String
    let specialMark, careNm, careTel, careAddr: String
    let orgNm, chargeNm, officetel: String

    enum CodingKeys: String, CodingKey {
        case thumbnailURL = "filename"
        case animalPhotoURL = "popfile"
        case happenDt, happenPlace
        case kindCD = "kindCd"
        case colorCD = "colorCd"
        case age, weight, noticeNo, noticeSdt, noticeEdt, processState
        case sexCD = "sexCd"
        case neuterYn, specialMark, careNm, careTel, careAddr, orgNm, chargeNm, officetel
        case id = "desertionNo"
    }
    // 중성화 여부, 성별 등의 타입을 쓰고 싶으면 NestedType 사용을 고려해야함
}