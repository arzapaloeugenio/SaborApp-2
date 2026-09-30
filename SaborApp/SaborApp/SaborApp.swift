//
//  SaborApp.swift
//  SaborApp
//
//  App entry point. "Sabor" — restaurant / food delivery experience,
//  converted from the Stitch HTML design export to native SwiftUI.
//

import SwiftUI

@main
struct SaborApp: App {
    @StateObject private var state = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(state)
                .tint(SaborColor.primary)
                .preferredColorScheme(state.appearance.colorScheme)
        }
    }
}
