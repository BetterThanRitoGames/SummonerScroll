//
//  AccountViewModel.swift
//  SummonerScroll
//
//  Created by SDV Bordeaux on 15/05/2025.
//

import Foundation

import Foundation

class AccountViewModel: ObservableObject {
    @Published var summonerInfo: SummonerDto?
    @Published var accountInfo: RiotAccountDto?
    @Published var errorMessage: String?

    private var riotService = RiotService()

    func fetchAccountInfo(forSummonerName summonerName: String, tag: String) async {
        do {
            let (account, summoner) = try await riotService.getAccountInfoFromPuuid(forSummonerName: summonerName, tag: tag)
            self.summonerInfo = summoner
            self.accountInfo = account
        } catch {
            self.errorMessage = "Failed to fetch account info: \(error.localizedDescription)"
        }
    }
}
