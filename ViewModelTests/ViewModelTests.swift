import XCTest
import Foundation
import Model
import Infra
@testable import ViewModel

class ViewModelTests: XCTestCase {

    func test_get_should_call_viewModel_with_correct_url() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=60471ecf5f288a61c69c6592c9d9e1cf")!
        let sut = makeSut()
        sut.getMovies(url: url) { _ in }
        XCTAssertEqual(sut.urls, [url])
    }
    
    func test_add_should_complete_with_account_if_client_completes_with_error() {
        let sut = makeSut()
        expect(sut, completeWith: .failure(.noConnectivity), when: {
            sut.completeWithError(.noConnectivity)
        })
    }
            
    func makeMovie() -> MoviesMain {
        return MoviesMain(page: 0, total_results: 0, total_pages: 0, results: [])
    }
        
    func makeHttpResponse(statusCode: Int = 200) -> HTTPURLResponse {
       return HTTPURLResponse(url: makeURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
    
    func test_add_should_complete_with_account_if_client_completes_with_valid_data() {
        let sut = makeSut()
        expect(sut, completeWith: .success(makeMovie()) , when: {
            sut.completeWithData(makeMovie())
        })
    }
}

extension ViewModelTests {
    func makeSut() -> MoviesMainViewModelSpy {
        let sut = MoviesMainViewModelSpy()
        sut.resultsArray = []
        return sut
    }
            
    func makeURL() -> URL {
        return URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=60471ecf5f288a61c69c6592c9d9e1cf")!
    }
    
    func expect(_ sut: MoviesMainViewModelSpy, completeWith expectedResult: Result<MoviesMain, HttpError>, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "waiting")
        
        sut.getMovies(url: makeURL()) { receivedResult in
            switch (expectedResult, receivedResult) {
                case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError, file: file, line: line)
                case (.success(let expectedAccount), .success(let receivedAccount)): XCTAssertEqual(expectedAccount, receivedAccount)
                default: XCTFail("Expected \(expectedResult) received \(receivedResult) instead")
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)
    }
}
