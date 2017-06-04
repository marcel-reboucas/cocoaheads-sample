//
//  BadAdsHandlerTests.swift
//  cocoaheads-sample
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/4/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

import XCTest

class BadAdsHandlerTests: XCTestCase {
    
    func testAdTypeForTheCurrentHour_6AM_returnsCoffee() {
        // Mock the Date class
        // If not mocked, the test is non-deterministic
        let adType = BadAdsHandler.currentAdType()
        XCTAssertEqual(adType, AdType.Coffee)
        
        // Remember to unmock Date
    }
    
    func testLastAdShowedSet_6AM() {
        // Mock the Date class and pass the mocked date
        let mockedDate = Date()
        
        // If not mocked, the test is non-deterministic
        let handler = BadAdsHandler()
            
        handler.showAd()
        
        // Assert that the time is right
        XCTAssertEqual(handler.lastAdShowedTime, mockedDate)
    }
    
    func testShowAd_6AM_showsAd() {
    
        // Mock the date class
        // If not mocked, the test is non-deterministic
        BadAdsHandler().showAd()
        
        // Mock the AdPresenter class, which is a singleton
        // Singletons can be altered anywhere, possibly making the test fail
        // Verify if the method was called, or if the Ad appeared
    }

}
