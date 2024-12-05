//
//   SortOption.swift
//  VKTestApp
//
//  Created by Илья Востров on 30.11.2024.
//

enum SortOption: String, CaseIterable {
    case starsAscending = "Stars (Ascending)"
    case starsDescending = "Stars (Descending)"
    case nameAscending = "Name (A-Z)"
    case nameDescending = "Name (Z-A)"
    
    var displayName: String {
        switch self {
        case .starsAscending: return "Stars ↑"
        case .starsDescending: return "Stars ↓"
        case .nameAscending: return "Name A-Z"
        case .nameDescending: return "Name Z-A"
        }
    }
}
