//
//  OpenAIGatewayProtocol.swift
//  InvestmentAssistance
//
//  Created by JLYVM206TH on 25/3/25.
//

import Combine
import Factory
import Foundation

enum OpenAIModel: String {
    case gpt4 = "gpt-4"
    case gpt4oMini = "gpt-4o-mini"
    case gpt3_5Turbo = "gpt-3.5-turbo"
    case textDavinci003 = "text-davinci-003"
    case textCurie001 = "text-curie-001"
    case codeDavinci002 = "code-davinci-002"
    
    // Helper function to get the raw value
    var modelName: String {
        return self.rawValue
    }
    
    static var defaultModel: String {
        Self.gpt4oMini.modelName
    }
    
    static var defaultMaxTokens: Int {
        return 2000
    }
}

public protocol OpenAIGatewayProtocol {
    func getModels() -> AnyPublisher<[String], Error>  // For fetching available models
    func createCompletion<T: Decodable>(model: String, prompt: String, maxTokens: Int) -> AnyPublisher<T, Error>  // For fetching completions
}

extension OpenAIGatewayProtocol {
    public func createCompletion<T: Decodable>(prompt: String) -> AnyPublisher<T, Error> {
        return createCompletion(model: OpenAIModel.gpt4oMini.rawValue, prompt: prompt, maxTokens: OpenAIModel.defaultMaxTokens)
    }
}

struct OpenAIGateway: OpenAIGatewayProtocol {
    
    // Models endpoint response
    private struct ModelsResult: Decodable {
        var data: [String]
    }
    
    // Completions endpoint response
    private struct CompletionsResult: Decodable {
        var choices: [CompletionChoice]
    }
    
    // Helper struct for completion choices
    private struct CompletionChoice: Decodable {
        var text: String
    }
    
    // Fetch available models
    func getModels() -> AnyPublisher<[String], Error> {
        APIServices.default
            .request(OpenAIEndpoint.models)
            .data(type: ModelsResult.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
    
    // Create a completion for a given model, prompt, and token limit
    func createCompletion<T: Decodable>(model: String, prompt: String, maxTokens: Int) -> AnyPublisher<T, Error> {
        APIServices.default
            .request(OpenAIEndpoint.completions(model: model, prompt: prompt, maxTokens: maxTokens))
            .data(type: T.self)
            .eraseToAnyPublisher()
    }
}

struct PreviewOpenAIGateway: OpenAIGatewayProtocol {
    
    // Return mock models
    func getModels() -> AnyPublisher<[String], Error> {
        Future<[String], Error> { promise in
            let models = ["text-davinci-003", "text-curie-001", "code-davinci-002"]
            promise(.success(models))
        }
        .eraseToAnyPublisher()
    }
    
    // Return mock completion text
    func createCompletion<T: Decodable>(model: String, prompt: String, maxTokens: Int) -> AnyPublisher<T, Error> {
        Future<T, Error> { promise in
            let completionText = "This is a mocked completion for the prompt: \(prompt)"
            let mockResponse = ["text": completionText]
            
            do {
                let data = try JSONSerialization.data(withJSONObject: mockResponse, options: [])
                let decoded = try JSONDecoder().decode(T.self, from: data)
                promise(.success(decoded))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}

public extension Container {
    var openAIGateway: Factory<OpenAIGatewayProtocol> {
        Factory(self) {
            OpenAIGateway()
        }
        .onPreview {
            PreviewOpenAIGateway()
        }
    }
}
