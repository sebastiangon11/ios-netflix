//
//  TVShow.swift
//  Netflix
//
//  Created by Seba Gonzalez on 18/01/2024.
//

import Foundation


struct TVShowsResponse: Codable {
    let results: [TVShow]
}

struct TVShow: Codable {
    let id: Int
    let media_type: String?
    let original_language: String?
    let name: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}
