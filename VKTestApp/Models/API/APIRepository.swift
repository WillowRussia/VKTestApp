//
//  APIRepository.swift
//  VKTestApp
//
//  Created by Илья Востров on 30.11.2024.
//

import Foundation

struct APIRepository: Codable {
    let id: Int
    let name: String
    let description: String?
    let stargazers_count: Int
    let owner: APIOwner
    
}

struct APIOwner: Codable {
    let avatar_url: String
}
