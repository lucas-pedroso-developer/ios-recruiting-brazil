import Foundation

public final class HttpService: HttpGetProtocol {
        
    private var session = URLSession.shared
    public static let shared = HttpService()
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
            
    public func get(url: URL, completion: @escaping (Result<Data?, HttpError>) -> Void) {
        
        let request = URLRequest(url: url)
                
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else { return
                completion(.failure(.noConnectivity)) }
                                                           
            guard error == nil else {
                completion(.failure(.noConnectivity))
                return
            }

            guard let data = data else {
                completion(.success(nil))
                return
            }
                        
            switch httpResponse.statusCode {
            case 204:
                completion(.success(nil))
            case 200...299:
                completion(.success(data))
            case 401:
                completion(.failure(.unauthorized))
            case 403:
                completion(.failure(.forbidden))
            case 400...499:
                completion(.failure(.badRequest))
            case 500...599:
                completion(.failure(.serverError))
            default:
                completion(.failure(.noConnectivity))
            }
        })
        task.resume()
    }
}
