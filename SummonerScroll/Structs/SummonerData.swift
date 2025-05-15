//
//  SummonerData.swift
//  SummonerScroll
//
//  Created by SDV Bordeaux on 15/05/2025.
//

import Foundation

struct SummonerDto: Decodable {
    let id: String
    let accountId: String
    let puuid: String
    let name: String
    let profileIconId: Int
    let revisionDate: Int64
    let summonerLevel: Int

    enum CodingKeys: String, CodingKey {
        case id
        case accountId
        case puuid
        case name
        case profileIconId
        case revisionDate
        case summonerLevel
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.accountId = try container.decode(String.self, forKey: .accountId)
        self.puuid = try container.decode(String.self, forKey: .puuid)
        self.name = try container.decode(String.self, forKey: .name)
        self.profileIconId = try container.decode(Int.self, forKey: .profileIconId)
        self.revisionDate = try container.decode(Int64.self, forKey: .revisionDate)
        self.summonerLevel = try container.decode(Int.self, forKey: .summonerLevel)
    }
}
