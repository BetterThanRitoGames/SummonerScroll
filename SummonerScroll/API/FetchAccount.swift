import Foundation

let apiKey = ProcessInfo.processInfo.environment["RIOT_API_KEY"] ?? ""

enum APIRegion: String, CaseIterable, Identifiable {
    case americas, europe, asia, sea
    var id: String { rawValue }
}

enum Servers: String, CaseIterable, Identifiable {
    case euw1, na1, eun1, kr, br1, oc1, ru, sg2, tr1, tw2, vn2
    var id: String { rawValue }
}


class RiotService {
    
    func getPuuid(forSummonerName summonerName: String, tag: String, region: APIRegion) async throws -> RiotAccountDto {
        let urlString = "https://\(region.rawValue).api.riotgames.com/riot/account/v1/accounts/by-riot-id/\(summonerName)/\(tag)?api_key=\(apiKey)"
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

        return try JSONDecoder().decode(RiotAccountDto.self, from: data)
    }

    func getAccountInfo(forPuuid puuid: String, server: Servers) async throws -> SummonerDto {
        let urlString = "https://\(server.rawValue).api.riotgames.com/lol/summoner/v4/summoners/by-puuid/\(puuid)?api_key=\(apiKey)"
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

        return try JSONDecoder().decode(SummonerDto.self, from: data)
    }

    func getAccountInfoFromPuuid(forSummonerName summonerName: String, tag: String, server: Servers, region: APIRegion) async throws -> (RiotAccountDto, SummonerDto) {
        let account = try await getPuuid(forSummonerName: summonerName, tag: tag, region: region)
        let summoner = try await getAccountInfo(forPuuid: account.puuid, server: server)
        return (account, summoner)
    }
}
