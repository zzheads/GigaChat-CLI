import Foundation

/// структура сетевого ответа на запрос
public struct NetworkResponse {
	private let data: Data?
	private let urlResponse: URLResponse?
	private let error: Error?

	/// Инициализация
	/// - Parameters:
	///  - data: Data?
	///  - urlResponse: URLResponse?
	///  - error: Error?
	public init(data: Data?, urlResponse: URLResponse?, error: Error?) {
		self.data = data
		self.urlResponse = urlResponse
		self.error = error
	}

	/// результат сетевого ответа
	public var result: Result<Data?, HTTPNetworkServiceError> {
		if let error = error {
			return .failure(.networkError(error))
		}
		guard let urlResponse = urlResponse as? HTTPURLResponse else {
			return .failure(.invalidResponse(urlResponse))
		}
		guard let status = ResponseStatus(rawValue: urlResponse.statusCode), status.isSuccess else {
			return .failure(.invalidStatusCode(urlResponse.statusCode, data))
		}
		return .success(data)
	}
}
