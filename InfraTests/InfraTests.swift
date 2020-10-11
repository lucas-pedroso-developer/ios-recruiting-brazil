import XCTest
import Infra
import Alamofire

class InfraTests: XCTestCase {

    let API_KEY = "60471ecf5f288a61c69c6592c9d9e1cf"
    
    func test_get_should_make_request_with_valid_url_and_method() {
        let url = makeURL()
        testRequestFor(url: url) { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("GET", request.httpMethod)
        }
    }
    
    func test_get_should_complete_with_error_on_invalid_cases() {
        expectResult(.failure(.noConnectivity), when: (data: makeInvalidData(), response: makeHttpResponse(), error: makeError()))
        expectResult(.failure(.noConnectivity), when: (data: makeInvalidData(), response: nil, error: makeError()))
        expectResult(.failure(.noConnectivity), when: (data: makeValidData(), response: nil, error: nil))
        expectResult(.failure(.noConnectivity), when: (data: nil, response: makeHttpResponse(), error: makeError()))
        expectResult(.failure(.noConnectivity), when: (data: nil, response: makeHttpResponse(), error: nil))
        expectResult(.failure(.noConnectivity), when: (data: nil, response: nil, error: nil))
    }
    
    func test_get_should_complete_with_data_when_request_completes_with_200() {
        expectResult(.success(makeValidData()), when: (data: makeValidData(), response: makeHttpResponse(), error: nil))
    }
    
    func test_get_should_complete_with_no_data_when_request_completes_with_204() {
        expectResult(.success(nil), when: (data: nil, response: makeHttpResponse(statusCode: 204), error: nil))
        expectResult(.success(nil), when: (data: makeEmptyData(), response: makeHttpResponse(statusCode: 204), error: nil))
        expectResult(.success(nil), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 204), error: nil))
    }
    
    func test_get_should_complete_with_error_when_request_completes_with_non_200() {
        expectResult(.failure(.badRequest), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 400), error: nil))
        expectResult(.failure(.badRequest), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 450), error: nil))
        expectResult(.failure(.badRequest), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 499), error: nil))
        
        expectResult(.failure(.serverError), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 500), error: nil))
        expectResult(.failure(.serverError), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 550), error: nil))
        expectResult(.failure(.serverError), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 599), error: nil))
        
        expectResult(.failure(.unauthorized), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 401), error: nil))
        expectResult(.failure(.forbidden), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 403), error: nil))
        
        expectResult(.failure(.noConnectivity), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 300), error: nil))
        expectResult(.failure(.noConnectivity), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 100), error: nil))
    }
    

}

extension InfraTests {
    func makeSut() -> HttpService {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = HttpService(session: session)
        return sut
    }
    
    func testRequestFor(url: URL, action: @escaping (URLRequest) -> Void) {
        let sut = makeSut()
        let exp = expectation(description: "waiting")
        sut.get(url: url)  { _ in  exp.fulfill() }
        var request: URLRequest?
        UrlProtocolStub.observeRequest { request = $0 }
        wait(for: [exp], timeout: 2)
        action(request!)
    }
        
    func makeURL() -> URL {
        return URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=" + API_KEY)!
    }
    
    func expectResult(_ expectedResult: Result<Data?, HttpError>, when stub: (data: Data?, response: HTTPURLResponse?, error: Error?), file: StaticString = #file, line: UInt = #line) {
        let sut = makeSut()
        UrlProtocolStub.simulate(data: stub.data, response: stub.response, error: stub.error)
        let exp = expectation(description: "waiting")
        sut.get(url: makeURL()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError, file: file, line: line)
                case (.success(let expectedData), .success(let receivedData)): XCTAssertEqual(expectedData, receivedData, file: file, line: line)
                default: XCTFail("Expected \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }
}
