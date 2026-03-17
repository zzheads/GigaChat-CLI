import Foundation

/// Параметры передаваемые с запросом
public enum Parameters {
	/// отсутствие параметров
	case none
	/// параметры передаваемые в URL запроса
	case url([String: Any])
	/// параметры передаваемые в теле запроса, кодируемые как JSON
	case json([String: Any]?)
	/// параметры передаваемые в теле запроса, кодируемые как urlencoded
	case formData([String: Any])
	/// параметры передаваемые в теле запроса, как Data, с указанием типа контента
	case data(Data, ContentType)
	
	/// тип контента параметров
	public var contentType: ContentType? {
		switch self {
		case .none, .url:
			return nil
		case let .data(_, type):
			return type
		case .formData:
			return .urlencoded
		case .json:
			return .json
		}
	}
}
