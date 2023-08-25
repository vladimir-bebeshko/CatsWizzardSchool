//
//  CreatePassViewModel.swift
//  intro-wizardy
//
//  Created by Vladimir Bebeshko on 8/22/23.
//

import Foundation
import Combine
import SwiftUI
import OSLog

class CreatePassViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var password: String = ""
    @Published var confirmation: String = ""

    @Published private(set) var isUserNameValid = false
    @Published private(set) var isPasswordValid = false
    @Published private(set) var isConfirmationValid = false

    @Published private(set) var canCreatePass = false

    init() {
        setupUsernameFlow()
        setupPasswordFlow()
        setupConfirmationFlow()
        setupCanCreatePassFlow()
    }

    private var subscriptions = [AnyCancellable]()
    private let debounceDelay: RunLoop.SchedulerTimeType.Stride = 0.5

    private func setupUsernameFlow() {
        let service = CheckUsernameService()

        let usernamePublisher = $userName
            .filter { !$0.isEmpty }
            .debounce(for: debounceDelay, scheduler: RunLoop.main)
            .removeDuplicates()
            .eraseToAnyPublisher()
            .flatMap {
                service.isUsernameValid($0)
                    .replaceError(with: false)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .share()

        usernamePublisher.assign(to: \.isUserNameValid, on: self).store(in: &subscriptions)
        usernamePublisher.sink {
            self.logger.debug("Is valid username: \($0)")
        }.store(in: &subscriptions)

    }

    private func setupPasswordFlow() {
        let passwordPublisher = $password
            .filter { !$0.isEmpty }
            .debounce(for: debounceDelay, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0.count >= 3 && $0.contains("!") }
            .eraseToAnyPublisher()
            .share()

        passwordPublisher.assign(to: \.isPasswordValid, on: self).store(in: &subscriptions)
        passwordPublisher.sink {
            self.logger.debug("Is valid password: \($0)")
        }.store(in: &subscriptions)
    }

    private func setupConfirmationFlow() {
        let confirmationPublisher = $confirmation
            .filter { !$0.isEmpty }
            .debounce(for: debounceDelay, scheduler: RunLoop.main)
            .removeDuplicates()
            .combineLatest($password, $isPasswordValid)
            .map { (confirmation, password, isPasswordValid) in
                return isPasswordValid && confirmation == password
            }
            .eraseToAnyPublisher()
            .share()

        confirmationPublisher.assign(to: \.isConfirmationValid, on: self).store(in: &subscriptions)
        confirmationPublisher.sink {
            self.logger.debug("Is valid confirmation: \($0)")
        }.store(in: &subscriptions)
    }

    private func setupCanCreatePassFlow() {
        let canCreatePassPublisher = $isUserNameValid
            .combineLatest($isPasswordValid, $isConfirmationValid)
            .map { (isUserNameValid, isPasswordValid, isConfirmationValid) in
                isUserNameValid && isPasswordValid && isConfirmationValid
            }
            .eraseToAnyPublisher()
            .share()

        canCreatePassPublisher.sink {
            self.logger.debug("Can create pass: \($0)")
        }.store(in: &subscriptions)
        canCreatePassPublisher.assign(to: \.canCreatePass, on: self).store(in: &subscriptions)
    }

    private var logger: Logger { Logger.passViewModel }
}
