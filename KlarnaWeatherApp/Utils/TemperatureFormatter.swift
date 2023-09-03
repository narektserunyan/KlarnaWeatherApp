//
//  TemperatureFormatter.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import Foundation

final class TemperatureFormatter {
    
    func celciusFormatString(from kelvin: Double) -> String {
        let celcius = kelvin - 273.15
        return String(format: "%.0f°", round(celcius))
    }
    
    func kelvinFormatString(temp: Double) -> String {
        return String(format: "%.0fK", round(temp))
    }
}
