//
//  LoginView.swift
//  GSV
//
//  Created by Melanie Bishop on 8/18/25.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: SessionStore
    @State private var username = ""
    @State private var password = ""
    @State private var busy = false
    @State private var error: String?

    var body: some View {
        VStack(spacing: 12) {
            
            
            
            
            Text("Gateway Sports Venue").font(.title).bold()
            TextField("Username", text: $username)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .textContentType(.username)
                .padding().background(.thinMaterial).cornerRadius(10)
            SecureField("Password", text: $password)
                .textContentType(.password)
                .padding().background(.thinMaterial).cornerRadius(10)

            Button {
                Task {
                    busy = true
                    await session.login(username: username, password: password)
                    if !session.isAuthed { error = "Login failed" }
                    busy = false
                }
            } label: {
                Text(busy ? "Signing in…" : "Sign In").frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(busy)

            if let e = error {
                Text(e).foregroundColor(.red)
            }
        }
        .padding()
    }
}
