//
//  AlertBuilder.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 03.09.23.
//

import UIKit

final class ErrorAlertBuilder {
    private var title = "Oops"
    private var message = "Something went wrong"
    private var dismissButtonTitile = "Dismiss"
    
    
    func title(_ title: String) -> ErrorAlertBuilder {
        self.title = title
        return self
    }
    
    func message(_ message: String) -> ErrorAlertBuilder {
        self.message = message
        return self
    }
    
    func build() -> UIViewController {
        
        let alert = UIAlertController(title: title,
                                   message: message,
                                   preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: dismissButtonTitile, style: .cancel))
        return alert
    }
}
