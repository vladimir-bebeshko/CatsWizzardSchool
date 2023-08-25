//
//  ContentView.swift
//  CatsWizzardSchool
//
//  Created by Vladimir Bebeshko on 8/21/23.
//

import SwiftUI
import Combine
import OSLog

struct CreateWizzardPassView: View {
    @ObservedObject var viewModel = CreatePassViewModel()

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    wandImage
                    Text("Hello, wizard!")
                        .font(.title)
                    wandImage
                }.padding()

                HStack {
                    Image(systemName:"checkmark.circle")
                        .imageScale(.large)
                        .foregroundColor(viewModel.isUserNameValid ? .green : .gray)
                    TextField(
                        "User name (email address)",
                        text: $viewModel.userName
                    ).textFieldStyle(InsetTextFieldStyle())
                }.padding()

                HStack {
                    Image(systemName:"checkmark.circle")
                        .imageScale(.large)
                        .foregroundColor(viewModel.isPasswordValid ? .green : .gray)
                    TextField(
                        "Password",
                        text: $viewModel.password
                    ).textFieldStyle(InsetTextFieldStyle())
                }.padding()

                HStack {
                    Image(systemName:"checkmark.circle")
                        .imageScale(.large)
                        .foregroundColor(viewModel.isConfirmationValid ? .green : .gray)
                    TextField(
                        "Confirm password",
                        text: $viewModel.confirmation
                    ).textFieldStyle(InsetTextFieldStyle())
                }.padding()

                NavigationLink {
                    CreateWandView()
                } label: {
                    Text("Create Pass")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding()
                        .background(viewModel.canCreatePass ? .blue : .gray)
                        .cornerRadius(9)
                        .padding()
                }.disabled(!viewModel.canCreatePass)

            }.padding()
        }
    }

    private var wandImage: some View {
        Image(systemName: "wand.and.stars")
            .imageScale(.large)
            .foregroundStyle(.tint)
    }

    private struct InsetTextFieldStyle: TextFieldStyle {
        @FocusState private var textFieldFocused: Bool
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding()
                .focused($textFieldFocused)
                .onTapGesture {
                    Logger.passView.info("Focusing textview")
                    textFieldFocused = true
                }
                .border(Color(.lightGray))
                .font(.title2)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
        }
    }

}

#Preview {
    CreateWizzardPassView()
}
