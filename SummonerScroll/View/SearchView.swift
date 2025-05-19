import SwiftUI

struct SearchView: View {
    @State private var gameName = ""
    @State private var tagLine = ""
    @State private var result: RiotAccountDto?
    @State private var error: String?
    @State private var isLoading = false
    @State private var selectedRegion: APIRegion = .europe
    @State private var selectedServer: Servers = .euw1
    @StateObject private var accountModel = AccountViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    TextField("Nom d'invocateur", text: $gameName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .padding(.horizontal)

                    TextField("Tag (ex: EUW)", text: $tagLine)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
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

                    Button("Rechercher") {
                        Task {
                            await searchAccount()
                        }
                    }
                    .buttonStyle(.borderedProminent)

                    if isLoading {
                        ProgressView("Recherche...")
                    }

                    if let error {
                        Text("Erreur : \(error)")
                            .foregroundColor(.red)
                    }

                    if let info = accountModel.accountInfo {
                        VStack {
                            Text("Nom : \(info.gameName)")
                            Text("Tag : \(info.tagLine)")

                            MatchHistoryView(externalPuuid: info.puuid)
                        }
                        .padding()
                    }

                    Spacer(minLength: 50)
                }
                .padding(.top)
            }
            .navigationTitle("Rechercher un joueur")
        }
    }

    func searchAccount() async {
        guard !gameName.isEmpty && !tagLine.isEmpty else {
            error = "Champs vides"
            return
        }

        isLoading = true
        error = nil

        await accountModel.fetchAccountInfo(forSummonerName: gameName, tag: tagLine, region: selectedRegion, server: selectedServer)
        
        error = accountModel.errorMessage
        
        isLoading = false
    }
}

#Preview {
    SearchView()
}
