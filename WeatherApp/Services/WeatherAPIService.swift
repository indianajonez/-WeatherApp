//
//  WeatherAPIService.swift
//  WeatherApp
//
//  Created by Ekaterina Saveleva on 26.05.2025.
// "2821e58bf0004b10996100712252605"

import Foundation

class WeatherAPIService {
    private let apiKey = "2821e58bf0004b10996100712252605"
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchForecast(for city: String) async throws -> ForecastResponse {
        let urlString = "https://api.weatherapi.com/v1/forecast.json?q=\(city)&days=5&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(ForecastResponse.self, from: data)
    }
}
