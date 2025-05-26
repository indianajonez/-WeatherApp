
import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var forecastDays: [ForecastDay] = []
    @Published var locationName: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var city: String = ""
    @Published var country: String = ""




    private let service = WeatherAPIService()
    
    func loadWeather(for city: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await service.fetchForecast(for: city)
            self.forecastDays = response.forecast.forecastDays
            self.city = response.location.name
            self.country = response.location.country
            self.errorMessage = nil
        } catch {
            if let apiError = error as? WeatherAPIError {
                self.errorMessage = apiError.localizedDescription
            } else {
                self.errorMessage = "Произошла неизвестная ошибка."
            }
        }
    }


    // Форматирование даты
    private let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private let readableDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .full
        return formatter
    }()

    func formattedDate(from string: String) -> String {
        guard let date = displayFormatter.date(from: string) else { return string }
        return readableDateFormatter.string(from: date)
    }
    
    func shortFormattedDate(from string: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: string) else { return string }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ru_RU")
        outputFormatter.setLocalizedDateFormatFromTemplate("E, d MMMM")
        return outputFormatter.string(from: date) // пример: "пн, 27 мая"
    }

}
