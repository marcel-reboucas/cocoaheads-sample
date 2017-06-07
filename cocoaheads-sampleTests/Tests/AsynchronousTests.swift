//
//  AsynchronousTest.swift
//  cocoaheads-sample
//
//  Created by Marcel de Siqueira Campos Rebouças on 5/23/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

import XCTest

class AsynchronousTests : XCTestCase {
    
    var directory : String = ""
    var fileName : String = ""
    var path : String = ""
    
    override func setUp() {
        super.setUp()
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        self.directory = paths[0]
        self.fileName = "textFile.txt"
        self.path = "\(self.directory)/\(self.fileName)"
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(atPath: self.path)
        super.tearDown()
    }
    
    // This test ends before calling the completion handler
    // This can even make the tearDown to be called before the completion, 
    // making the next test fail
    func testSaveDocument_withoutExpectation() {
        let url = NSURL.fileURL(withPath: path)
        let document = UIManagedDocument(fileURL: url)
        var saveSuccess = false
        
        // Call the asynchronous method with completion handler
        document.save(to: url, for: UIDocumentSaveOperation.forCreating, completionHandler: { success in
            saveSuccess = success
        })

        XCTAssertTrue(saveSuccess)
    }

    func testSaveDocument() {
        let url = NSURL.fileURL(withPath: path)
        let document = UIManagedDocument(fileURL: url)
        var saveSuccess = false
        
        let readyExpectation = expectation(description: "ready")
        
        // Call the asynchronous method with completion handler
        document.save(to: url, for: UIDocumentSaveOperation.forCreating, completionHandler: { success in
            
            saveSuccess = success
            readyExpectation.fulfill()
        })
        
        // Loop until the expectation is fulfilled
        waitForExpectations(timeout: 5, handler: { error in
            XCTAssertNil(error, "Error")
        })
        
        XCTAssertTrue(saveSuccess)
    }
}



