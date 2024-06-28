//
//  Animal.swift
//  BeMyFamily
//
//  Created by Gucci on 4/17/24.
//

import Foundation

@Observable
final class Animal: Codable, Equatable, Identifiable {
    let id: String
    let thumbnailURL: String
    let happenDt, happenPlace, kindCD, colorCD: String
    let age, weight, noticeNo, noticeSdt: String
    let noticeEdt: String
    let photoURL: String
    let processState: String
    let sexCD: SexCD
    let neuterYn: Neutralization
    let specialMark, careNm, careTel, careAddr: String
    let orgNm, chargeNm, officetel: String
    var isFavorite = false

    enum CodingKeys: String, CodingKey {
        case thumbnailURL = "filename"
        case photoURL = "popfile"
        case happenDt, happenPlace
        case kindCD = "kindCd"
        case colorCD = "colorCd"
        case age, weight, noticeNo, noticeSdt, noticeEdt, processState
        case sexCD = "sexCd"
        case neuterYn, specialMark, careNm, careTel, careAddr, orgNm, chargeNm, officetel
        case id = "desertionNo"
    }
}

extension Animal: Hashable {
    static func == (lhs: Animal, rhs: Animal) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
