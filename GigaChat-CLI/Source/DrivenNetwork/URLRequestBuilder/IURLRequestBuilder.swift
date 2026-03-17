import Foundation

/// Протокол модуля формирования URLRequest из модели NetworkRequest
public protocol IURLRequestBuilder: AnyObject {
	/// Токен сессии для авторизации запросов
	var token: String? { get set }

	var baseUrl: URL { get }
	var dataSource: IURLRequestBuilderDataSource? { get set }

	/// Формирование URLRequest из модели NetworkRequest
	/// с соответствующим методом, URL, headers и httpBody
	/// - Parameters:
	///  - request: модель NetworkRequest
	/// - Returns: URLRequest
	func urlRequest(forRequest request: NetworkRequest) -> URLRequest
}
