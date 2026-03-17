import Foundation

/// Описание кодов ответа.
public enum ResponseCode {
	static let informationalCodes = 100..<200
	static let successCodes = 200..<300
	static let redirectCodes = 300..<400
	static let clientErrorCodes = 400..<500
	static let serverErrorCodes = 500..<600
}

/// Коды ответа сервера на запрос.
public enum ResponseStatus {
	case informational(Int)
	case success(Int)
	case redirect(Int)
	case clientError(Int)
	case serverError(Int)
	
	public init?(rawValue: Int) {
		if ResponseCode.informationalCodes.contains(rawValue) {
			self = .informational(rawValue)
		} else if ResponseCode.successCodes.contains(rawValue) {
			self = .success(rawValue)
		} else if ResponseCode.redirectCodes.contains(rawValue) {
			self = .redirect(rawValue)
		} else if ResponseCode.clientErrorCodes.contains(rawValue) {
			self = .clientError(rawValue)
		} else if ResponseCode.serverErrorCodes.contains(rawValue) {
			self = .serverError(rawValue)
		} else {
			return nil
		}
	}
	
	var codes: Range<Int> {
		switch self {
		case .informational:
			return ResponseCode.informationalCodes
		case .success:
			return ResponseCode.successCodes
		case .redirect:
			return ResponseCode.redirectCodes
		case .clientError:
			return ResponseCode.clientErrorCodes
		case .serverError:
			return ResponseCode.serverErrorCodes
		}
	}
	
	public var isSuccess: Bool {
		if case .success = self {
			return true
		} else {
			return false
		}
	}
}
