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
    var defaultCity = PassthroughSubject<Location?, Never>()
    
    override func loadView() {
        super.loadView()
        searchCityView = SearchCityView(frame: view.bounds)
        searchCityView?.viewModel = viewModel
        view = searchCityView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchCityView?.shouldActivateSearchBar(activate: true)
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
                self?.searchCityView?.reloadCityList()
            }
            .store(in: &cancellables)
        
        searchCityView?.onQueryChange
            .sink { [weak self] query in
                self?.fetchLocations(with: query)
            }
            .store(in: &cancellables)
        
        searchCityView?.onSetDefaultChange
            .sink(receiveValue: {[weak self] index in
                self?.searchCityView?.shouldActivateSearchBar(activate: false)
                if Reachability.isConnectedToNetwork() {
                    self?.defaultCity.send(self?.viewModel.locations.value?[index])
                } else {
                    self?.showAlert()
                }
            })
            .store(in: &cancellables)
    }
    
    private func fetchLocations(with query: String) {
        viewModel.fetchLocations(by: query)
            .receive(on: DispatchQueue.main)
            .ignoreOutput()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure:
                    self?.searchCityView?.shouldShowError(show: true)
                default:
                    self?.searchCityView?.shouldShowError(show: false)
                }
            }, receiveValue: {_ in })
            .store(in: &cancellables)
    }
    
    private func showAlert() {
        let alert = ErrorAlertBuilder().title("Network problem").message("Check your internet connection").build()
        present(alert, animated: true, completion: nil)
    }
}
