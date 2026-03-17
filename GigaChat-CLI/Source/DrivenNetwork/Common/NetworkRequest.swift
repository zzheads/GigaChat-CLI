import Foundation

/// Протокол для создания сетевых запросов.
public protocol NetworkRequest {
	/// Путь запроса.
	var path: String { get }
	/// HTTP Метод, указывающий тип запроса.
	var method: HTTPMethod { get }
	/// HTTP заголовок.
	var headers: HTTPHeaders? { get }
	/// Параметры запроса.
	var parameters: [Parameters] { get }
}
