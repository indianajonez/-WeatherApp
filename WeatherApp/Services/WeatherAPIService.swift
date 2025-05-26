
import Foundation

final class WeatherAPIService {
    private let apiKey = "2821e58bf0004b10996100712252605"
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchForecast(for city: String) async throws -> ForecastResponse {
        guard let url = buildURL(for: city) else {
            throw WeatherAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 15

        do {
            let (data, response) = try await session.data(for: request)

            // Проверяем статус-код
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                throw WeatherAPIError.serverError(statusCode: httpResponse.statusCode)
            }

            do {
                let decoded = try JSONDecoder().decode(ForecastResponse.self, from: data)
                return decoded
            } catch {
                throw WeatherAPIError.decodingFailed
            }

        } catch let urlError as URLError {
            // Специфическая ошибка сети (например, no internet)
            throw WeatherAPIError.networkUnavailable
        } catch {
            throw WeatherAPIError.unknown(error)
        }
    }

    private func buildURL(for city: String) -> URL? {
        var components = URLComponents(string: "https://api.weatherapi.com/v1/forecast.json")
        components?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "days", value: "5"),
            URLQueryItem(name: "key", value: apiKey)
        ]
        return components?.url
    }
}

