import Foundation

/// Ошибки сетевого слоя.
public enum HTTPNetworkServiceError: Error {
	internal enum ReasonKey: String {
		case networkError = "Network error"
		case invalidResponse = "Invalid response"
		case invalidStatusCode = "Invalid status code"
		case noData = "No data"
		case failedToDecodeResponse = "Failed to decode response"
		case serviceUnavailable = "Service unavailable"
	}
	
	/// Сетевая ошибка
	case networkError(Error)
	/// Ответ сервера имеет неожиданный формат.
	case invalidResponse(URLResponse?)
	/// Статус кода ответа не входит в диапазон успешных `(200..<300)`.
	case invalidStatusCode(Int, Data?)
	/// Нет данных
	case noData
	/// Не удалось распарсить ответ.
	case failedToDecodeResponse(Error)

	case serviceUnavailable
	
	public var reasonMessage: String {
		[reasonKey.rawValue, reasonContext].compactMap { $0 }.joined(separator: ": ")
	}
	
	// MARK: - Internal properties
	
	internal var reasonContext: String? {
		switch self {
		case let .networkError(error):
			return error.localizedDescription
		case let .invalidResponse(response):
			return response.debugDescription
		case let .invalidStatusCode(code, data):
			var context = "status code = \(code)"
			if let data = data, let message = String(data: data, encoding: .utf8) {
				context = [context, message].joined(separator: ", ")
			}
			return context
		case .noData, .serviceUnavailable:
			return nil
		case let .failedToDecodeResponse(error):
			return error.localizedDescription
		}
	}
	
	internal var reasonKey: ReasonKey {
		switch self {
		case .networkError:
			return .networkError
		case .invalidResponse:
			return .invalidResponse
		case .invalidStatusCode:
			return .invalidStatusCode
		case .noData:
			return .noData
		case .failedToDecodeResponse:
			return .failedToDecodeResponse
		case .serviceUnavailable:
			return .serviceUnavailable
		}
	}
}

extension HTTPNetworkServiceError: LocalizedError {
	/// A localized message describing what error occurred.
	public var errorDescription: String? { reasonMessage }

	/// A localized message describing the reason for the failure.
	public var failureReason: String? { reasonMessage }
}

extension HTTPNetworkServiceError: Equatable {
	public static func == (lhs: HTTPNetworkServiceError, rhs: HTTPNetworkServiceError) -> Bool {
		lhs.reasonMessage == rhs.reasonMessage
	}
}
