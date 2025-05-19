import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: UserSession
    @StateObject private var accountModel = AccountViewModel()
    @State private var username: String = ""
    @State private var tag: String = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var selectedRegion: APIRegion = .europe
    @State private var selectedServer: Servers = .euw1

    var body: some View {
        VStack(spacing: 20) {
            TextField("Pseudo", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("#Tag", text: $tag)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Picker("Région", selection: $selectedRegion) {
                ForEach(APIRegion.allCases) { region in
                    Text(region.rawValue.capitalized).tag(region)
                }
            }
            .pickerStyle(.menu)
            .padding(.horizontal)

            Picker("Serveur", selection: $selectedServer) {
                ForEach(Servers.allCases) { server in
                    Text(server.rawValue.uppercased()).tag(server)
                }
            }
            .pickerStyle(.menu)
            .padding(.horizontal)

            if isLoading {
                ProgressView()
            } else {
                Button("Se connecter") {
                    isLoading = true
                    showError = false

                    Task {
                        await login()
                        isLoading = false
                        showError = accountModel.accountInfo == nil
                    }
                }
                .buttonStyle(.borderedProminent)
            }

            if showError {
                Text(accountModel.errorMessage ?? "Une erreur est survenue")
                    .foregroundColor(.red)
            }
        }
        .fullScreenCover(isPresented: $session.isLoggedIn) {
            MainTabView()
        }
    }

    func login() async {
        await accountModel.fetchAccountInfo(forSummonerName: username, tag: tag, region: selectedRegion, server: selectedServer)

        if let account = accountModel.accountInfo, let summoner = accountModel.summonerInfo {
            session.puuid = account.puuid
            session.gameName = account.gameName
            session.tagLine = account.tagLine
            session.iconId = summoner.profileIconId
            session.isLoggedIn = true
            showError = false
            session.server = selectedServer
            session.region = selectedRegion
            session.summonerLevel = summoner.summonerLevel
        } else {
            showError = true
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(UserSession())
}
