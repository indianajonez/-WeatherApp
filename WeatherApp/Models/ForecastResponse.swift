
import Foundation

// MARK: - ForecastResponse

struct ForecastResponse: Decodable {
    let location: Location
    let forecast: Forecast
}

// MARK: - Forecast

struct Forecast: Decodable {
    let forecastDays: [ForecastDay]

    enum CodingKeys: String, CodingKey {
        case forecastDays = "forecastday"
    }
}

// MARK: - ForecastDay

struct ForecastDay: Decodable, Identifiable {
    let date: String
    let dayInfo: Day

    var id: String { date }

    enum CodingKeys: String, CodingKey {
        case date
        case dayInfo = "day"
    }
}

// MARK: - Day

struct Day: Decodable {
    let averageTempC: Double
    let maxWindKph: Double
    let averageHumidity: Double
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case averageTempC = "avgtemp_c"
        case maxWindKph = "maxwind_kph"
        case averageHumidity = "avghumidity"
        case condition
    }
}

// MARK: - Condition

struct Condition: Decodable {
    let description: String
    let iconURL: String

    enum CodingKeys: String, CodingKey {
        case description = "text"
        case iconURL = "icon"
    }
}

// MARK: - Location

struct Location: Decodable {
    let name: String
    let country: String
}
