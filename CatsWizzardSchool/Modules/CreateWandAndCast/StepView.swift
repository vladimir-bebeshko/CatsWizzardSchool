//
//  StepView.swift
//  CatsWizzardSchool
//
//  Created by Vladimir Bebeshko on 8/22/23.
//

import SwiftUI

struct StepView: View {
    let stepName: String
    @Binding var completed: Bool

    var body: some View {
        HStack{
            Text(stepName)
                .font(.title2)
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .imageScale(.large)
                .foregroundColor( completed ? .green : .gray )
        }.padding([.horizontal, .bottom])
    }
}

