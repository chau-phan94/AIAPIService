import Foundation
import Alamofire
import Logging

/// Main service implementation for AI API interactions
public final class AIService: AIServiceProtocol {
    private let baseURL: String
    private let session: Session
    private let logger: Logger
    
    /// Initializes the AI service
    /// - Parameters:
    ///   - baseURL: The base URL for the API
    ///   - configuration: Optional URLSession configuration
    public init(baseURL: String, configuration: URLSessionConfiguration = .default) {
        self.baseURL = baseURL
        self.session = Session(configuration: configuration)
        self.logger = Logger(label: "com.aiapi.service")
    }
    
    public func sendRequest<T: Decodable>(_ request: AIRequest, completion: @escaping (Result<T, Error>) -> Void) {
        let url = baseURL + request.endpoint
        
        logger.info("Sending request to: \(url)")
        
        session.request(
            url,
            method: HTTPMethod(rawValue: request.method.rawValue) ?? .get,
            parameters: request.parameters,
            headers: HTTPHeaders(request.headers ?? [:])
        )
        .validate()
        .responseDecodable(of: T.self) { [weak self] response in
            switch response.result {
            case .success(let value):
                self?.logger.info("Request successful")
                completion(.success(value))
            case .failure(let error):
                self?.logger.error("Request failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    public func sendRequest<T: Decodable>(_ request: AIRequest) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            sendRequest(request) { (result: Result<T, Error>) in
                continuation.resume(with: result)
            }
        }
    }
} 