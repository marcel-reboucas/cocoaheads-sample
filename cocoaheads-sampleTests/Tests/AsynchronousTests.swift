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
    
    // *************************
    // ** XCTestExpectation   **
    // *************************
    func testSaveDocument() {
        let url = NSURL.fileURL(withPath: path)
        let document = UIManagedDocument(fileURL: url)
        
        // Declare our expectation
        let readyExpectation = expectation(description: "ready")
        
        // Call the asynchronous method with completion handler
        document.save(to: url, for: UIDocumentSaveOperation.forCreating, completionHandler: { success in
            // Perform our tests...
            XCTAssertTrue(success, "saveToURL failed")
            
            // And fulfill the expectation...
            readyExpectation.fulfill()
        })
        
        // Loop until the expectation is fulfilled
        waitForExpectations(timeout: 5, handler: { error in
            XCTAssertNil(error, "Error")
        })
    }
}



