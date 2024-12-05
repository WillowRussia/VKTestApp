//
//  RepositoryCell.swift
//  VKTestApp
//
//  Created by Илья Востров on 30.11.2024.
//

import SwiftUI

struct RepositoryCell: View, Equatable {
    let repository: Repository

    static func == (lhs: RepositoryCell, rhs: RepositoryCell) -> Bool {
        return lhs.repository.id == rhs.repository.id
    }

    var body: some View {
        HStack {
            RemoteImage(url: repository.owner.avatarURL)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(repository.name)
                    .font(.headline)
                Text(repository.description ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("\(repository.stars) ⭐")
        }
    }
}

