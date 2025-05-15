//
//  ContentView.swift
//  SummonerScroll
//
//  Created by SDV Bordeaux on 15/05/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AccountViewModel()
    @State private var summonerName = ""
    @State private var tag = ""
    
    var body: some View {
            VStack {
                TextField("Summoner Name", text: $summonerName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Tag", text: $tag)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Fetch Account Info") {
                    Task {
                        await viewModel.fetchAccountInfo(forSummonerName: summonerName, tag: tag)
                    }
                }
                .padding()

                if let summoner = viewModel.summonerInfo {
                    Text("Summoner Name: \(viewModel.accountInfo?.gameName ?? "Non disponible")")
                    AsyncImage(url: URL(string: "https://ddragon.leagueoflegends.com/cdn/15.10.1/img/profileicon/\(viewModel.summonerInfo?.profileIconId ?? 0).png")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                 .scaledToFit()
                                 .frame(width: 200, height: 200)
                        case .failure:
                            Text("Image non disponible")
                        @unknown default:
                            Text("Erreur inconnue")
                        }
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
}

#Preview {
    ContentView()
}
