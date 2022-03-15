//
//  APIManager.swift
//  BookSearchDemo
//
//  Created by Ejaz on 14/03/22.
//

import UIKit

class ApiManager {
    
    static let shared = ApiManager()
    
    /// API call to server & fetch server data
    /// - Parameter request: URLRequest to connect appropriate server and fetch server data
    /// - Parameter completion: Response block to handle API response
    func makeRequest<T:Codable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> ()) {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, apiError in
            
            guard let data = data,
                  apiError == nil else {
                      DispatchQueue.main.async {
                          completion(.failure(apiError!))
                      }
                      return
                  }
            do {
                print(String(data: try JSONSerialization.data(withJSONObject: JSONSerialization.jsonObject(with: data, options: []), options: .prettyPrinted), encoding: .utf8)!)
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(responseObject))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
        
    }
    
}

