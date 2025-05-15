//
//  FetchAccount.swift
//  SummonerScroll
//
//  Created by SDV Bordeaux on 15/05/2025.
//

import Foundation

let apiKey = "YOUR_RIOT_API_KEY"

func getPuuid(forSummonerName summonerName: String, tag: String) async throws -> String {
    let urlString = "https://na1.api.riotgames.com/lol/summoner/v4/summoners/by-name/\(summonerName)%23\(tag)"
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }

    let summonerInfo = try JSONDecoder().decode(RiotAccountDto.self, from: data)
    return summonerInfo.puuid
}

func getAccountInfo(forPuuid puuid: String) async throws -> SummonerDto {
    let urlString = "https://na1.api.riotgames.com/lol/league/v4/entries/by-account/\(puuid)"
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }

    let accountInfo = try JSONDecoder().decode([SummonerDto].self, from: data)
    
    return accountInfo.first!
}

func getAccountInfoFromPuuid(forSummonerName summonerName: String, tag: String) async throws -> SummonerDto {
    let accountPuuid: String = try await getPuuid(forSummonerName: summonerName, tag: tag)
    
    return try await getAccountInfo(forPuuid: accountPuuid)
}

@main
struct MyApp {
    static func main() async {
        let summonerName = "SummonerName"  // Remplacez par le nom du summoner
        let tag = "Tag"                    // Remplacez par le tag du summoner
        
        do {
            // Étape 1: Récupérer le PUUID du summoner
            let puuid = try await getPuuid(forSummonerName: summonerName, tag: tag)
            print("PUUID récupéré: \(puuid)")

            // Étape 2: Utiliser le PUUID pour récupérer les informations du compte
            let accountInfo = try await getAccountInfo(forPuuid: puuid)
            print("Account Info: \(accountInfo)")

        } catch {
            print("Erreur: \(error.localizedDescription)")
        }
    }
}
