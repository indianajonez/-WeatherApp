
import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var forecastDays: [ForecastDay] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var city: String = ""
    @Published var country: String = ""
    
    // MARK: - Private Properties
    
    private let service = WeatherAPIService()
    
    private let inputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .full
        return formatter
    }()
    
    private let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.setLocalizedDateFormatFromTemplate("E, d MMMM")
        return formatter
    }()
    
    // MARK: - Public Methods
    
    func loadWeather(for city: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await service.fetchForecast(for: city)
            self.forecastDays = response.forecast.forecastDays
            self.city = response.location.name
            self.country = response.location.country
            self.errorMessage = nil
        } catch let apiError as WeatherAPIError {
            self.errorMessage = apiError.localizedDescription
        } catch {
            self.errorMessage = "Произошла неизвестная ошибка."
        }
    }
    
    func formattedDate(from string: String) -> String {
        guard let date = inputDateFormatter.date(from: string) else { return string }
        return fullDateFormatter.string(from: date)
    }
    
    func shortFormattedDate(from string: String) -> String {
        guard let date = inputDateFormatter.date(from: string) else { return string }
        return shortDateFormatter.string(from: date)
    }
}

