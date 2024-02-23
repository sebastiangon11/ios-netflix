//
//  YoutubeSearchResponse.swift
//  Netflix
//
//  Created by Seba Gonzalez on 19/01/2024.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [YoutubeVideo]
}

struct YoutubeVideo: Codable {
    let id: YoutubeVideoId
}

struct YoutubeVideoId: Codable {
    let kind: String
    let videoId: String
}
