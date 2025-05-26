
import Foundation

enum WeatherAPIError: Error, LocalizedError {
    case invalidURL
    case decodingFailed
    case networkUnavailable
    case serverError(statusCode: Int)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Некорректный адрес запроса."
        case .decodingFailed:
            return "Ошибка при обработке данных от сервера."
        case .networkUnavailable:
            return "Отсутствует подключение к интернету. Возможно включен VPN."
        case .serverError(let code):
            return "Ошибка сервера (код: \(code))."
        case .unknown(let error):
            return "Неизвестная ошибка: \(error.localizedDescription)"
        }
    }
}

