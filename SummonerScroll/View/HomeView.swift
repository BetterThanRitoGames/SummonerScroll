
import SwiftUI

struct HomeView: View {
    @State private var championResolver = ChampionNameResolver()
    @State var freeChampionIds: [Int] = []
    var body: some View {
        NavigationView {
            ScrollView {
                            VStack(alignment: .leading) {
                                Text("Champions gratuits")
                                    .font(.title2)
                                    .padding(.horizontal)

                                if championResolver.isLoading {
                                    ProgressView("Chargement des champions...")
                                        .padding()
                                } else if let error = championResolver.errorMessage {
                                    Text("Erreur : \(error)")
                                        .foregroundColor(.red)
                                        .padding()
                                } else {
                                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 16)], spacing: 16) {
                                        ForEach(freeChampionIds, id: \.self) { id in
                                            if let name = championResolver.idToName[id] {
                                                VStack {
                                                    AsyncImage(url: URL(string: "https://ddragon.leagueoflegends.com/cdn/15.10.1/img/champion/\(name).png")) { image in
                                                        image
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                    } placeholder: {
                                                        ProgressView()
                                                    }
                                                    .frame(width: 80, height: 80)

                                                    Text(name)
                                                        .font(.caption)
                                                        .lineLimit(1)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.top)
                        }
        }.onAppear() {
            Task {
                async let freeIds = FreeChampionService().getFreeChampions()
                async let _ = championResolver.loadChampionNames()
                        
                freeChampionIds = try await freeIds
                
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(UserSession())
}
