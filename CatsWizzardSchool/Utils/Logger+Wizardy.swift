//
//  Logger+Wizardy.swift
//  intro-wizardy
//
//  Created by Vladimir Bebeshko on 8/23/23.
//

import Foundation
import OSLog
import Combine

extension Logger {
    enum Modules {
        static let wizzardPass = "\(bundleId).wizardPass"
        static let magicalCats = "\(bundleId).magicalCats"
        static let wandCreation = "\(bundleId).wandCreation"

        private static var bundleId: String { Bundle.main.bundleIdentifier! }
    }

    enum Categories {
        static let networking = "networking"
        static let combine = "combine"
        static let timers = "timers"
        static let views = "views"
    }

    static let usernameService = Logger(subsystem: Modules.wizzardPass, category: Categories.networking)
    static let passViewModel = Logger(subsystem: Modules.wizzardPass, category: Categories.combine)
    static let passView = Logger(subsystem: Modules.wizzardPass, category: Categories.views)

    static let catsService = Logger(subsystem: Modules.magicalCats, category: Categories.networking)

    static let wandCreation = Logger(subsystem: Modules.wandCreation, category: Categories.combine)
    static let counter = Logger(subsystem: Modules.wandCreation, category: Categories.timers)
    static let wandCreationView = Logger(subsystem: Modules.wandCreation, category: Categories.views)
}

extension Publisher {
    func log(
        file: StaticString = #file,
        line: Int = #line,
        with logger: Logger,
        level: OSLogType,
        prefix: String,
        message: @escaping (Self.Output) -> String
    ) -> AnyPublisher<Self.Output, Self.Failure> {
        return self.map {
            logger.log(level: level, "\(prefix): \(message($0))")
            return $0
        }.eraseToAnyPublisher()
    }
}
