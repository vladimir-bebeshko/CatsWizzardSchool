//
//  CreateWandViewModel.swift
//  intro-wizardy
//
//  Created by Vladimir Bebeshko on 8/24/23.
//

import Foundation
import Combine
import OSLog

class CreateWandViewModel: ObservableObject {
    let steps = [
        "Organizing sparkles...",
        "Decomposing cellular material...",
        "Arranging discontinuity matrix...",
    ]
    @Published var currentStep = 0
    var isWandReady: Bool {
        self.currentStep > self.steps.count
    }

    private var counterSubscription: AnyCancellable?

    func startWandCreation() {
        Logger.wandCreation.debug("Started wand creation")
        let counter = Counter(to: steps.count)
        counter.$count
            .log(with: Logger.wandCreation, level: .debug, prefix: "Wand Creation Steps") { "Current step: \($0)" }
            .receive(on: RunLoop.main)
            .assign(to: &$currentStep)
        counter.startCounting()
    }
}
