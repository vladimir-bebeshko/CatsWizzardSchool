//
//  CatsViewModel.swift
//  intro-wizardy
//
//  Created by Vladimir Bebeshko on 8/22/23.
//

import Foundation
import Combine

struct MagicalCat: Decodable {
    let url: String
}

class CatsViewModel: ObservableObject {
    @Published var catURL = ""

    func nextCat() {
        catsSubscription = service.nextCat().sink {
            self.catURL = $0
        }
    }

    private lazy var service = CatsService()
    private var catsSubscription: AnyCancellable?
}
