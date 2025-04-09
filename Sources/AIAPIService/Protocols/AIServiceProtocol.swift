import Foundation
import ComposableArchitecture

/// Protocol defining the contract for AI services
public protocol AIServiceProtocol {
    /// Sends a request to the AI service
    /// - Parameters:
    ///   - request: The request to send
    ///   - completion: Completion handler with the result
    func sendRequest<T: Decodable>(_ request: AIRequest, completion: @escaping (Result<T, Error>) -> Void)
    
    /// Sends a request to the AI service using async/await
    /// - Parameter request: The request to send
    /// - Returns: The decoded response
    func sendRequest<T: Decodable>(_ request: AIRequest) async throws -> T
}

/// Protocol defining the contract for AI requests
public protocol AIRequest {
    /// The endpoint for the request
    var endpoint: String { get }
    
    /// The HTTP method for the request
    var method: HTTPMethod { get }
    
    /// The parameters for the request
    var parameters: [String: Any]? { get }
    
    /// The headers for the request
    var headers: [String: String]? { get }
}

/// HTTP methods supported by the service
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
} 