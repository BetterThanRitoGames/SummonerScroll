//
//  FetchGame.swift
//  SummonerScroll
//
//  Created by SDV Bordeaux on 15/05/2025.
//

import Foundation

func getLast5Matches(puuid: String) async throws -> [String] {
    let urlString = "https://na1.api.riotgames.com/lol/match/v5/matches/by-puuid/\(puuid)/ids?count=5"
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }

    let matchIdsResponse = try JSONDecoder().decode([String].self, from: data)
    return matchIdsResponse
}

func getMatchDetails(matchId: String) async throws -> MatchDto {
    let urlString = "https://na1.api.riotgames.com/lol/match/v5/matches/\(matchId)"
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }

    let matchDetails = try JSONDecoder().decode(MatchDto.self, from: data)
    return matchDetails
}

func getLastFiveMatchesData(puuid: String) async throws -> [MatchDto] {
    let matchIds = try await getLast5Matches(puuid: puuid)
    var matchDetails: [MatchDto] = []
    for matchId in matchIds {
        let matchDetail = try await getMatchDetails(matchId: matchId)
        matchDetails.append(matchDetail)
    }
    return matchDetails
}
