//
//  FPSCounter.swift
//  VKTestApp
//
//  Created by Илья Востров on 05.12.2024.
//

import SwiftUI
import Combine

class FPSCounter: ObservableObject {
    private var displayLink: CADisplayLink?
    private var lastUpdate: CFTimeInterval = 0
    private var frameCount: Int = 0

    @Published var fps: Int = 0

    func start() {
        stop()
        displayLink = CADisplayLink(target: self, selector: #selector(update(link:)))
        displayLink?.add(to: .main, forMode: .common)
    }

    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func update(link: CADisplayLink) {
        frameCount += 1
        let currentTime = link.timestamp
        if currentTime - lastUpdate >= 1 {
            fps = frameCount
            frameCount = 0
            lastUpdate = currentTime
        }
    }
}
