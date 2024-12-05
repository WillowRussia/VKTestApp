//
//  Owner.swift
//  VKTestApp
//
//  Created by Илья Востров on 30.11.2024.
//

import Foundation

struct Owner: Codable {
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
    }
}
