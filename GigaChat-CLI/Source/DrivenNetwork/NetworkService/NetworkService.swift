import Foundation

/// Класс сетевого сервиса
public class NetworkService: NSObject {
	// MARK: - Public properties

	public var logger: INetworkServiceLogger?
	public let decoder: JSONDecoder
	public let requestBuilder: IURLRequestBuilder
	public var baseUrl: URL { requestBuilder.baseUrl }

	// MARK: - Private properties

    private lazy var session: URLSession = .init(configuration: .default, delegate: self, delegateQueue: nil)

	// MARK: - Initialization

	/// Инициализация сервиса
	/// - Parameters:
	///  - session: URLSession
	///  - decoder: JSONDecoder
	///  - baseUrl: URL базовый URL всех запросов
	///  - logger: логгер
	public init(
		decoder: JSONDecoder = .init(),
		requestBuilder: IURLRequestBuilder,
		logger: INetworkServiceLogger?
	) {
		self.decoder = decoder
		self.requestBuilder = requestBuilder
		self.logger = logger
	}
}

// MARK: - INetworkService
extension NetworkService: INetworkService {
	
	/// Метод установки авторизационного токена для подписи запросов
	/// - Parameter token: авторизационный токен
	public func set(token: String) {
		logger?.log(event: .authorization(token))
		requestBuilder.token = token
	}
	
	/// Метод выполнения запроса
	/// - Parameters:
	///  - urlRequest: URLRequest для запроса
	///  - completion: замыкание обработки результата запроса Result<Data?, HTTPNetworkServiceError>
	public func perform(urlRequest: URLRequest, completion: @escaping (Result<Data?, HTTPNetworkServiceError>) -> Void) {
		logger?.log(event: .request(urlRequest))
		let task = session.dataTask(with: urlRequest) { [weak self] data, urlResponse, error in
			let networkResponse = NetworkResponse(data: data, urlResponse: urlResponse, error: error)
			self?.logger?.log(event: .response(networkResponse.result))
			completion(networkResponse.result)
		}
		task.resume()
	}
}

extension INetworkService {
	/// Метод выполнения запроса данных Data
	/// - Parameters:
	///  - request: модель NetworkRequest для запроса
	///  - completion: замыкание обработки результата запроса Result<Data?, HTTPNetworkServiceError>
	public func perform(
		_ request: NetworkRequest,
		completion: @escaping (Result<Data?, HTTPNetworkServiceError>) -> Void
	) {
		let urlRequest = requestBuilder.urlRequest(forRequest: request)
		perform(urlRequest: urlRequest, completion: completion)
	}

	/// Метод выполнения запроса модели данных T: Decodable
	/// - Parameters:
	///  - request: модель NetworkRequest для запроса
	///  - completion: замыкание обработки результата запроса Result<T, HTTPNetworkServiceError>
	public func perform<T: Decodable>(
		_ request: NetworkRequest,
		completion: @escaping (Result<T, HTTPNetworkServiceError>) -> Void
	) {
		let urlRequest = requestBuilder.urlRequest(forRequest: request)
		perform(urlRequest: urlRequest) { [weak self] result in
			guard let self = self else {
				completion(.failure(.noData))
				return
			}
			switch result {
			case let .success(data):
				guard let data = data else {
					completion(.failure(.noData))
					return
				}
				if let response = try? self.decoder.decode(PerversionResponse.self, from: data), response == .serviceUnavailable {
					completion(.failure(.serviceUnavailable))
				} else {
					let message = "Decoding: \(T.self) from: \(String(data: data, encoding: .utf8) ?? "nil")"
					do {
						self.logger?.log(event: .custom(message))
						let object = try self.decoder.decode(T.self, from: data)
						completion(.success(object))
					} catch {
						print(String(repeating: "\n", count: 10))
						print(message)
						completion(.failure(.failedToDecodeResponse(error)))
					}
				}
			case let .failure(error):
				completion(.failure(error))
			}
		}
	}

	/// Метод выполнения запроса, когда успех - Void
	/// - Parameters:
	///  - request: модель NetworkRequest для запроса
	///  - completion: замыкание обработки результата запроса Result<Void, HTTPNetworkServiceError>
	public func perform(
		_ request: NetworkRequest,
		completion: @escaping (Result<Void, HTTPNetworkServiceError>) -> Void
	) {
		perform(request) { (result: Result<Data?, HTTPNetworkServiceError>) in
			switch result {
			case .success:
				completion(.success(Void()))
			case let .failure(error):
				completion(.failure(error))
			}
		}
	}
}

extension NetworkService: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let trust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: trust))
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
