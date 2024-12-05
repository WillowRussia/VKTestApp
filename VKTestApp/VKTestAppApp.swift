//
//  VKTestAppApp.swift
//  VKTestApp
//
//  Created by Илья Востров on 30.11.2024.
//

import SwiftUI

@main
struct VKTestAppApp: App {
    
    init() {
            configureRealmMigration()
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
