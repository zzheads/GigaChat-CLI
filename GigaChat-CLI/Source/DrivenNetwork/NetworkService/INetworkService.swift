import Foundation

/// Протокол сетевого слоя.
public protocol INetworkService: AnyObject {
	
	var requestBuilder: IURLRequestBuilder { get }
	var baseUrl: URL { get }
	var decoder: JSONDecoder { get }
	
	/// Логгер событий сервиса
	var logger: INetworkServiceLogger? { get set }
	
	/// Метод установки авторизационного токена для подписи запросов
	/// - Parameter token: авторизационный токен
	func set(token: String)

	/// Метод выполнения запроса
	/// - Parameters:
	///  - urlRequest: URLRequest для запроса
	///  - completion: замыкание обработки результата запроса Result<Data?, HTTPNetworkServiceError>
	func perform(urlRequest: URLRequest, completion: @escaping (Result<Data?, HTTPNetworkServiceError>) -> Void)

	/// Метод выполнения запроса модели данных T: Decodable
	/// - Parameters:
	///  - request: модель requestProtocol для запроса
	///  - completion: замыкание обработки результата запроса Result<T, HTTPNetworkServiceError>
	func perform<T: Decodable>(
		_ request: NetworkRequest,
		completion: @escaping (Result<T, HTTPNetworkServiceError>) -> Void
	)
	
	/// Метод выполнения запроса, когда успех - Void
	/// - Parameters:
	///  - request: модель NetworkRequest для запроса
	///  - completion: замыкание обработки результата запроса Result<Void, HTTPNetworkServiceError>
	func perform(
		_ request: NetworkRequest,
		completion: @escaping (Result<Void, HTTPNetworkServiceError>) -> Void
	)
	
	/// Метод выполнения запроса данных Data
	/// - Parameters:
	///  - request: модель NetworkRequest для запроса
	///  - completion: замыкание обработки результата запроса Result<Data?, HTTPNetworkServiceError>
	func perform(
		_ request: NetworkRequest,
		completion: @escaping (Result<Data?, HTTPNetworkServiceError>) -> Void
	)
	
	func perform<T: Decodable>(_ request: NetworkRequest) async -> Result<T, HTTPNetworkServiceError>
    
    func perform<T: Decodable>(_ request: NetworkRequest) async throws (HTTPNetworkServiceError) -> T
}

extension INetworkService {
	public func perform<T: Decodable>(_ request: NetworkRequest) async -> Result<T, HTTPNetworkServiceError> {
		await withCheckedContinuation { [weak self] continuation in
			self?.perform(request) { continuation.resume(returning: $0) }
		}
	}
    
    public func perform<T: Decodable>(_ request: NetworkRequest) async throws (HTTPNetworkServiceError) -> T {
        let result: Result<T, HTTPNetworkServiceError> = await perform(request)
        switch result {
        case let .success(response):
            return response
        case let .failure(error):
            throw error
        }
    }

}
