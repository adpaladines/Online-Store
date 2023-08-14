//
//  TheSoundsStoreTests.swift
//  TheSoundsStoreTests
//
//  Created by Andres D. Paladines on 7/17/23.
//

import XCTest
@testable import TheSoundsStore

final class TheSoundsStoreTests: XCTestCase {

    var viewModel: ProductsListViewModel!

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testDigimonList_WhenWeExpectCorrectData() async throws {
        viewModel = nil
        let nm = FakeNetworkManager()
    
        viewModel = await ProductsListViewModel(networkManager: nm)
        
        await viewModel.getDevicesResponseList(urlString: ApiManager.fake(.fullList))
        let products = await viewModel.productsResponseList["default"]?.products
        XCTAssertNotNil(products)
         
        
        XCTAssertEqual(products!.count, 3)
        
        let error = await viewModel.customErrorList["default"]
        XCTAssertNil(error)
        
        let firstProd = products!.first
        XCTAssertEqual(firstProd?.title, "Samsung Galaxy Book")
        XCTAssertEqual(firstProd?.id, 7)
        XCTAssertEqual(firstProd?.category, "laptops")

    }
    
    func testDigimonList_WhenWeHaveInvalidURL() async throws {
        viewModel = nil
        let nm = FakeNetworkManager()
        viewModel = await ProductsListViewModel(networkManager: nm)
        
        await viewModel.getDevicesResponseList(urlString: "")
        let products = await viewModel.productsResponseList["default"]?.products
        XCTAssertNil(products)
        
        let error = await viewModel.customErrorList["default"]
        XCTAssertEqual(error, NetworkError.invalidUrlError)
    }
    
    func testDigimonList_WhenWeExpectNoData() async throws {
        viewModel = nil
        let nm = FakeNetworkManager()
        viewModel = await ProductsListViewModel(networkManager: nm)
        
        await viewModel.getDevicesResponseList(urlString: ApiManager.fake(.empty))
        let products = await viewModel.productsResponseList["default"]?.products
        XCTAssertEqual(products?.count, 0)
        
        let error = await viewModel.customErrorList["default"]
        XCTAssertNil(error)

    }

    func testDigimonList_WhenWeExpectParsingError() async throws {
        viewModel = nil
        let nm = FakeNetworkManager()
        viewModel = await ProductsListViewModel(networkManager: nm)
        
        await viewModel.getDevicesResponseList(urlString: ApiManager.fake(.wrongData))
        let products = await viewModel.productsResponseList["default"]?.products
        XCTAssertNil(products)
        
        let error = await viewModel.customErrorList["default"]
        XCTAssertEqual(error, NetworkError.parsingError)
    }
    
    func testDigimonList_WhenWeExpectResponseError() async throws {
        viewModel = nil
        let nm = NetworkManager()
        viewModel = await ProductsListViewModel(networkManager: nm)
        
        await viewModel.getDevicesResponseList(urlString: "https://dummyjson.com/ocwnc/lskfhalskdf")
        
        let products = await viewModel.productsResponseList["default"]?.products
        XCTAssertNil(products)
        
        let error = await viewModel.customErrorList["default"]
        XCTAssertEqual(error, NetworkError.responseError)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
