import SwiftUI

struct MatchHistoryView: View {
    @StateObject private var viewModel = MatchViewModel()
    @EnvironmentObject var session: UserSession
    var externalPuuid: String?

    @State private var startIndex = 0
    private let pageSize = 5

    @State private var selectedRegion: APIRegion = .europe

    var body: some View {
        let puuid = externalPuuid ?? session.puuid

        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Derniers matchs")
                    .font(.title3)
            }
            .padding(.bottom, 5)

            if viewModel.isInitialLoading {
                ProgressView("Chargement des matchs...")
                    .frame(maxWidth: .infinity)
            } else if let error = viewModel.errorMessage {
                Text("Erreur : \(error)")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
            } else {
                ForEach(viewModel.matches, id: \.metadata.matchId) { match in
                    if let participant = match.info.participants.first(where: { $0.puuid == puuid }) {
                        MatchRowView(participant: participant, match: match)
                    }
                }

                if viewModel.isLoadingMore {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top)
                } else {
                    Button("Voir plus") {
                        Task {
                            await viewModel.loadMoreMatches(
                                forPuuid: puuid,
                                start: startIndex,
                                count: pageSize,
                                region: selectedRegion
                            )
                            startIndex += pageSize
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.bordered)
                    .padding(.top, 10)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadInitialMatches(
                    forPuuid: puuid,
                    count: pageSize,
                    region: session.region
                )
                startIndex += pageSize
            }
        }
        .padding()
    }
}
