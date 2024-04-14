//
//  AnimalResponse.swift
//  BeMyFamily
//
//  Created by Gucci on 4/14/24.
//

import Foundation

struct AnimalResponse: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let header: Header
    let body: Body
}

// MARK: - Body
struct Body: Codable {
    let items: Items
    let numOfRows, pageNo, totalCount: Int
}

// MARK: - Items
struct Items: Codable {
    let item: [AnimalDTO]
}

// MARK: - Item
struct AnimalDTO: Codable, Hashable, Identifiable {
    let id: String
    let filename: String
    let happenDt, happenPlace, kindCD, colorCD: String
    let age, weight, noticeNo, noticeSdt: String
    let noticeEdt: String
    let popfile: String
    let processState: String
    let sexCD: SexCD
    let neuterYn: NeuterYn
    let specialMark, careNm, careTel, careAddr: String
    let orgNm, chargeNm, officetel: String

    enum CodingKeys: String, CodingKey {
        case filename, happenDt, happenPlace
        case kindCD = "kindCd"
        case colorCD = "colorCd"
        case age, weight, noticeNo, noticeSdt, noticeEdt, popfile, processState
        case sexCD = "sexCd"
        case neuterYn, specialMark, careNm, careTel, careAddr, orgNm, chargeNm, officetel
        case id = "desertionNo"
    }
}

enum NeuterYn: String, Codable {
    case no = "N"
    case yes = "Y"
    case unknown = "U"
}

enum SexCD: String, Codable {
    case female = "F"
    case male = "M"
    case unknown = "Q"
}

// MARK: - Header
struct Header: Codable {
    let reqNo: Int
    let resultCode, resultMsg: String
}
