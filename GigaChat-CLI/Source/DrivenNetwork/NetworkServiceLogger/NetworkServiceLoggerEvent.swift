import Foundation

/// События логирования сервиса NetworkService
public enum NetworkServiceLoggerEvent {
	/// название сервиса
	private static let serviceName = String(describing: NetworkService.self)

	/// перечисление строковых значений заголовков событий
	private enum Title: String {
		case request = "Request"
		case response = "Response"
		case authorization = "Authorization"
		case custom = "Custom"
		case quiet = ""
	}

	/// сетевой запрос
	case request(URLRequest)
	/// ответ на запрос
	case response(Result<Data?, HTTPNetworkServiceError>)
	/// авторизация (установка токена) сервиса NetworkService
	case authorization(String)

	case custom(String)

	case quiet(String)

	/// заголовок события
	public var header: String? {
		if case .quiet = self { return nil }
		return [NetworkServiceLoggerEvent.serviceName, title.rawValue].joined(separator: ": ")
	}

	// MARK: - Private properties

	private var title: Title {
		switch self {
		case .request:
			return .request
		case .response:
			return .response
		case .authorization:
			return .authorization
		case .custom:
			return .custom
		case .quiet:
			return .quiet
		}
	}

	public var context: String {
		switch self {
		case let .request(request): return request.url?.absoluteString ?? "nil"
		case let .authorization(token): return token
		case let .response(result): return "\(result)"
		case let .custom(text): return text
		case let .quiet(text): return text
		}
	}
}

extension NetworkServiceLoggerEvent: CustomStringConvertible {
	public var description: String {
		[header, context].compactMap { $0 }.joined(separator: " ")
	}
}
