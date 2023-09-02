//
//  SearchCityViewController.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import UIKit
import Combine

final class SearchCityViewController: Controller<SearchCityViewModel> {
    
    private var searchCityView: SearchCityView?
    private var cancellables: Set<AnyCancellable> = []
    
    override func loadView() {
        super.loadView()
        searchCityView = SearchCityView(frame: view.bounds)
        view = searchCityView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.$locations
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _weather in
            }
            .store(in: &cancellables)
    }


}
