//
//  Networking.swift
//  OMMovie
//
//  Created by Trung A on 12/02/2023.
//

import Foundation
import Combine

// MARK: - HTTP Methods
enum HttpMethod: Equatable {
    case get([URLQueryItem])
    case put(Data?)
    case post(Data?)
    case delete
    case head

    var name: String {
        switch self {
        case .get: return "GET"
        case .put: return "PUT"
        case .post: return "POST"
        case .delete: return "DELETE"
        case .head: return "HEAD"
        }
    }
}

// MARK: - Request
struct Request<Response> {
    let url: URL
    let method: HttpMethod
    var headers: [String: String] = [:]
}

extension Request {
    var urlRequest: URLRequest {
        var request = URLRequest(url: url)
        
        switch method {
        case .post(let data), .put(let data):
            request.httpBody = data
        case let .get(queryItems):
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                preconditionFailure("Couldn't create a url from components...")
            }
            request = URLRequest(url: url)
        default:
            break
        }
        
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.name
        return request
    }
}

// MARK: - URLSession Helpers
extension URLSession {
    enum Error: Swift.Error {
        case networking(URLError)
        case decoding(Swift.Error)
    }

    func publisher(
        for request: Request<Data>
    ) -> AnyPublisher<Data, Swift.Error> {
        dataTaskPublisher(for: request.urlRequest)
            .mapError(Error.networking)
            .map(\.data)
            .eraseToAnyPublisher()
    }

    func publisher(
        for request: Request<URLResponse>
    ) -> AnyPublisher<URLResponse, Swift.Error> {
        dataTaskPublisher(for: request.urlRequest)
            .mapError(Error.networking)
            .map(\.response)
            .eraseToAnyPublisher()
    }

    func publisher<Value: Decodable>(
        for request: Request<Value>,
        using decoder: JSONDecoder = .init()
    ) -> AnyPublisher<Value, Swift.Error> {
        dataTaskPublisher(for: request.urlRequest)
            .mapError(Error.networking)
            .map(\.data)
            .decode(type: Value.self, decoder: decoder)
            .mapError(Error.decoding)
            .eraseToAnyPublisher()
    }
}
