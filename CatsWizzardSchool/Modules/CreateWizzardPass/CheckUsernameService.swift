//
//  CheckUsernameService.swift
//  intro-wizardy
//
//  Created by Vladimir Bebeshko on 8/22/23.
//

import Foundation
import Combine
import OSLog

class CheckUsernameService {
    enum Invalid: Error {
        enum Param: Error {
            case username
        }
        enum Response: Error {
            case couldNotParse
        }
    }

    func isUsernameValid(_ username: String) -> AnyPublisher<Bool, Error> {
        logger.debug("Checking username: \(username)")
        guard
            let url = APICreds.emailValidation.url,
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            logger.error("Invalid username service url")
            fatalError()
        }
        urlComponents.queryItems = [URLQueryItem(name: Params.email, value: username)]

        guard let url = urlComponents.url else {
            logger.error("Invalid parameter: username")
            return Future { promise in
                promise(.failure(Invalid.Param.username))
            }.eraseToAnyPublisher()
        }

        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeout)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = self.headers

        logger.debug("Check username request: \(request)")

        let logPrefix = "Username Service Datatask"

        return URLSession.shared.dataTaskPublisher(for: request as URLRequest)
            .map(\.data)
            .log(with: logger, level: .info, prefix: logPrefix) {
                "Received data: \(String(data: $0, encoding: .utf8) ?? "<couldn't decode to string>")"
            }
            .decode(type: Response.self, decoder: JSONDecoder())
            .log(with: logger, level: .debug, prefix: logPrefix) { "Decoded: \($0)" }
            .eraseToAnyPublisher()
            .map(\.valid_email)
            .mapError { _ in
                Logger.usernameService.error("Couldn't parse the check username response")
                return Invalid.Response.couldNotParse
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    private enum Params {
        static let email = "email"
    }

    private let timeout = 10.0
    private let headers = [
        "X-RapidAPI-Key": APICreds.emailValidation.key,
        "X-RapidAPI-Host": APICreds.emailValidation.host
    ]

    private struct Response: Decodable {
        let email: String
        let valid_email: Bool
    }

    private let logger = Logger.usernameService
}
