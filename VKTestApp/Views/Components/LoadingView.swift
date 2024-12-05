//
//  LoadingView.swift
//  VKTestApp
//
//  Created by Илья Востров on 30.11.2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
        .padding()
    }
}
