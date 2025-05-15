//
//  MatchViewModel.swift
//  SummonerScroll
//
//  Created by SDV Bordeaux on 15/05/2025.
//

import Foundation

@MainActor
class MatchViewModel: ObservableObject {
    @Published var matches: [MatchDto] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    // Fonction publique à appeler depuis la vue
    func fetchLastFiveMatches(forPuuid puuid: String) async {
        isLoading = true
        errorMessage = nil
        matches = []

        do {
            let fetchedMatches = try await getLastFiveMatchesData(puuid: puuid)
            self.matches = fetchedMatches
        } catch {
            self.errorMessage = "Erreur lors du chargement des matchs : \(error.localizedDescription)"
            print("Fetch error: \(error)")
        }

        isLoading = false
    }
}
