//
//  FetchGame.swift
//  SummonerScroll
//
//  Created by SDV Bordeaux on 15/05/2025.
//

import Foundation

func getLast5Matches(puuid: String) async throws -> [String] {
    let urlString = "https://europe.api.riotgames.com/lol/match/v5/matches/by-puuid/\(puuid)/ids?type=ranked&start=0&count=5&api_key=\(apiKey)"
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
        let matchIdsResponse = try JSONDecoder().decode([String].self, from: data)
        return matchIdsResponse
    } catch {
        let errorMessage = "Failed to decode response: \(error)"
        let errorData = String(data: data, encoding: .utf8) ?? "No data"

        print("Error decoding account info: \(errorMessage)")
        print("Response data: \(errorData)")

        throw error
    }
    
}

func getMatchDetails(matchId: String) async throws -> MatchDto {
    let urlString = "https://europe.api.riotgames.com/lol/match/v5/matches/\(matchId)?api_key=\(apiKey)"
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

func getLastFiveMatchesData(puuid: String) async throws -> [MatchDto] {
    let matchIds = try await getLast5Matches(puuid: puuid)
    var matchDetails: [MatchDto] = []
    for matchId in matchIds {
        let matchDetail = try await getMatchDetails(matchId: matchId)
        matchDetails.append(matchDetail)
    }
    return matchDetails
}
