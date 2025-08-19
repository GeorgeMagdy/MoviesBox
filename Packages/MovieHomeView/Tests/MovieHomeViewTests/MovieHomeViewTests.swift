import XCTest
import Networking
import Combine
import MovieModels
import Caching
import Utilities
@testable import MovieHomeView

final class MovieHomeViewTests: XCTestCase {
    var sut: MovieListViewModel!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        try? CachingHandler().removeFile(fileName: Constants.StorageKeys.genresList)
        sut = MovieListViewModel(networkManager:NetworkingManager(), cachingManager: CachingHandler())
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testFetchMovieGenreList() {
        let expectation = XCTestExpectation(description: "FetchRequest")
        sut.$genres
            .dropFirst()
            .sink { genres in
                XCTAssertNotNil(genres)
                expectation.fulfill()
            }.store(in: &cancellables)
        wait(for: [expectation], timeout: 2)
    }
    
    func testFetchMovieGenreMoviesList() {
        let expectation = XCTestExpectation(description: "FetchRequest")
        sut.selectedGenre = 28
        sut.$genreMovies
            .dropFirst()
            .sink { genreMovies in
                XCTAssertNotNil(genreMovies)
                XCTAssertEqual(self.sut.movieGenreList[28]?.totalPages, 2252)
                expectation.fulfill()
            }.store(in: &cancellables)
        wait(for: [expectation], timeout: 2)
    }
}
