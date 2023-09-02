//
//  CurrentWeatherViewController.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import UIKit
import Combine

final class CurrentWeatherViewController: Controller<CurrentWeatherViewModel> {

    private var currentLocationView: CurrentWeatherView?
    private var cancellables: Set<AnyCancellable> = []
    
    override func loadView() {
        super.loadView()
        currentLocationView = CurrentWeatherView(frame: view.bounds)
        view = currentLocationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.$weather
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weather in
                guard let weather = weather else { return }
            }
            .store(in: &cancellables)
    }
}

