
import Foundation

class UserSession: ObservableObject {
    @Published var puuid: String = ""
    @Published var gameName: String = ""
    @Published var tagLine: String = ""
    @Published var iconId: Int? = nil 
    @Published var isLoggedIn: Bool = false
    @Published var region: APIRegion = .europe
    @Published var server: Servers = .euw1
    @Published var summonerLevel: Int? = nil
}
