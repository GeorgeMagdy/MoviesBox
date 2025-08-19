import XCTest
import Networking
import Combine
import MovieModels
import Caching
import Utilities
@testable import MovieDetailsView

final class MovieDetailsViewTests: XCTestCase {
    var sut: MovieDetailsViewModel!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        sut = MovieDetailsViewModel(networkManager: NetworkingManager(), cachingManager: CachingHandler(), movieId: 19995)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testFetchMovieDetails() {
        let expectation = XCTestExpectation(description: "FetchRequest")
        try? CachingHandler().removeFile(fileName: Constants.StorageKeys.movieDetails)
        sut.loadMovieDetails()
        sut.$movieDetail
            .dropFirst()
            .sink { movieDetail in
                XCTAssertNotNil(movieDetail)
                expectation.fulfill()
            }.store(in: &cancellables)
        wait(for: [expectation], timeout: 2)
    }
}
