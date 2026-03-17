import Foundation

/// Заголовки запроса в виде словаря String: String
public typealias HTTPHeaders = [String: String]

/// некоторые из возможных типов заголовков
public enum Header {
	/// авторизация
	case authorization(String)
    case token(String)
	/// content-type
	case contentType(ContentType)
    
    case accept(ContentType)
    case rqUID(String)
    
	/// название заголовка
	public var field: String {
		switch self {
        case .authorization, .token:
			return "Authorization"
		case .contentType:
			return "Content-Type"
        case .accept:
            return "Accept"
        case .rqUID:
            return "rqUID"
		}
	}

	/// значение заголовка
	public var value: String {
		switch self {
		case let .authorization(token):
			return "Basic \(token)"
        case let .token(token):
            return "Bearer \(token)"
		case let .contentType(contentType):
			return contentType.rawValue
        case let .accept(contentType):
            return contentType.rawValue
        case let .rqUID(rqUID):
            return rqUID
		}
	}
}

extension Array where Element == Header {
    var headers: HTTPHeaders {
        var result = HTTPHeaders()
        forEach {
            result[$0.field] = $0.value
        }
        return result
    }
}

/// Возможные значения заголовка "Content-Type"
public enum ContentType: String {
	case json = "application/json"
	case urlencoded = "application/x-www-form-urlencoded"
	case gif = "image/gif"
	case jpeg = "image/jpeg"
	case png = "image/png"
	case tiff = "image/tiff"
	case svg = "image/svg+xml"
}
