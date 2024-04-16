//
//  AnimalResponse.swift
//  BeMyFamily
//
//  Created by Gucci on 4/14/24.
//

import Foundation

/*
 //MARK: -  Example Animal Response
 
 {
     "response": {
         "header": {
             "reqNo": 248405531,
             "resultCode": "00",
             "resultMsg": "NORMAL SERVICE."
         },
         "body": {
             "items": {
                 "item": [
                     {
                         "desertionNo": "442418202400436",
                         "filename": "http://www.animal.go.kr/files/shelter/2024/04/202404141404467_s.jpg",
                         "happenDt": "20240414",
                         "happenPlace": "소양강로 32",
                         "kindCd": "[개] 라브라도 리트리버",
                         "colorCd": "검정",
                         "age": "2017(년생)",
                         "weight": "25(Kg)",
                         "noticeNo": "강원-춘천-2024-00139",
                         "noticeSdt": "20240414",
                         "noticeEdt": "20240424",
                         "popfile": "http://www.animal.go.kr/files/shelter/2024/04/202404141404467.jpg",
                         "processState": "종료(반환)",
                         "sexCd": "F",
                         "neuterYn": "U",
                         "specialMark": "바랜주황목줄 착용, 온순함.",
                         "careNm": "춘천시 동물보호센터",
                         "careTel": "033-245-5351",
                         "careAddr": "강원도 춘천시 신북읍 영서로 3282 (신북읍) (전)102보충대 주차장",
                         "orgNm": "강원특별자치도 춘천시",
                         "chargeNm": "춘천시 동물보호센터",
                         "officetel": "033-245-5785"
                     }
                 ]
             },
             "numOfRows": 10,
             "pageNo": 1,
             "totalCount": 1
         }
     }
 }
 
 */

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
    let item: [Item]
}

// MARK: - Item
struct Item: Codable {
    let id: String
    let thumbnailURL: String
    let happenDt, happenPlace, kindCD, colorCD: String
    let age, weight, noticeNo, noticeSdt: String
    let noticeEdt: String
    let animalPhotoURL: String
    let processState: String
    let sexCD: SexCD
    let neuterYn: NeuterYn
    let specialMark, careNm, careTel, careAddr: String
    let orgNm, chargeNm, officetel: String

    enum CodingKeys: String, CodingKey {
        case thumbnailURL = "filename"
        case animalPhotoURL = "popfile"
        case happenDt, happenPlace
        case kindCD = "kindCd"
        case colorCD = "colorCd"
        case age, weight, noticeNo, noticeSdt, noticeEdt,processState
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

//i love you, my doggie -niko
