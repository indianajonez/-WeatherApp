
import Foundation

struct ForecastResponse: Decodable {
    let location: Location
    let forecast: Forecast

    enum CodingKeys: String, CodingKey {
        case location
        case forecast
    }
}

struct Forecast: Decodable {
    let forecastDays: [ForecastDay]

    enum CodingKeys: String, CodingKey {
        case forecastDays = "forecastday"
    }
}

struct ForecastDay: Decodable, Identifiable {
    let date: String
    let dayInfo: Day

    var id: String { date } 

    enum CodingKeys: String, CodingKey {
        case date
        case dayInfo = "day"
    }
}

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

struct Condition: Decodable {
    let description: String
    let iconURL: String

    enum CodingKeys: String, CodingKey {
        case description = "text"
        case iconURL = "icon"
    }
}

struct Location: Decodable {
    let name: String      
    let country: String 
}
