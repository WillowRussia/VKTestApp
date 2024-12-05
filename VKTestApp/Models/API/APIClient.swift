//
//  ApiClient.swift
//  VKTestApp
//
//  Created by Илья Востров on 30.11.2024.
//

import Foundation

protocol APIClientProtocol {
    func fetchRepositories(query: String, page: Int, perPage: Int) async throws -> [Repository]
}

final class APIClient: APIClientProtocol {
    static let shared = APIClient()
    
    func fetchRepositories(query: String, page: Int, perPage: Int) async throws -> [Repository] {
        let urlString = "https://api.github.com/search/repositories?q=\(query)&order=asc&page=\(page)&per_page=\(perPage)" 
        guard let url = URL(string: urlString) else { throw APIError.invalidURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        return decodedResponse.items.map { Repository(id: $0.id, name: $0.name, description: $0.description, stars: $0.stargazers_count, owner: Owner(avatarURL: $0.owner.avatar_url)) }
    }
}

struct APIResponse: Codable {
    let items: [APIRepository]
}

enum APIError: Error {
    case invalidURL
}
