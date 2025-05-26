
import XCTest
@testable import WeatherApp

final class ForecastModelTests: XCTestCase {
    func testForecastResponseParsing() throws {
        let json = """
        {
            "location": {
                "name": "Moscow",
                "country": "Russia"
            },
            "forecast": {
                "forecastday": [
                    {
                        "date": "2025-05-26",
                        "day": {
                            "avgtemp_c": 21.3,
                            "maxwind_kph": 27.7,
                            "avghumidity": 58,
                            "condition": {
                                "text": "Sunny",
                                "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png"
                            }
                        }
                    }
                ]
            }
        }
        """.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(ForecastResponse.self, from: json)
        XCTAssertEqual(decoded.location.name, "Moscow")
        XCTAssertEqual(decoded.location.country, "Russia")

        let firstDay = decoded.forecast.forecastDays.first!
        XCTAssertEqual(firstDay.date, "2025-05-26")
        XCTAssertEqual(firstDay.dayInfo.condition.description, "Sunny")
        XCTAssertEqual(firstDay.dayInfo.averageTempC, 21.3)
        XCTAssertEqual(firstDay.dayInfo.maxWindKph, 27.7)
        XCTAssertEqual(firstDay.dayInfo.averageHumidity, 58)
    }
}
