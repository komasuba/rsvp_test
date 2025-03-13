//
//  rsvp_testApp.swift
//  rsvp_test
//
//  Created by 小松昴 on 2025/01/28.
//

import SwiftData
import SwiftUI
import Foundation

@main
struct rsvp_testApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Destination.self)
    }
}
