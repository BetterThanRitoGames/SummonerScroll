//
//  MatchRow.swift
//  SummonerScroll
//
//  Created by SDV Bordeaux on 15/05/2025.
//

import SwiftUI

struct MatchRowView: View {
    let participant: ParticipantDto
    let match: MatchDto

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                AsyncImage(url: URL(string: "https://ddragon.leagueoflegends.com/cdn/15.10.1/img/champion/\(participant.championName).png")) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading) {
                    Text(participant.championName)
                        .font(.headline)
                    Text("Niveau : \(participant.champLevel) — \(participant.teamPosition)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text(participant.win ? "Victoire" : "Défaite")
                    .foregroundColor(participant.win ? .green : .red)
                    .fontWeight(.bold)
            }

            Text("Durée : \(match.info.gameDuration / 60) min \(match.info.gameDuration % 60) sec")
                .font(.caption)

            Text("Score : \(participant.kills)/\(participant.deaths)/\(participant.assists) — Or : \(participant.goldEarned)")
                .font(.caption)
        }
        .padding(.vertical, 6)
    }
}

