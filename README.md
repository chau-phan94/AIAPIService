# AIAPIService

A Swift package for interacting with AI APIs, built with SOLID principles and modern Swift practices.

## Features

- Protocol-oriented design for easy extension
- Support for both completion handler and async/await patterns
- Built-in logging
- Type-safe request and response models
- Easy to extend with new API endpoints

## Requirements

- iOS 16.0+
- macOS 13.0+
- tvOS 16.0+
- watchOS 9.0+
- Swift 6.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/AIAPIService.git", from: "1.0.0")
]
```

## Usage

### Basic Usage

```swift
import AIAPIService

// Initialize the service
let service = AIService(baseURL: "https://api.example.com")

// Create a request
let request = TextCompletionRequest(prompt: "Hello, how are you?")

// Send request with completion handler
service.sendRequest(request) { (result: Result<TextCompletionResponse, Error>) in
    switch result {
    case .success(let response):
        print(response.choices.first?.text ?? "")
    case .failure(let error):
        print("Error: \(error)")
    }
}

// Or using async/await
Task {
    do {
        let response = try await service.sendRequest(request)
        print(response.choices.first?.text ?? "")
    } catch {
        print(error)
    }
}

## SOLID Principles & Dependency Injection

This library is designed with [SOLID principles](https://en.wikipedia.org/wiki/SOLID) in mind. In particular:

- **Dependency Inversion Principle (DIP):** Core services such as `DefaultAPIService` now accept dependencies (like loggers) via their initializer.
- **Open/Closed Principle (OCP):** You can extend or swap out loggers and other dependencies without modifying the core service logic.

### Customizing the Logger

You can inject any custom logger conforming to `APILogger`:

```swift
import AIAPIService

class MyLogger: APILogger {
    func logRequest(_ urlRequest: URLRequest) {
        print("[MyLogger] Request: \(urlRequest)")
    }
    func logResponse(_ response: URLResponse?, data: Data?) {
        print("[MyLogger] Response: \(String(describing: response))")
    }
}

let customLogger = MyLogger()
let service = DefaultAPIService(logger: customLogger)
```

### Dependency Injection for Gateways

You can now inject dependencies into gateways, such as `OpenAIGateway`, for full SOLID compliance:

```swift
import AIAPIService

let customLogger = MyLogger()
let customService = DefaultAPIService(logger: customLogger)
let gateway = OpenAIGateway(apiService: customService, logger: customLogger)
```

This makes it easy to swap out implementations for testing or customization. All major components now support dependency injection for improved testability and flexibility.

        print("Error: \(error)")
    }
}
```

### Creating Custom Requests

```swift
struct CustomRequest: AIRequest {
    let endpoint: String
    let method: HTTPMethod
    let parameters: [String: Any]?
    let headers: [String: String]?
    
    init(customParameter: String) {
        self.endpoint = "/custom-endpoint"
        self.method = .post
        self.parameters = ["parameter": customParameter]
        self.headers = ["Content-Type": "application/json"]
    }
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details. 