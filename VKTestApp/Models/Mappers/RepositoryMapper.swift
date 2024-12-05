//
//  RepositoryMapper.swift
//  VKTestApp
//
//  Created by Илья Востров on 30.11.2024.
//

import Foundation

final class RepositoryMapper {
    static func map(apiModel: APIRepository) -> Repository {
        Repository(
            id: apiModel.id,
            name: apiModel.name,
            description: apiModel.description, stars: apiModel.stargazers_count,
            owner: Owner(avatarURL: apiModel.owner.avatar_url)
        )
    }
}

