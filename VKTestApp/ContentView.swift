//
//  ContentView.swift
//  VKTestApp
//
//  Created by Илья Востров on 30.11.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var fpsCounter = FPSCounter()

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RepositoryListView()
            
            // FPS Overlay
            Text("FPS: \(fpsCounter.fps)")
                .font(.caption)
                .padding(8)
                .background(Color.black.opacity(0.7))
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding()
        }
        .onAppear {
            fpsCounter.start()
        }
        .onDisappear {
            fpsCounter.stop()
        }
    }
}

#Preview {
    ContentView()
}
