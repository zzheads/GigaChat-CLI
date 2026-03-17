import Foundation

// MARK: - Encodable
extension Encodable {
	/// Объект Encodable в виде Any?
	public var jsonObject: Any? {
		guard let data = try? JSONEncoder().encode(self) else { return nil }
		return try? JSONSerialization.jsonObject(with: data)
	}
	
	/// Объект Encodable в виде JSONString
	public var jsonString: String? {
		guard let data = try? JSONEncoder().encode(self) else { return nil }
		return String(data: data, encoding: .utf8)
	}
}
