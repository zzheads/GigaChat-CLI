import Foundation

/// Протокол логирования сервиса NetworkService
public protocol INetworkServiceLogger {
	func log(event: NetworkServiceLoggerEvent)
}
