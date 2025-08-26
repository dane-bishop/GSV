//
//  GSVApp.swift
//  GSV
//
//  Created by Melanie Bishop on 7/4/25.
//

import SwiftUI



@main
struct GSVApp: App {
    @StateObject private var session = SessionStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(session) // make SessionStore available to all views
        }
    }
}
