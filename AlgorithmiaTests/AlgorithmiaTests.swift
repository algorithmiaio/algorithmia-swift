//
//  AlgorithmiaTests.swift
//  AlgorithmiaTests
//
//  Created by Erik Ilyin on 11/9/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import XCTest
@testable import Algorithmia

class AlgorithmiaTests: XCTestCase {
    var client:AlgorithmiaClient?
    override func setUp() {
        super.setUp()
        let apiKey = ProcessInfo.processInfo.environment["ALGORITHMIA_API_KEY"] ?? ALGORITHMIA_API_KEY// Your API Key
        client = Algorithmia.client(simpleKey: apiKey)
        
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testTextAlgorithm() {

        let expect = expectation(description: "Text algorithm test")
        _ = client?.algo(algoUri: "algo://demo/Hello/0.1.1").pipe(text: "erik", completion: { resp, error in
            if (error == nil) {
                print(resp.getText())
            }
            else {
                print(error)
            }
            expect.fulfill()
        })
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("WaitForExectationsWithTimeout error: \(error)")
            }
        }
    }
    
    func testJsonAlgorithm() {

        let expect = expectation(description: "Binary algorithm test")
        _ = client?.algo(algoUri: "algo://WebPredict/ListAnagrams/0.1.0").pipe(rawJson: "[\"thing\", \"night\", \"other\"]") { (resp, error) in
            if (error == nil) {
                print(resp.getJson())
                expect.fulfill()
            }
            else {
                print(error)
                XCTFail("Algorithmia Json Test error: \(error)")
            }
        }
        waitForExpectations(timeout: 10.0) { error in
            if let error = error {
                XCTFail("WaitForExectationsWithTimeout error: \(error)")
            }
        }
    }
    
    func testBinaryAlgorithm() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expect = expectation(description: "Binary algorithm test")
        let data = "Testing echo".data(using: .utf8)
        _ = client?.algo(algoUri: "algo://util/Echo/0.2.1").pipe(data: data) { (resp, error) in
            if let error=error {
                XCTFail("Algorithmia Binary Test error: \(error)")
            } else {
                let str = String(data: resp.getData(), encoding: .utf8)
                print("Data:",str)
                print("Duration:",resp.getMetadata().duration)
                expect.fulfill()
            }
            
        }
        waitForExpectations(timeout: 10.0) { error in
            if let error = error {
                XCTFail("WaitForExectationsWithTimeout error: \(error)")
            }
        }
    }
    
    func testTimeoutOption() {
        let expect = expectation(description: "Query option algorithm test")
        let data = "Testing echo".data(using: .utf8)
        _ = client?.algo(algoUri: "algo://util/Echo/0.2.1").set(timeout: 10).pipe(data: data) { (resp, error) in
            if let error=error {
                XCTFail("Algorithmia Query option Test error: \(error)")
            } else {
                let str = String(data: resp.getData(), encoding: .utf8)
                print("Data:",str)
                print("Duration:",resp.getMetadata().duration)
                expect.fulfill()
            }
            
        }
        waitForExpectations(timeout: 10.0) { error in
            if let error = error {
                XCTFail("WaitForExectationsWithTimeout error: \(error)")
            }
        }
    }
    
    func testProcessFailed() {
        let expect = expectation(description: "Test Process Failed")
        let data = "Testing echo".data(using: .utf8)
        _ = client?.algo(algoUri: "algo://test/random").pipe(data: data) { (resp, error) in
            if let error = error as? AlgoError {
                switch error {
                case .ProcessError:
                    print("Message",error)
                    expect.fulfill()
                    break;
                default:
                    break;
                }
                
            } else {
                XCTFail("Algorithmia Process Failed error: \(error)")
            }
            
        }
        waitForExpectations(timeout: 10.0) { error in
            if let error = error {
                XCTFail("WaitForExectationsWithTimeout error: \(error)")
            }
        }
    }
    
    func testFilePut() {
        let expect = expectation(description: "Test put File")
        let file = client?.file("data://.my/test/test.txt")
        file?.put(string: "test text", completion: { (error) in
            if let error=error {
                XCTFail("Algorithmia File put Test error: \(error)")
            } else {
                expect.fulfill()
            }
        })
        
        waitForExpectations(timeout: 10.0) { error in
            if let error = error {
                XCTFail("WaitForExectationsWithTimeout error: \(error)")
            }
        }
    }
    
    func testFileExits() {
        let expect = expectation(description: "Test File exist")
        let file = client?.file("data://.my/test/test.txt")
        file?.exists(completion: { (isExist, error) in
            if error != nil {
                XCTFail("Algorithmia File Exist function Error: \(error)")
            }
            else {
                if isExist {
                    print("File exists")
                }
            }
            expect.fulfill()
        })
        waitForExpectations(timeout: 10.0) { error in
            if let error = error {
                XCTFail("WaitForExectationsWithTimeout error: \(error)")
            }
        }
    }
    
    func testFileGet() {
        let expect = expectation(description: "Test File getString")
        let file = client?.file("data://.my/test/test.txt")
        file?.getString(completion: { (text, error) in
            if let _ = text {
                print("File content:",text)
                expect.fulfill()
            }
            else {
                XCTFail("Algorithmia File Not found: \(error)")
            }
        })
        
        waitForExpectations(timeout: 10.0) { error in
            if let error = error {
                XCTFail("WaitForExectationsWithTimeout error: \(error)")
            }
        }
    }
    
    func testDirectoryListing() {
        let expect = expectation(description: "Test Directory listing")
        let dir = client?.dir("data://.my/test/")
        var count = 0;
        _ = dir?.forEach(file: { (file) in
                print(file?.path)
                count = count + 1;

            }, completion: { (error) in
                if let error = error {
                    XCTFail("Algorithmia Listing Error: \(error)")
                    expect.fulfill()
                }
                 else if(count == 1) {
                    expect.fulfill()
                }
        })
        waitForExpectations(timeout: 10.0) { error in
            if let error = error {
                XCTFail("WaitForExectationsWithTimeout error: \(error)")
            }
        }
    }
    
    func testDirectoryCreate() {
        let expect = expectation(description: "Test Directory Create")
        let dir = client?.dir("data://.my/one")
        dir?.create { error in
            if error != nil {
                XCTFail("Algorithmia Create folder error: \(error)")
                
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 10.0) { error in
            if let error = error {
                XCTFail("WaitForExectationsWithTimeout error: \(error)")
            }
        }

    }
    
    func testDirectoryUpdate() {
        let expect = expectation(description: "Test Directory Create")
        let dir = client?.dir("data://.my/one")
        dir?.update(readACL:.PUBLIC) { error in
            if error != nil {
                XCTFail("Algorithmia Update folder error: \(error)")
                
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 10.0) { error in
            if let error = error {
                XCTFail("WaitForExectationsWithTimeout error: \(error)")
            }
        }
        
    }
    
    func testDirectoryDelete() {
        let expect = expectation(description: "Test Directory Delete")
        let dir = client?.dir("data://.my/test/one")
        dir?.delete(force: false, completion: { (result, error) in
            if error != nil {
                XCTFail("Algorithmia Delete File Error: \(error)")
                expect.fulfill()
            }
            else {
                print(result?.deletedCount)
                expect.fulfill()
            }
        })
        waitForExpectations(timeout: 10.0) { error in
            if let error = error {
                XCTFail("WaitForExectationsWithTimeout error: \(error)")
            }
        }
    }
}
