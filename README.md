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