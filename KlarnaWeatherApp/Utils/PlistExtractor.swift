//
//  PlistExtractor.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import Foundation

final class PlistExtractor {
    
    static func getAPIKey() -> String? {
        
        guard let path = Bundle.main.path(forResource: "APIKey", ofType: "plist") else {
            return nil
        }
        // Fetch my api key from APIKey.plist
        do {
            let keyDictUrl = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: keyDictUrl)
            let keyDict = try PropertyListDecoder().decode([String: String].self, from: data)
            return keyDict["APIKey"]
        } catch {
            return nil
        }
    }
}
