import Foundation

let apiKey = "RGAPI-6897bb76-447b-4856-96f2-ddf546f5ef21"

class RiotService {
    
    func getPuuid(forSummonerName summonerName: String, tag: String) async throws -> RiotAccountDto {
        let urlString = "https://europe.api.riotgames.com/riot/account/v1/accounts/by-riot-id/\(summonerName)/\(tag)?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let request = URLRequest(url: url)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print(response)
            throw URLError(.badServerResponse)
        }

        let summonerInfo = try JSONDecoder().decode(RiotAccountDto.self, from: data)
        return summonerInfo
    }

    func getAccountInfo(forPuuid puuid: String) async throws -> SummonerDto {
        let urlString = "https://euw1.api.riotgames.com/lol/summoner/v4/summoners/by-puuid/\(puuid)?api_key=\(apiKey)"
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
            let accountInfo = try JSONDecoder().decode(SummonerDto.self, from: data)
            print ("Decoded account info: \(accountInfo)")
            return accountInfo
        } catch {
            let errorMessage = "Failed to decode response: \(error)"
            let errorData = String(data: data, encoding: .utf8) ?? "No data"

            print("Error decoding account info: \(errorMessage)")
            print("Response data: \(errorData)")

            throw error
        }
    }

    func getAccountInfoFromPuuid(forSummonerName summonerName: String, tag: String) async throws -> (RiotAccountDto, SummonerDto) {
        let account = try await getPuuid(forSummonerName: summonerName, tag: tag)
        let summoner = try await getAccountInfo(forPuuid: account.puuid)
        return (account, summoner)
    }
}
