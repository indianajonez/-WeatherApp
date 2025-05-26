//
//  WeatherAPIService.swift
//  WeatherAppTests
//
//  Created by Ekaterina Saveleva on 26.05.2025.
//

import XCTest
@testable import WeatherApp

final class WeatherAPIServiceTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        URLProtocol.registerClass(MockURLProtocol.self)
    }

    override class func tearDown() {
        URLProtocol.unregisterClass(MockURLProtocol.self)
        super.tearDown()
    }

    func testFetchForecastSuccess() async throws {
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
        let response = try await service.fetchForecast(for: "Moscow")

        XCTAssertEqual(response.location.name, "Moscow")
        XCTAssertEqual(response.forecast.forecastDays.count, 1)
        XCTAssertEqual(response.forecast.forecastDays.first?.dayInfo.condition.description, "Sunny")
    }
}
