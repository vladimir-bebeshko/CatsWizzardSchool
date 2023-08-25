//
//  Counter.swift
//  CatsWizzardSchool
//
//  Created by Vladimir Bebeshko on 8/22/23.
//

import Foundation
import Combine
import OSLog

class Counter: ObservableObject {
    @Published var count = 0

    init(to limit: Int) {
        self.limit = limit
    }

    func startCounting() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.count += 1
            Logger.counter.debug("Counting: \(self.count)")

            if self.count > self.limit {
                Logger.counter.debug("Invalidating counter")
                timer.invalidate()
            }
        }
    }
    private let limit: Int
}
