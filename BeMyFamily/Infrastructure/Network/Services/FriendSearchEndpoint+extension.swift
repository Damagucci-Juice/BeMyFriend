//
//  FriendSearchEndpoint+extension.swift
//  BeMyFamily
//
//  Created by Gucci on 4/13/24.
//

import Foundation

extension FamilyEndpoint {
    func makeURL() -> URL {
        let urlString = baseURL.absoluteString + path
        guard let url = URL(string: urlString) else {
            fatalError("Failed to create URL for endpoint: \(urlString)")
        }
        guard let addedParameterURL = makeURLComponent(url).url else {
            fatalError("Failed to create URL for endpoint: \(urlString)")
        }
        return addedParameterURL
    }

    func makeURLComponent(_ url: URL) -> URLComponents {
        guard var component = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            fatalError("Failed to create URLComponents for endpoint: \(baseURL)")
        }
        component.queryItems = parameter.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        component.percentEncodedQuery = component.percentEncodedQuery?.replacingOccurrences(of: "%25", with: "%")
        return component
    }

    func makeURLRequest() -> URLRequest {
        let url = makeURL()
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        return request
    }
}
