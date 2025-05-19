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
    @Published var isInitialLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String? = nil

    // Fonction publique à appeler depuis la vue
    func fetchLastFiveMatches(forPuuid puuid: String, region: APIRegion) async {
        isInitialLoading = true
        errorMessage = nil
        matches = []

        do {
            let fetchedMatches = try await getLastMatchesData(puuid: puuid, start: 0, count: 5, region: region)
            self.matches = fetchedMatches
        } catch {
            self.errorMessage = "Erreur lors du chargement des matchs : \(error.localizedDescription)"
            print("Fetch error: \(error)")
        }

        isInitialLoading = false
    }
    
    @MainActor
    func loadInitialMatches(forPuuid puuid: String, count: Int, region: APIRegion) async {
        isInitialLoading = true
        errorMessage = nil

        do {
            matches = try await getLastMatchesData(puuid: puuid, start: 0, count: count, region: region)
        } catch {
            errorMessage = error.localizedDescription
        }

        isInitialLoading = false
    }
    
    @MainActor
    func loadMoreMatches(forPuuid puuid: String, start: Int, count: Int, region: APIRegion) async {
        isLoadingMore = true
        errorMessage = nil

        do {
            let newMatches = try await getLastMatchesData(puuid: puuid, start: start, count: count, region: region)
            matches.append(contentsOf: newMatches)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoadingMore = false
    }
}
