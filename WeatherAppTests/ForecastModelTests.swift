
import XCTest
@testable import WeatherApp

final class ForecastModelTests: XCTestCase {
    
    // MARK: - ForecastResponse Parsing
    
    func testForecastResponseParsing() throws {
        
        // MARK: Setup JSON
        
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

        // MARK: Decode
        
        let decoded = try JSONDecoder().decode(ForecastResponse.self, from: json)
        
        // MARK: Location Assertions
        
        XCTAssertEqual(decoded.location.name, "Moscow")
        XCTAssertEqual(decoded.location.country, "Russia")
        
        // MARK: Forecast Assertions
        
        guard let firstDay = decoded.forecast.forecastDays.first else {
            XCTFail("No forecastDays found")
            return
        }

        XCTAssertEqual(firstDay.date, "2025-05-26")
        XCTAssertEqual(firstDay.dayInfo.condition.description, "Sunny")
        XCTAssertEqual(firstDay.dayInfo.averageTempC, 21.3, accuracy: 0.001)
        XCTAssertEqual(firstDay.dayInfo.maxWindKph, 27.7, accuracy: 0.001)
        XCTAssertEqual(firstDay.dayInfo.averageHumidity, 58)
    }
}

