
import XCTest
@testable import WeatherApp

// MARK: - WeatherAPIServiceTests

final class WeatherAPIServiceTests: XCTestCase {
    
    // MARK: - Setup / Teardown
    
    override class func setUp() {
        super.setUp()
        URLProtocol.registerClass(MockURLProtocol.self)
    }

    override class func tearDown() {
        URLProtocol.unregisterClass(MockURLProtocol.self)
        super.tearDown()
    }
    
    // MARK: - Tests

    func testFetchForecastSuccess() async throws {
        
        // MARK: Given
        
        let expectedJSON = """
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

        MockURLProtocol.stubResponseData = expectedJSON

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let service = WeatherAPIService(session: session)

        // MARK: When
        
        let response = try await service.fetchForecast(for: "Moscow")

        // MARK: Then
        
        guard let firstDay = response.forecast.forecastDays.first else {
            XCTFail("No forecast day found")
            return
        }

        XCTAssertEqual(response.location.name, "Moscow")
        XCTAssertEqual(response.location.country, "Russia")
        XCTAssertEqual(firstDay.date, "2025-05-26")
        XCTAssertEqual(firstDay.dayInfo.condition.description, "Sunny")
        XCTAssertEqual(firstDay.dayInfo.averageTempC, 21.3, accuracy: 0.001)
        XCTAssertEqual(firstDay.dayInfo.maxWindKph, 27.7, accuracy: 0.001)
        XCTAssertEqual(firstDay.dayInfo.averageHumidity, 58)
    }
}

