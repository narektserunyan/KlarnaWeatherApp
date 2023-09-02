//
//  APIError.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    case fetching
    case requestFailed(Error)
    
    var description: String {
        switch self {
        case .fetching:
            return "File fetching error"
        case .requestFailed(let error):
            return "Request failed with error - \(error.localizedDescription)"
        }
    }
}
