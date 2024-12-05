//
//  Repository.swift
//  VKTestApp
//
//  Created by Илья Востров on 30.11.2024.
//

import Foundation

struct Repository: Identifiable, Codable, Equatable {
    let id: Int
    var name: String
    var description: String?
    var stars: Int
    let owner: Owner
    
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id
    }
}

