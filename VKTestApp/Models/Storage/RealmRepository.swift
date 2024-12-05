//
//  RealmRepository1.swift
//  VKTestApp
//
//  Created by Илья Востров on 30.11.2024.
//

import RealmSwift

class RealmRepository: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var descriptionText: String?
    @Persisted var stars: Int
    @Persisted var avatarURL: String
    
    convenience init(from repository: Repository) {
        self.init()
        self.id = repository.id
        self.name = repository.name
        self.descriptionText = repository.description
        self.stars = repository.stars
        self.avatarURL = repository.owner.avatarURL
    }
    
    func toRepository() -> Repository {
        Repository(
            id: id,
            name: name,
            description: descriptionText, stars: stars,
            owner: Owner(avatarURL: avatarURL)
        )
    }
}
