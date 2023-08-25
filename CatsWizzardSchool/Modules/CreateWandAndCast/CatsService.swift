//
//  CatsService.swift
//  CatsWizzardSchool
//
//  Created by Vladimir Bebeshko on 8/22/23.
//

import Foundation
import Combine
import OSLog

class CatsService {
    func nextCat() -> AnyPublisher<String, Never> {
        guard !catURLs.isEmpty && catIndex < catURLs.count else {
            return loadCats()
        }

        let cat = Just(catURLs[catIndex]).eraseToAnyPublisher()
        catIndex += 1
        return cat
    }

    private let limit = 10
    private let timeout = 10.0
    private let headers = [
        "X-RapidAPI-Key": APICreds.magicalCats.key,
        "X-RapidAPI-Host": APICreds.magicalCats.host
    ]

    private var catURLs = [String]()
    private var catIndex = 0
    private let logger = Logger.catsService

    private func loadCats() -> AnyPublisher<String, Never> {
        catIndex = 0

        guard
            let url = APICreds.magicalCats.url,
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            logger.error("Invalid cats service endpoint")
            fatalError()
        }
        urlComponents.queryItems = [URLQueryItem(name: "limit", value: "\(limit)")]

        guard let url = urlComponents.url else {
            logger.error("Invalid cats service param: limit")
            return Just("").eraseToAnyPublisher()
        }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeout)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let logPrefix = "Magical Cats Datatask"

        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .log(with: logger, level: .info, prefix: logPrefix) {
                "Received data: \(String(data: $0, encoding: .utf8) ?? "<couldn't decode to string>")"
            }
            .decode(type: [MagicalCat].self, decoder: JSONDecoder())
            .log(with: logger, level: .debug, prefix: logPrefix) { "Decoded: \($0)" }
            .map { $0.map({cat in cat.url})}
            .log(with: logger, level: .info, prefix: logPrefix) { "URLS: \($0)" }
            .replaceError(with: [""])
            .replaceEmpty(with: [""])
            .receive(on: RunLoop.main)
            .flatMap { [unowned self] in
                self.catURLs = $0
                let catURLPublisher = Just(self.catURLs[0]).eraseToAnyPublisher()
                self.catIndex = 1
                return catURLPublisher
            }
            .log(with: logger, level: .debug, prefix: logPrefix) { "Returning URL: \($0)" }
            .print()
            .eraseToAnyPublisher()
    }
}
