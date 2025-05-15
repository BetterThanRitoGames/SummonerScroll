//
//  GameDto.swift
//  SummonerScroll
//
//  Created by SDV Bordeaux on 15/05/2025.
//

import Foundation

// MARK: - MatchDto
struct MatchDto: Decodable {
    let metadata: MetadataDto
    let info: InfoDto

    enum CodingKeys: String, CodingKey {
        case metadata
        case info
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        metadata = try container.decode(MetadataDto.self, forKey: .metadata)
        info = try container.decode(InfoDto.self, forKey: .info)
    }
}


// MARK: - MetadataDto
struct MetadataDto: Decodable {
    let dataVersion: String
    let matchId: String
    let participants: [String]

    enum CodingKeys: String, CodingKey {
        case dataVersion
        case matchId
        case participants
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dataVersion = try container.decode(String.self, forKey: .dataVersion)
        matchId = try container.decode(String.self, forKey: .matchId)
        participants = try container.decode([String].self, forKey: .participants)
    }
}


// MARK: - InfoDto
struct InfoDto: Decodable {
    let gameCreation: Int64
    let gameDuration: Int
    let gameEndTimestamp: Int64
    let gameId: Int64
    let gameMode: String
    let gameName: String
    let gameStartTimestamp: Int64
    let gameType: String
    let gameVersion: String
    let mapId: Int
    let participants: [ParticipantDto]
    let platformId: String
    let queueId: Int
    let teams: [TeamDto]
    let tournamentCode: String?

    enum CodingKeys: String, CodingKey {
        case gameCreation, gameDuration, gameEndTimestamp, gameId, gameMode, gameName,
             gameStartTimestamp, gameType, gameVersion, mapId, participants, platformId,
             queueId, teams, tournamentCode
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        gameCreation = try container.decode(Int64.self, forKey: .gameCreation)
        gameDuration = try container.decode(Int.self, forKey: .gameDuration)
        gameEndTimestamp = try container.decode(Int64.self, forKey: .gameEndTimestamp)
        gameId = try container.decode(Int64.self, forKey: .gameId)
        gameMode = try container.decode(String.self, forKey: .gameMode)
        gameName = try container.decode(String.self, forKey: .gameName)
        gameStartTimestamp = try container.decode(Int64.self, forKey: .gameStartTimestamp)
        gameType = try container.decode(String.self, forKey: .gameType)
        gameVersion = try container.decode(String.self, forKey: .gameVersion)
        mapId = try container.decode(Int.self, forKey: .mapId)
        participants = try container.decode([ParticipantDto].self, forKey: .participants)
        platformId = try container.decode(String.self, forKey: .platformId)
        queueId = try container.decode(Int.self, forKey: .queueId)
        teams = try container.decode([TeamDto].self, forKey: .teams)
        tournamentCode = try container.decodeIfPresent(String.self, forKey: .tournamentCode)
    }
}


