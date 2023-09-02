//
//  Location.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import Foundation

struct Location: Decodable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
}
