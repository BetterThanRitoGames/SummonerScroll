//
//  AccountData.swift
//  SummonerScroll
//
//  Created by SDV Bordeaux on 15/05/2025.
//
import Foundation

struct RiotAccountDto: Decodable {
    let puuid: String
    let gameName: String
    let tagLine: String

    enum CodingKeys: String, CodingKey {
        case puuid
        case gameName
        case tagLine
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.puuid = try container.decode(String.self, forKey: .puuid)
        self.gameName = try container.decode(String.self, forKey: .gameName)
        self.tagLine = try container.decode(String.self, forKey: .tagLine)
    }
}
