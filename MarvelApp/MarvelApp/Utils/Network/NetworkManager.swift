//
//  NetworkManager.swift
//  GCalendar
//
//  Created by Navpreet Kailay on 18/09/22.
//

import UIKit
import Combine

public enum NetworkError: Error, Equatable {
    case rechabilityError
    case invalidURL
    case invalidRequestBody(_ localizedDescription: String? = nil)
    case responseError
    case decodingError(_ localizedDescription: String? = nil)
    case unknown
}
public typealias DecodedFuture<T: Decodable> = Future<T, NetworkError>

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    private override init() { }
    private var cancellables = Set<AnyCancellable>()
    
    func request<T: Decodable>(for: T.Type = T.self,
                               endpoint: Endpoint
    ) -> DecodedFuture<T> {
        return Future { [weak self] promise in
            guard let self, var url = URL(string: endpoint.url) else {
                return promise(.failure(.invalidURL))
            }
            // URL ENCODING
            if endpoint.httpMethod == .get {
                var components = URLComponents(
                    url: url,
                    resolvingAgainstBaseURL: false
                )
                var queryItems : [URLQueryItem] = []
                endpoint.body?.forEach({
                    queryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
                })
                components?.queryItems = queryItems
                if let updatedURL = components?.url { url = updatedURL }
            }
            var urlRequest = URLRequest(url: url)
            do {
                let json = try JSONSerialization.data(withJSONObject: endpoint.body as Any)
                if endpoint.httpMethod != .get {
                    urlRequest.httpBody = json
                }
            } catch (let catched) {
                debugPrint("catched request body error: \(catched)")
                return promise(.failure(NetworkError.invalidRequestBody( catched.localizedDescription)))
            }
            // HTTP Method
            urlRequest.httpMethod = endpoint.httpMethod.rawValue
            // Header fields
            if let headers = endpoint.headers {
                headers.forEach({ header in
                    urlRequest.setValue("\(header.value)", forHTTPHeaderField: header.key)
                })
            }
            debugPrint("headers: ", endpoint.headers as Any)
            
            URLSession.shared.dataTaskPublisher(for: urlRequest)
                .tryMap { [weak self] (data, response) in
                    self?.printStringResponse(data: data)
                    debugPrint(response)
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { subsribedError in
                    debugPrint("subscibedError: \(subsribedError)")
                    if case let .failure(error) = subsribedError {
                        switch error {
                        case let decodingError as DecodingError:
                            return promise(.failure(NetworkError.decodingError(decodingError.localizedDescription)))
                        case let networkError as NetworkError:
                            promise(.failure(networkError))
                        default:
                                promise(.failure(NetworkError.unknown))
                        }
                    }
                } receiveValue: { decodedType in
                    promise(.success(decodedType))
                }
                .store(in: &self.cancellables)
        }
    }
    
    
    func request<T: Decodable>(for: T.Type = T.self,
                               endpoint: Endpoint,
                               completion: @escaping (Result<T, Error>) -> Void) {
        
        let session = URLSession.shared
        // URL
        var url = URL(string: endpoint.url)!
        // URL ENCODING
        if endpoint.httpMethod == .get {
            var components = URLComponents(
                url: url,
                resolvingAgainstBaseURL: false
            )
            var queryItems : [URLQueryItem] = []
            if let body = endpoint.body {
                body.forEach({
                    queryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
                })
                components?.queryItems = queryItems
                if let updatedURL = components?.url { url = updatedURL }
            }
            
        }
        debugPrint("endpoint.body: ", endpoint.body as Any)
        debugPrint("url.absoluteURL: \(url)")
        var urlRequest = URLRequest(url: url)
        if let body = endpoint.body {
            do {
                
                let json = try JSONSerialization.data(withJSONObject: body as Any)
                if endpoint.httpMethod != .get  {
                    urlRequest.httpBody = json
                }
                
            } catch (let catched) {
                debugPrint("catched error: \(catched)")
                completion(.failure(catched))
            }
        }
        // HTTP Method
        urlRequest.httpMethod = endpoint.httpMethod.rawValue
        
        // Header fields
        if let headers = endpoint.headers {
            headers.forEach({ header in
                urlRequest.setValue(header.value as? String, forHTTPHeaderField: header.key)
            })
        }
        debugPrint("headers: ", endpoint.headers as Any)
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil
            else { // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            guard (200 ... 299) ~= response.statusCode else { // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                completion(.failure(URLError(.cannotDecodeRawData)))
                return
            }
            // DATA PREVIEW
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                print("jsonResult: ", jsonResult)
                if let jsonString = String(data: data, encoding: String.Encoding.utf8) {
                    print("jsonString: \(jsonString)")
                }
            } catch {
                //Catch Error here...
            }
            
            // DECODING
            do {
                let decoder = JSONDecoder()
                try completion(.success(decoder.decode(T.self, from: data)))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }
        
        task.resume()
    }
    
    // string preview
    func printStringResponse( data: Data) {
        if let jsonString = String(data: data, encoding: String.Encoding.utf8) {
            print("jsonString: \(jsonString)")
        }
    }
    
}
