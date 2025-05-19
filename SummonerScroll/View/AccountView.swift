
import SwiftUI

struct AccountView: View {
    @EnvironmentObject var session: UserSession
    @State private var matches: [MatchDto] = []
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    AsyncImage(url: URL(string: "https://ddragon.leagueoflegends.com/cdn/15.10.1/img/profileicon/\(session.iconId ?? 0).png")) { phase in
                        let size = CGSize(width: 100, height: 100)
                        
                        switch phase {
                        case .empty:
                            Image(systemName: "person.circle.fill")
                            Text("N. \(session.summonerLevel ?? 0)")

                        case .success(let image):
                            Image(size: size) { context in
                                context.clip(to: Path(ellipseIn: .init(origin: .zero, size: size)))
                                context.draw(image, in: .init(origin: .zero, size: size))
                            }
                            Text("N. \(session.summonerLevel ?? 0)")

                        case .failure(_):
                            Image(systemName: "xmark.circle")
                            Text("Profil")
                            
                        @unknown default:
                            Image(systemName: "questionmark.circle")
                            Text("Profil")
                        }
                    }
                    
                    Text("Nom d'invocateur : \(session.gameName)")
                        .font(.title2)
                    Text("Tag : #\(session.tagLine)")
                        .font(.headline)

                    Divider()

                    if isLoading {
                        ProgressView("Chargement des matchs...")
                    } else {
                        MatchHistoryView()
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Mon compte")
        }
        .onAppear {
            Task {
                do {
                    matches = try await getLastMatchesData(puuid: session.puuid, start:0, count: 5, region: session.region)
                    isLoading = false
                } catch {
                    print("Erreur lors du chargement des matchs :", error)
                    isLoading = false
                }
            }
        }
    }
}


#Preview {
    AccountView()
        .environmentObject(UserSession())
}
