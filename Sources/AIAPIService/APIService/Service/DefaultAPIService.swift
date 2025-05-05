import Foundation

/// A singleton class that conforms to `APIService`, `DownloadWithProgress`, and `DataWithProgress` protocols.
/// Provides a default implementation for making network requests, downloading files with progress, and handling data tasks with progress.
public final class DefaultAPIService: APIService, DownloadWithProgress, DataWithProgress {
    /// The shared instance of `DefaultAPIService`.
    public static let shared = DefaultAPIService()
    
    /// The URLSession used for general network requests.
    public let session: URLSession
    
    /// The URLSession used for download tasks with progress.
    public var downloadSession: URLSession
    
    /// The handler for managing download task events.
    public var downloadTaskHandler = DownloadTaskHandler()
    
    /// The URLSession used for data tasks with progress.
    public var dataSession: URLSession
    
    /// The handler for managing data task events.
    public var dataTaskHandler = DataTaskHandler()
    
    /// The logger used for logging API requests and responses.
    public var logger: APILogger {
        didSet {
            dataTaskHandler.logger = logger
            downloadTaskHandler.logger = logger
        }
    }
    
    /// Initializes DefaultAPIService with dependency injection for logger.
    /// - Parameters:
    ///   - logger: The APILogger implementation to use. Defaults to IntermediateLogger.shared.
    public init(logger: APILogger = IntermediateLogger.shared) {
        self.logger = logger
        // Session for request
        self.session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        
        // Session for downloading
        let downloadConfiguration = URLSessionConfiguration.default.copy() as! URLSessionConfiguration
        downloadConfiguration.timeoutIntervalForRequest = 30.0  // 30 seconds for request timeout
        downloadConfiguration.timeoutIntervalForResource = 60.0  // 60 seconds for resource timeout
        // Set the maximum number of simultaneous connections to a host
        downloadConfiguration.httpMaximumConnectionsPerHost = 5
        // Allow cellular access if needed
        downloadConfiguration.allowsCellularAccess = true  // Set to false if you want to restrict to Wi-Fi
        // Enable discretionary downloading
        downloadConfiguration.isDiscretionary = true
        // Create a URLSession with the configured settings
        self.downloadSession = URLSession(configuration: downloadConfiguration, delegate: downloadTaskHandler, delegateQueue: nil)
        
        // Session for data
        let dataConfiguration = downloadConfiguration.copy() as! URLSessionConfiguration
        self.dataSession = URLSession(configuration: dataConfiguration, delegate: dataTaskHandler, delegateQueue: nil)
        
        // Propagate logger to handlers
        self.dataTaskHandler.logger = logger
        self.downloadTaskHandler.logger = logger
    }
    
    /// The shared instance of `DefaultAPIService` (for backward compatibility, uses IntermediateLogger by default).
    public static let shared = DefaultAPIService()

}
