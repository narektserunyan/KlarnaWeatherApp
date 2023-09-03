//
//  SearchCityCustomCell.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import UIKit
import Combine

final class SearchCityCustomCell: UITableViewCell {
    
    var cancellable: AnyCancellable?
    let tapButton = PassthroughSubject<Int, Never>()
    
    let setDefaultCityButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Set default", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return btn
    }()
    
    let cityNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16)
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(setDefaultCityButton)
        setDefaultCityButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        setDefaultCityButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            setDefaultCityButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            setDefaultCityButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            setDefaultCityButton.widthAnchor.constraint(equalToConstant: 100),
            setDefaultCityButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        contentView.addSubview(cityNameLabel)
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cityNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cityNameLabel.trailingAnchor.constraint(equalTo: setDefaultCityButton.leadingAnchor, constant: -10),
            cityNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func didTapButton() {
        tapButton.send(setDefaultCityButton.tag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