// MARK: - ParticipantDto
struct ParticipantDto: Decodable {
    let assists: Int
    let baronKills: Int
    let bountyLevel: Int
    let champExperience: Int
    let champLevel: Int
    let championId: Int
    let championName: String
    let championTransform: Int
    let consumablesPurchased: Int
    let damageDealtToBuildings: Int
    let damageDealtToObjectives: Int
    let damageDealtToTurrets: Int
    let damageSelfMitigated: Int
    let deaths: Int
    let detectorWardsPlaced: Int
    let doubleKills: Int
    let dragonKills: Int
    let firstBloodAssist: Bool
    let firstBloodKill: Bool
    let firstTowerAssist: Bool
    let firstTowerKill: Bool
    let gameEndedInEarlySurrender: Bool
    let gameEndedInSurrender: Bool
    let goldEarned: Int
    let goldSpent: Int
    let individualPosition: String
    let inhibitorKills: Int
    let inhibitorTakedowns: Int
    let inhibitorsLost: Int
    let item0: Int
    let item1: Int
    let item2: Int
    let item3: Int
    let item4: Int
    let item5: Int
    let item6: Int
    let itemsPurchased: Int
    let killingSprees: Int
    let kills: Int
    let lane: String
    let largestCriticalStrike: Int
    let largestKillingSpree: Int
    let largestMultiKill: Int
    let longestTimeSpentLiving: Int
    let magicDamageDealt: Int
    let magicDamageDealtToChampions: Int
    let magicDamageTaken: Int
    let neutralMinionsKilled: Int
    let nexusKills: Int
    let nexusLost: Int
    let nexusTakedowns: Int
    let objectivesStolen: Int
    let objectivesStolenAssists: Int
    let participantId: Int
    let pentaKills: Int
    let perks: PerksDto
    let physicalDamageDealt: Int
    let physicalDamageDealtToChampions: Int
    let physicalDamageTaken: Int
    let profileIcon: Int
    let puuid: String
    let quadraKills: Int
    let riotIdName: String?
    let riotIdTagline: String?
    let role: String
    let sightWardsBoughtInGame: Int
    let spell1Casts: Int
    let spell2Casts: Int
    let spell3Casts: Int
    let spell4Casts: Int
    let summoner1Casts: Int
    let summoner1Id: Int
    let summoner2Casts: Int
    let summoner2Id: Int
    let summonerId: String
    let summonerLevel: Int
    let summonerName: String
    let teamEarlySurrendered: Bool
    let teamId: Int
    let teamPosition: String
    let timeCCingOthers: Int
    let timePlayed: Int
    let totalDamageDealt: Int
    let totalDamageDealtToChampions: Int
    let totalDamageShieldedOnTeammates: Int
    let totalDamageTaken: Int
    let totalHeal: Int
    let totalHealsOnTeammates: Int
    let totalMinionsKilled: Int
    let totalTimeCCDealt: Int
    let totalTimeSpentDead: Int
    let totalUnitsHealed: Int
    let tripleKills: Int
    let trueDamageDealt: Int
    let trueDamageDealtToChampions: Int
    let trueDamageTaken: Int
    let turretKills: Int
    let turretTakedowns: Int
    let turretsLost: Int
    let unrealKills: Int
    let visionScore: Int
    let visionWardsBoughtInGame: Int
    let wardsKilled: Int
    let wardsPlaced: Int
    let win: Bool
}

// MARK: - PerksDto
struct PerksDto: Decodable {
    let statPerks: StatPerksDto
    let styles: [PerkStyleDto]

    enum CodingKeys: String, CodingKey {
        case statPerks
        case styles
    }
}

// MARK: - StatPerksDto
struct StatPerksDto: Decodable {
    let defense: Int
    let flex: Int
    let offense: Int

    enum CodingKeys: String, CodingKey {
        case defense
        case flex
        case offense
    }
}

// MARK: - PerkStyleDto
struct PerkStyleDto: Decodable {
    let description: String
    let selections: [PerkStyleSelectionDto]
    let style: Int

    enum CodingKeys: String, CodingKey {
        case description
        case selections
        case style
    }
}

// MARK: - PerkStyleSelectionDto
struct PerkStyleSelectionDto: Decodable {
    let perk: Int
    let var1: Int
    let var2: Int
    let var3: Int

    enum CodingKeys: String, CodingKey {
        case perk
        case var1
        case var2
        case var3
    }
}


// MARK: - TeamDto
struct TeamDto: Decodable {
    let bans: [BanDto]
    let objectives: ObjectivesDto
    let teamId: Int
    let win: Bool
}

// MARK: - BanDto
struct BanDto: Decodable {
    let championId: Int
    let pickTurn: Int
}

// MARK: - ObjectivesDto
struct ObjectivesDto: Decodable {
    let baron: ObjectiveDto
    let champion: ObjectiveDto
    let dragon: ObjectiveDto
    let inhibitor: ObjectiveDto
    let riftHerald: ObjectiveDto
    let tower: ObjectiveDto
}

// MARK: - ObjectiveDto
struct ObjectiveDto: Decodable {
    let first: Bool
    let kills: Int
}
