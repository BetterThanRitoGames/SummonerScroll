//
//  FetchGame.swift
//  SummonerScroll
//
//  Created by SDV Bordeaux on 15/05/2025.
//

import Foundation

func getLastMatches(puuid: String, start: Int, count: Int, region: APIRegion) async throws -> [String] {
    let urlString = "https://\(region.rawValue).api.riotgames.com/lol/match/v5/matches/by-puuid/\(puuid)/ids?type=ranked&start=\(start)&count=\(count)&api_key=\(apiKey)"
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }

    let request = URLRequest(url: url)

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
        throw URLError(.badServerResponse)
    }

    if httpResponse.statusCode != 200 {
        if let apiError = try? JSONDecoder().decode(ApiError.self, from: data) {
            throw apiError
        } else {
            throw URLError(.badServerResponse)
        }
    }

    return try JSONDecoder().decode([String].self, from: data)
}

func getMatchDetails(matchId: String, region: APIRegion) async throws -> MatchDto {
    let urlString = "https://\(region.rawValue).api.riotgames.com/lol/match/v5/matches/\(matchId)?api_key=\(apiKey)"
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }

    let request = URLRequest(url: url)

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        print(response)
        throw URLError(.badServerResponse)
    }

    do {
        let matchDetails = try JSONDecoder().decode(MatchDto.self, from: data)
        return matchDetails
    } catch {
        let errorMessage = "Failed to decode response: \(error)"
        let errorData = String(data: data, encoding: .utf8) ?? "No data"

        print("Error decoding account info: \(errorMessage)")
        print("Response data: \(errorData)")

        throw error
    }
    
}

func getLastMatchesData(puuid: String, start: Int, count: Int, region: APIRegion) async throws -> [MatchDto] {
    let matchIds = try await getLastMatches(puuid: puuid, start: start, count: count, region: region)
    var matchDetails: [MatchDto] = []
    for matchId in matchIds {
        let matchDetail = try await getMatchDetails(matchId: matchId, region: region)
        matchDetails.append(matchDetail)
    }
    return matchDetails
}

