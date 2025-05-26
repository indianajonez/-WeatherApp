//
//  MockURLProtocol.swift
//  WeatherAppTests
//
//  Created by Ekaterina Saveleva on 26.05.2025.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    static var stubResponseData: Data?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        if let data = MockURLProtocol.stubResponseData {
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }


    override func stopLoading() { }
    
    
}
