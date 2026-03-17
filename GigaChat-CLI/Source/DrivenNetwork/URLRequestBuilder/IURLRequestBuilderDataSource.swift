import Foundation

public protocol IURLRequestBuilderDataSource: AnyObject {
	func headers() -> HTTPHeaders?
}
