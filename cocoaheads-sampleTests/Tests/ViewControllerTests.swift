//
//  ViewControllerTests.swift
//  cocoaheads-sample
//
//  Copyright © 2017 inlocomedia. All rights reserved.
//

import XCTest

class ViewControllerTests: XCTestCase {
    
    var myName : String?
    var myEmail : String?
    
    override func setUp() {
        super.setUp()
        
        myName = "Andy"
        myEmail = "andy@notanemail.com"
        UserDefaults.standard.set(myName, forKey: "name")
        UserDefaults.standard.set(myEmail, forKey: "email")
    }
    
    func testViewDidLoad_SetsLabels_Always() {
        // Create objects
        let toTest = ViewController()
        
        // Call the method to be tested
        toTest.viewDidLoad()
        
        // Acessing the private properties requires an Obj-C file
        // exposing them for Swift to use.
        XCTAssertEqual(myName, toTest.nameLabel.text)
        XCTAssertEqual(myEmail, toTest.emailLabel.text)
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "email")
        super.tearDown()
    }
}
