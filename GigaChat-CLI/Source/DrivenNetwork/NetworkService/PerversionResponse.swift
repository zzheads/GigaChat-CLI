import Foundation

struct PerversionResponse: Codable, Equatable {
	static let serviceUnavailable = PerversionResponse(
		value: "temporarily unavalable",
		code: 500
	)

	let value: String
	let code: Int
}
