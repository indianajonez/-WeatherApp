
import Foundation

final class WeatherAPIService {
    
    // MARK: - Properties
    
    private let apiKey: String
    private let session: URLSession
    
    // MARK: - Init
    
    init(session: URLSession = .shared) {
        self.session = session
        self.apiKey = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String ?? ""
    }
    
    // MARK: - Public Methods
    
    func fetchForecast(for city: String) async throws -> ForecastResponse {
        guard let url = buildURL(for: city) else {
            throw WeatherAPIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 15
        
        do {
            let (data, response) = try await session.data(for: request)
            
            try validateResponse(response)
            
            return try decodeForecast(from: data)
        } catch let urlError as URLError {
            throw WeatherAPIError.networkUnavailable
        } catch {
            throw WeatherAPIError.unknown(error)
        }
    }
    
    // MARK: - Private Methods
    
    private func buildURL(for city: String) -> URL? {
        var components = URLComponents(string: "https://api.weatherapi.com/v1/forecast.json")
        components?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "days", value: "5"),
            URLQueryItem(name: "key", value: apiKey)
        ]
        return components?.url
    }
    
    private func validateResponse(_ response: URLResponse) throws {
        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw WeatherAPIError.serverError(statusCode: httpResponse.statusCode)
        }
    }
    
    private func decodeForecast(from data: Data) throws -> ForecastResponse {
        do {
            return try JSONDecoder().decode(ForecastResponse.self, from: data)
        } catch {
            throw WeatherAPIError.decodingFailed
        }
    }
}

