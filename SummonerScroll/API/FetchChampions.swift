import Foundation

struct ChampionInfo: Codable {
    let championId: Int
}

struct ChampionRotationDto: Codable {
    let freeChampionIds: [Int]
    let freeChampionIdsForNewPlayers: [Int]
    let maxNewPlayerLevel: Int
}


struct ChampionListResponse: Codable {
    let data: [String: ChampionData]
}

struct ChampionData: Codable {
    let key: String
    let id: String
    let name: String
    let title: String
}


class FreeChampionService {
    func getFreeChampions(server: Servers = .euw1) async throws -> [Int] {
        let urlString = "https://\(server.rawValue).api.riotgames.com/lol/platform/v3/champion-rotations?api_key=\(apiKey)"
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

        return try JSONDecoder().decode(ChampionRotationDto.self, from: data).freeChampionIds
    }
}

class ChampionUtils {
    static let shared = ChampionUtils()
    
    private let championsURL = "https://ddragon.leagueoflegends.com/cdn/15.10.1/data/fr_FR/champion.json"
    
    private init() {}
    
    func fetchChampions() async throws -> [String: ChampionData] {
        guard let url = URL(string: championsURL) else {
            throw URLError(.badURL)
        }
        
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(ChampionListResponse.self, from: data)
        return decoded.data
    }
    
    /// Utilitaire pour créer un dictionnaire [championId (Int)] -> name
    func mapIdToName(from champions: [String: ChampionData]) -> [Int: String] {
        var map: [Int: String] = [:]
        for (_, champion) in champions {
            if let id = Int(champion.key) {
                map[id] = champion.id
            }
        }
        return map
    }
}

@MainActor
class ChampionNameResolver: ObservableObject {
    @Published var idToName: [Int: String] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadChampionNames() async {
        isLoading = true
        do {
            let champions = try await ChampionUtils.shared.fetchChampions()
            self.idToName = ChampionUtils.shared.mapIdToName(from: champions)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
