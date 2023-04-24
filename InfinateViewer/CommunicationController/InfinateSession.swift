//
//  InfinateSession.swift
//  InfinateViewer
//
//  Created by Abishek Thangaraj on 24/04/23.
//

import Foundation

typealias InfinateResponse = (Data, URLResponse)

struct InfinateSession{
    
    let queue = DispatchQueue(label: Bundle.main.bundleIdentifier ?? "sample.app", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: .global(qos: .userInitiated))
    
    public static let operationQueue: OperationQueue = {
        let operation = OperationQueue()
        operation.qualityOfService = .background
        operation.maxConcurrentOperationCount = 1
        operation.name = Bundle.main.bundleIdentifier
        return operation
    }()
    
    public static let configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.ephemeral
        // timeoutIntervalForRequest is 60 for reducing the request time out error while hitting the api.
        configuration.timeoutIntervalForRequest = 60
        return configuration
    }()
    
    public let customSession: URLSession = {
        let session = URLSession(configuration: Self.configuration, delegate: nil, delegateQueue: Self.operationQueue)
        return session
    }()
    
    static let shared = InfinateSession()
    
    func apiCall<T: Codable>(_ urlHandler: URLHandler, httpMethod: HTTPMethod = .GET, data: T.Type, completionHandler: @escaping @Sendable (T?, String?) -> Void){
        queue.async {
            let url = URL(string: urlHandler.rawValue)
            var request = URLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
            request.httpMethod = httpMethod.rawValue
            let task = customSession.dataTask(with: request) { data, response, error in
                
                if let error = error{
                    completionHandler(nil, error.localizedDescription)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    completionHandler(nil, "Error on response")
                    return
                }
                UserDefaults.setAPILoaded(for: httpResponse.url?.absoluteString ?? "")
                guard let dataValue = data else {
                    completionHandler(nil, "Error on Data")
                    return
                }
                
                do {
                    let value = try JSONDecoder().decode(T.self, from: dataValue)
                    completionHandler(value, nil)
                } catch let error {
                    completionHandler(nil, error.localizedDescription)
                }
                
            }
            task.resume()
        }
    }
    
}
