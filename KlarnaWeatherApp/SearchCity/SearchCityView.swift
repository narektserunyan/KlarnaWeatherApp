//
//  SearchCityView.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import UIKit
import Combine

final class SearchCityView: UIView {
    
    var viewModel: SearchCityViewModel?
    
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let errorLabel = UILabel()

    private var shouldShowInvalidSearchResult: Bool = false
    
    let onQueryChange = PassthroughSubject<String, Never>()
    var onSetDefaultChange = PassthroughSubject<Int, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstraints()
    }
    
    func shouldActivateSearchBar(activate: Bool) {
        searchController.isActive = activate
    }
    
    func reloadCityList() {
        tableView.reloadData()
    }
    
    func shouldShowError(show: Bool) {
        errorLabel.isHidden = !show
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
    
    private func setupViews() {
        searchController.searchResultsUpdater = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchCityCustomCell.self, forCellReuseIdentifier: "Cell")
        
        addSubview(tableView)
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .singleLine
        tableView.tableHeaderView = searchController.searchBar
        
        tableView.addSubview(errorLabel)
        errorLabel.text = "There are some issues with connection"
        errorLabel.textColor = .gray
        errorLabel.font = UIFont.systemFont(ofSize: 16)
        errorLabel.isHidden = true
    }
}

extension SearchCityView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        let trimmedQuery = query.trimmingCharacters(in: .whitespaces)
        if trimmedQuery.count > 1 {
            shouldShowInvalidSearchResult = false
            onQueryChange.send(trimmedQuery)
        } else {
            shouldShowInvalidSearchResult = true
            tableView.reloadData()
        }
    }
}

extension SearchCityView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shouldShowInvalidSearchResult ? 0 : viewModel?.locations.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SearchCityCustomCell
        guard let cell = cell else { return UITableViewCell() }
        
        cell.setDefaultCityButton.tag = indexPath.row
        cell.cancellable = cell.tapButton
            .sink { [weak self] index in
            self?.shouldActivateSearchBar(activate: false)
            self?.onSetDefaultChange.send(index)
        }
        
        if let location = viewModel?.locations.value?[safe: indexPath.row] {
            cell.cityNameLabel.text = "\(location.name) (\(location.country))"
        }
        return cell
    }
}
