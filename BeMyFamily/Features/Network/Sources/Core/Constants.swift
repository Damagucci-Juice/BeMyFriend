//
//  Constants.swift
//  BeMyFamily
//
//  Created by Gucci on 4/11/24.
//

import Foundation

struct Constants {

    struct Network {
        static let baseUrlPath = "http://apis.data.go.kr/1543061/abandonmentPublicSrvc/"
        static let sidoPath = "sido"
        static let sigunguPath = "sigungu"
        static let shelterPath = "shelter"
        static let kindPath = "kind"
        static let animalPath = "abandonmentPublic"
        static let dbPath = "SavedAnimals"
    }

    struct NetworkParameters {
        static let totalSidoCount = "17"
    }

    struct Translations {
        static let loading = "Loading"
        static let okay = "OK"
        static let cancel = "Cancel"

    }

    struct Error {
        static let jsonDecodingError = "Error: JSON decoding error."
        static let noDataError = "Error: No data received."
        static let noResultsFound = "No results were found for your search."
        static let statusCode404 = "404"
        static let notFound = "Error 401 Animal not found"
        static let responseHadError = "Something went wrong."
    }
    
    struct TestFile {
        static let sido = "Sido.json"
        static let sigungu = "Sigungu.json"
        static let kind = "Kind.json"
        static let shelter = "Shelter.json"
        static let animal = "Animal.json"

        static let emptyShelter = "EmptyShelter.json"
        static let emptyAnimal = "EmptyAnimal.json"
    }
}
