//
//  CreateWandView.swift
//  intro-wizardy
//
//  Created by Vladimir Bebeshko on 8/22/23.
//

import SwiftUI
import Combine
import OSLog

struct CreateWandView: View {
    @ObservedObject private var vm = CreateWandViewModel()
    @ObservedObject private var cats = CatsViewModel()

    @State private var isMagicalCatRevealed = false
    @State private var step = 0

    private var firstAppear = true

    var body: some View {
        VStack {
            Text(vm.isWandReady ? "Wand is ready!" : "Creating wand...")
                .font(.title)
                .padding()
            
            ForEach(0 ..< vm.steps.count, id: \.self) { index in
                let _ = logger.debug("Drawing a step with index: \(index) and step \(vm.currentStep)")
                StepView(
                    stepName: vm.steps[index],
                    completed: Binding<Bool>(get: { vm.currentStep > index }, set: { _ in })
                )
            }

            let _ = logger.debug("Is wand ready: \(vm.isWandReady)")
            Button {
                logger.debug("Requesting next cat")
                self.isMagicalCatRevealed = true
                cats.nextCat()
            } label: {
                Text(isMagicalCatRevealed ? "More magical cats!" : "Start casting!")
            } .padding()
                .font(.title2)
                .foregroundStyle(.white)
                .background(vm.isWandReady ? .blue : .gray)
                .cornerRadius(9)
                .padding()
                .disabled(!vm.isWandReady)

            Spacer()
            
            if isMagicalCatRevealed {
                let _ = logger.debug("Magical cat is revealed! Requesting image...")
                AsyncImage(url: URL(string: cats.catURL)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }.padding()
            }
            
            Spacer()
        }.onAppear {
            vm.startWandCreation()
        }
    }

    private let logger = Logger.wandCreationView
}
