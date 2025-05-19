//
//  ApiError.swift
//  SummonerScroll
//
//  Created by SDV Bordeaux on 19/05/2025.
//

import Foundation

struct ApiError: Error, Decodable {
    struct Status: Decodable {
        let message: String
        let status_code: Int
    }
    let status: Status
}
