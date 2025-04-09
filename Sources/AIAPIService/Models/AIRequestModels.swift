import Foundation

/// Sample request model for text completion
public struct TextCompletionRequest: AIRequest {
    public let endpoint: String
    public let method: HTTPMethod
    public let parameters: [String: Any]?
    public let headers: [String: String]?
    
    /// Creates a text completion request
    /// - Parameters:
    ///   - prompt: The text prompt to complete
    ///   - maxTokens: Maximum number of tokens to generate
    ///   - temperature: Sampling temperature
    public init(
        prompt: String,
        maxTokens: Int = 100,
        temperature: Double = 0.7
    ) {
        self.endpoint = "/v1/completions"
        self.method = .post
        self.parameters = [
            "prompt": prompt,
            "max_tokens": maxTokens,
            "temperature": temperature
        ]
        self.headers = [
            "Content-Type": "application/json"
        ]
    }
}

/// Response model for text completion
public struct TextCompletionResponse: Decodable {
    public let id: String
    public let choices: [Choice]
    public let created: Int
    public let model: String
    
    public struct Choice: Decodable {
        public let text: String
        public let index: Int
        public let finishReason: String
        
        enum CodingKeys: String, CodingKey {
            case text
            case index
            case finishReason = "finish_reason"
        }
    }
} 