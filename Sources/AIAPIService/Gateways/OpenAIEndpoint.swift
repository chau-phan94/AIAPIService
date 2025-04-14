//
//  OpenAIEndpoint.swift
//  InvestmentAssistance
//
//  Created by JLYVM206TH on 25/3/25.
//

import Combine
import Foundation

public class APIKey {
    static public let share = APIKey()
    private var key = ""
    
    private init() {}
    
    public func setkey(key: String) {
        self.key = key
    }
    
    fileprivate func getKey() -> String {
        return key
    }
}

enum OpenAIEndpoint {
    case models
    case completions(model: String, prompt: String, maxTokens: Int)
    case analyze(prompt: String, text: String)
}

extension OpenAIEndpoint: Endpoint {
    
    // Base URL for OpenAI API
    var base: String? {
        "https://api.openai.com"
    }
    
    // Path for different endpoints
    var path: String? {
        switch self {
        case .models:
            return "/v1/models"
        case .completions, .analyze(_):
            return "/v1/chat/completions"
        }
    }
    
    var headers: [String : Any]? {
        [
            "Authorization": "Bearer \(APIKey.share.getKey())",
            "Content-Type": "application/json"
        ]
    }
    
    // Custom query string, if any (e.g., for completions request)
    var urlString: String? {
        // No dynamic URLs needed here, we use static path based on the case
        return nil
    }
    
    // Query parameters (if any)
    var queryItems: [String: Any]? {
        switch self {
        case let .completions(model, prompt, maxTokens):
            return [
                "model": model,
                "prompt": prompt,
                "max_tokens": maxTokens
            ]
        default:
            return nil
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case let .analyze(prompt: prompt, text: text):
            return [
                "model": "gpt-4o-mini",
                "messages": [
                    [
                        "role": "user",
                        "content": [
                            ["type": "text",
                             "text": "\(prompt)"],
                            ["type": "text", "text": text]
                        ]
                    ]
                ]
            ]
        case let .completions(model: model, prompt: prompt, maxTokens: maxTokens):
                return [
                    "model": "\(model)",
                    "messages": [
                        [
                            "role": "user",
                            "content": [
                                ["type": "text",
                                 "text": "\(prompt)"]
                            ]
                        ]
                    ]
                ]
        default:
            return nil
            
        }
    }
    
    var httpMethod: HttpMethod {
        return .post
    }
}
