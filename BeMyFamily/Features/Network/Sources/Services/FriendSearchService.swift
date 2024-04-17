//
//  FriendSearchService.swift
//  BeMyFamily
//
//  Created by Gucci on 4/11/24.
//

import Foundation
import Combine

public enum HTTPError: Error {
    case notFoundResponse
    case notFoundURL
    case invalidResponse(_ errorCode: Int)
}

public struct HttpStatusCode {
    public struct Informational {
        static let range = 100..<200
    }

    public struct Success {
        static let range = 200..<300
    }

    public struct Redirection {
        static let range = 300..<400
    }

    public struct ClientError {
        static let range = 400..<500
        static let badRequest = 400
        static let notFoundError = 401
    }

    public struct ServerError {
        static let range = 500..<600
    }
}

protocol SearchService: AnyObject {
    func search(_ endpoint: FriendEndpoint) -> AnyPublisher<Data, Error>
    func search(_ endpoint: FriendEndpoint) async throws -> Data?
    func performRequest(urlRequest: URLRequest) -> AnyPublisher<Data, Error>
    func performRequest(urlRequest: URLRequest) async throws -> Data?
}

final class FriendSearchService: ObservableObject, SearchService {
    private let session: URLSession
    private let friendCache: NSCache<NSString, CacheEntryObject> = NSCache()

    public init(session: URLSession = .shared) {
        self.session = session
    }

    func search(_ endpoint: FriendEndpoint) -> AnyPublisher<Data, Error> {
        return performRequest(urlRequest: endpoint.makeURLRequest())
    }

    func performRequest(urlRequest: URLRequest) -> AnyPublisher<Data, Error> {
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw HTTPError
                        .invalidResponse(HttpStatusCode.ClientError.badRequest)
                }
                guard (HttpStatusCode.Success.range).contains(httpResponse.statusCode) else {
                    if httpResponse.statusCode == HttpStatusCode.ClientError.notFoundError {
                        throw HTTPError.notFoundResponse
                    } else {
                        throw HTTPError.invalidResponse(httpResponse.statusCode)
                    }
                }
                return data
            }
            .eraseToAnyPublisher()
    }

    public func search(_ endpoint: FriendEndpoint) async throws -> Data? {
        return try await performRequest(urlRequest: endpoint.makeURLRequest())
    }

    public func performRequest(urlRequest: URLRequest) async throws -> Data? {
        guard let url = urlRequest.url else { throw HTTPError.notFoundURL }
        if let cached = friendCache[url] {
            switch cached {
            case .ready(let result):
                return result
            case .inprogress(let task):
                return try await task.value
            }
        }
        let task = Task<Data, Error> {
            let (data, _) = try await session.data(for: urlRequest, delegate: nil)
            return data
        }

        friendCache[url] = .inprogress(task)
        do {
            let fetchedData = try await task.value
            friendCache[url] = .ready(fetchedData)
            return fetchedData
        } catch {
            friendCache[url] = nil
            throw HTTPError.invalidResponse(HttpStatusCode.ClientError.notFoundError)
        }
    }
}
