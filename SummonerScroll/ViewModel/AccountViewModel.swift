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

    func fetchAccountInfo(forSummonerName summonerName: String, tag: String, region: APIRegion, server: Servers) async {
        do {
            let (account, summoner) = try await riotService.getAccountInfoFromPuuid(forSummonerName: summonerName, tag: tag, server: server, region: region)
            self.summonerInfo = summoner
            self.accountInfo = account
        } catch let e as ApiError {
            self.errorMessage = e.status.message
            print("efiuezgiufyezoufyegu", errorMessage ?? "")
        } catch {
            print("error", error)
        }
    }
}
