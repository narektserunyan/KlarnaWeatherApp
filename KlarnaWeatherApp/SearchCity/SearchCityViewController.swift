//
//  SearchCityViewController.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import UIKit
import Combine

final class SearchCityViewController: Controller<SearchCityViewModel, SearchCityView> {
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func loadView() {
        super.loadView()
        contentView = SearchCityView(frame: view.bounds)
        contentView?.viewModel = viewModel
        view = contentView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView?.shouldActivateSearchBar(activate: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBindings()
    }
    
    private func setBindings() {
        viewModel.locations
            .receive(on: DispatchQueue.main)
            .compactMap{$0}
            .sink { [weak self] _ in
                self?.contentView?.reloadCityList()
                self?.contentView?.shouldShowError(show: false)
            }
            .store(in: &cancellables)
        
        viewModel.error
            .receive(on: DispatchQueue.main)
            .compactMap{$0}
            .sink { [weak self] _ in
                self?.contentView?.shouldShowError(show: true)
            }
            .store(in: &cancellables)
    }
}
