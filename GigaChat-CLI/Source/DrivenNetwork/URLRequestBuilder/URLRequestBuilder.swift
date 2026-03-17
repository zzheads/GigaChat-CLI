import Foundation

/// Класс для формирования URLRequest из NetworkRequest
public final class URLRequestBuilder {
	
	// MARK: - Public properties
	
	public var token: String?
	public var dataSource: IURLRequestBuilderDataSource?	
	public let baseUrl: URL
	
	/// Инициализация
	public init(baseUrl: URL, dataSource: IURLRequestBuilderDataSource?) {
		self.baseUrl = baseUrl
		self.dataSource = dataSource
	}
}

extension URLRequestBuilder: IURLRequestBuilder {
	/// Формирование URLRequest из модели NetworkRequest
	/// с соответствующим методом, URL, headers и httpBody
	/// - Parameters:
	///  - request: модель NetworkRequest
	/// - Returns: URLRequest
	public func urlRequest(forRequest request: NetworkRequest) -> URLRequest {
		let url = baseUrl.appendingPathComponent(request.path)
		var urlRequest = URLRequest(url: url)
		
		urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
		dataSource?.headers()?.forEach { header in
			urlRequest.allHTTPHeaderFields?.updateValue(header.value, forKey: header.key)
		}

		/// добавляем параметры запроса
		for parameters in request.parameters {
			urlRequest.add(parameters: parameters)

			/// добавляем заголовки, если нужно и возможно
			/// Content-Type
			if let contentType = parameters.contentType {
				urlRequest.add(header: .contentType(contentType))
			}
		}
		
		/// Authorization
		if let token = token {
			urlRequest.add(header: .token(token))
		}
		return urlRequest
	}
}
