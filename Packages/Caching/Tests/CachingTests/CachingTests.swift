import XCTest
import MovieModels
@testable import Caching

final class CachingTests: XCTestCase {
    
    var cachingHandler: CachingHandler!
    let testFileName = "test_genres"
    
    override func setUp() {
        super.setUp()
        cachingHandler = CachingHandler()
    }
    
    override func tearDown() {
        // Remove test file after test
        try? cachingHandler.removeFile(fileName: testFileName)
        cachingHandler = nil
        super.tearDown()
    }
    
    func testSaveAndLoadGenreResponse() {
        let genres = GenreResponse(genres: [
            Genre(id: 1, name: "Action"),
            Genre(id: 2, name: "Comedy")
        ])
        
        cachingHandler.saveToFile(genres, fileName: testFileName)
        let loaded: Result<GenreResponse, CError> = cachingHandler.loadFromFile(GenreResponse.self, fileName: testFileName)
        switch loaded {
        case .success(let successResult):
            XCTAssertEqual(genres, successResult)
        case .failure(let failure):
            XCTFail("Unexpected error: \(failure)")
        }
    }

    func testLoadFileThrowsWhenFileMissing() {
        let loaded: Result<GenreResponse, CError> = cachingHandler.loadFromFile(GenreResponse.self, fileName: "non_existent_file")
        switch loaded {
        case .success(_):
            XCTFail("Unexpected error")
        case .failure(let failure):
            XCTAssertEqual(failure, .fileNotFound)
        }
    }
}
