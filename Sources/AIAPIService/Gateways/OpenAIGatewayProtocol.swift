//
//  OpenAIGatewayProtocol.swift
//  InvestmentAssistance
//
//  Created by JLYVM206TH on 25/3/25.
//

import Combine
import Factory

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
    func createCompletion(model: String, prompt: String, maxTokens: Int) -> AnyPublisher<String, Error>  // For fetching completions
}

extension OpenAIGatewayProtocol {
    public func createCompletion(prompt: String) -> AnyPublisher<String, Error> {
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
    func createCompletion(model: String, prompt: String, maxTokens: Int) -> AnyPublisher<String, Error> {
        APIServices.default
            .request(OpenAIEndpoint.completions(model: model, prompt: prompt, maxTokens: maxTokens))
            .data(type: CompletionsResult.self)
            .map { $0.choices.first?.text ?? "" }
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
    func createCompletion(model: String, prompt: String, maxTokens: Int) -> AnyPublisher<String, Error> {
        Future<String, Error> { promise in
            let completionText = "This is a mocked completion for the prompt: \(prompt)"
            promise(.success(completionText))
        }
        .eraseToAnyPublisher()
    }
}

public extension Container {
    public var openAIGateway: Factory<OpenAIGatewayProtocol> {
        Factory(self) {
            OpenAIGateway()
        }
        .onPreview {
            PreviewOpenAIGateway()
        }
    }
}
