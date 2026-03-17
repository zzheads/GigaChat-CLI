import Foundation

// MARK: - URLRequest
extension URLRequest {
	/// Метод добавляющий заголовок
	/// - Parameters:
	///  - header: URLRequest.HTTPHeader заголовок
	public mutating func add(header: Header) {
		setValue(header.value, forHTTPHeaderField: header.field)
	}

	/// Метод добавляющий параметры
	/// - Parameters:
	///  - parameters: параметры типа RequestParameters
	public mutating func add(parameters: Parameters) {
		switch parameters {
		case .none:
			break
		case .url(let dictionary):
			guard let url = url, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { break }
			components = components.setParameters(dictionary)
			guard let newUrl = components.url else { break }
			self.url = newUrl

		case .json(let dictionary):
			httpBody = try? JSONSerialization.data(withJSONObject: dictionary)
		case .formData(let dictionary):
			httpBody = URLComponents().setParameters(dictionary).query?.data(using: .utf8)
		case .data(let data, _):
			httpBody = data
		}
	}
}
