import Foundation

public protocol HttpGetProtocol {
    func get(url: URL, completion: @escaping (Result<Data?, HttpError>) -> Void)
}
