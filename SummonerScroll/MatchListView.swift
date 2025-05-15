import SwiftUI

struct MatchListView: View {
    @StateObject private var viewModel = MatchViewModel()
    let puuid: String

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Chargement des matchs...")
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(viewModel.matches, id: \.metadata.matchId) { match in
                    VStack(alignment: .leading) {
                        Text("Match ID: \(match.metadata.matchId)")
                            .font(.headline)
                        Text("Durée : \(match.info.gameDuration / 60) min")
                            .font(.subheadline)
                        Text("Mode : \(match.info.gameMode)")
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchLastFiveMatches(forPuuid: puuid)
            }
        }
    }
}

#Preview {
    MatchListView(puuid: "jdpSXIK7rrNR6zVz0AffAE-2Eg-04Rln08-7J_Wtf8wClpxs1g61CmNbtoG158JqJIpKc2GNtKT2kw")
}
