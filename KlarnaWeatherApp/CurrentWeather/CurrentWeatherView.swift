//
//  CurrentWeatherView.swift
//  KlarnaWeatherApp
//
//  Created by Narek Tserunyan on 02.09.23.
//

import UIKit

final class CurrentWeatherView: UIView {
    
    private let contentView = UIView()
    private let backgroundImage = UIImageView()
    private let cityLabel = UILabel()
    
    private let tempStackView = UIStackView()
    private let tempCelciusLabel = UILabel()
    private let tempKelvinLabel = UILabel()
    
    private let conditionLabel = UILabel()
    
    private let feelsLikeStackview = UIStackView()
    private let feelsLikeLabel = UILabel()
    private let feelsLikeValue = UILabel()
    
    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    private let currentLocationError = UILabel()
    
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
    
    func updateUI(with weather: Weather) {
        cityLabel.text = weather.cityName
        tempCelciusLabel.text = TemperatureFormatter().celciusFormatString(from: weather.temperature)
        tempKelvinLabel.text = TemperatureFormatter().kelvinFormatString(temp: weather.temperature)
        feelsLikeValue.text = "\(TemperatureFormatter().celciusFormatString(from: weather.feelsLikeTemperature)) or \(TemperatureFormatter().kelvinFormatString(temp: weather.feelsLikeTemperature))"
        conditionLabel.text = weather.weatherCondition?.weatherDescription
    }
    
    func shoudlShowError(show: Bool) {
        currentLocationError.isHidden = !show
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
    }

    private func setupConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            cityLabel.topAnchor.constraint(equalTo: topAnchor, constant: safeAreaInsets.top + 100)
        ])
        
        tempStackView.translatesAutoresizingMaskIntoConstraints = false
        tempStackView.addArrangedSubview(tempCelciusLabel)
        tempStackView.addArrangedSubview(tempKelvinLabel)
        NSLayoutConstraint.activate([
            tempStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            tempStackView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 20)
        ])
        
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            conditionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            conditionLabel.topAnchor.constraint(equalTo: tempStackView.bottomAnchor, constant: 20)
        ])
                
        feelsLikeStackview.translatesAutoresizingMaskIntoConstraints = false
        feelsLikeStackview.addArrangedSubview(feelsLikeLabel)
        feelsLikeStackview.addArrangedSubview(feelsLikeValue)
        NSLayoutConstraint.activate([
            feelsLikeStackview.centerXAnchor.constraint(equalTo: centerXAnchor),
            feelsLikeStackview.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 40)
        ])
        
        currentLocationError.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentLocationError.centerXAnchor.constraint(equalTo: centerXAnchor),
            currentLocationError.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: 16),
            currentLocationError.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: -16),
            currentLocationError.topAnchor.constraint(equalTo: feelsLikeLabel.bottomAnchor, constant: 10)
        ])
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setupViews() {
        addSubview(contentView)
        contentView.backgroundColor = .black
        
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.clipsToBounds = true
        contentView.addSubview(backgroundImage)
        
        cityLabel.font = UIFont.boldSystemFont(ofSize: 30)
        cityLabel.textColor = .white
        contentView.addSubview(cityLabel)
        
        // Temperature
        tempStackView.axis = .horizontal
        tempStackView.spacing = 5
        tempStackView.alignment = .lastBaseline
        contentView.addSubview(tempStackView)
        
        tempCelciusLabel.text = "--"
        tempCelciusLabel.font = UIFont.systemFont(ofSize: 90)
        tempCelciusLabel.textColor = .white
        contentView.addSubview(tempCelciusLabel)
        
        tempKelvinLabel.font = UIFont.boldSystemFont(ofSize: 15)
        tempKelvinLabel.textColor = .white
        contentView.addSubview(tempKelvinLabel)
        //
        
        conditionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        conditionLabel.textColor = .white
        contentView.addSubview(conditionLabel)
        
        // Feels like
        feelsLikeStackview.axis = .horizontal
        feelsLikeStackview.spacing = 10
        contentView.addSubview(feelsLikeStackview)
        
        feelsLikeLabel.text = "Feels like:"
        feelsLikeLabel.font = UIFont.boldSystemFont(ofSize: 15)
        feelsLikeLabel.textColor = .white
        contentView.addSubview(feelsLikeLabel)
        
        feelsLikeValue.text = "--"
        feelsLikeValue.font = UIFont.boldSystemFont(ofSize: 15)
        feelsLikeValue.textColor = .white
        contentView.addSubview(feelsLikeValue)
        //
        
        currentLocationError.text = "Current location couln't be determined, enable from system settings"
        currentLocationError.isHidden = true
        currentLocationError.font = UIFont.boldSystemFont(ofSize: 15)
        currentLocationError.textColor = .darkText
        currentLocationError.textAlignment = .center
        currentLocationError.numberOfLines = 0
        contentView.addSubview(currentLocationError)
        
        activityIndicator.hidesWhenStopped = true
        contentView.addSubview(activityIndicator)
    }
}
