//
//  ViewControllerTests.swift
//  cocoaheads-sample
//
//  Created by Marcel de Siqueira Campos Rebouças on 5/23/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

import XCTest

class ViewControllerTests: XCTestCase {
    
    func testViewDidLoad_SetsLabels_Always() {
        let name = "Andy"
        let email = "andy@notanemail.com"
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(email, forKey: "email")
        
        let toTest = ViewController()
        toTest.viewDidLoad()
        
        XCTAssertEqual(name, toTest.nameLabel.text)
        XCTAssertEqual(email, toTest.emailLabel.text)
    }
}
