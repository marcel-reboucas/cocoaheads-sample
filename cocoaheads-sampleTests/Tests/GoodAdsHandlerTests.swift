//
//  GoodAdsHandlerTests.swift
//  cocoaheads-sample
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/4/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

import XCTest

class GoodAdsHandlerTests: XCTestCase {
    
    func testAdTypeForTheCurrentHour_6AM_returnsCoffee() {
        // Now the test is deterministic
        let dateProvider = FakeDateProvider(hour: 6)
        let handler = GoodAdsHandler(dateProvider: dateProvider)
        let adType = handler.currentAdType(date: dateProvider.getDate())
        
        XCTAssertEqual(adType, AdType.Coffee)
    }
    
    func testAdTypeForTheCurrentHour_1PM_returnsRestaurant() {
        // Now the test is deterministic
        let dateProvider = FakeDateProvider(hour: 13)
        let handler = GoodAdsHandler(dateProvider: dateProvider)
        let adType = handler.currentAdType(date: dateProvider.getDate())
        
        XCTAssertEqual(adType, AdType.Restaurant)
    }
    
    func testLastAdShowedSet_1PM() {
        
        let dateProvider = FakeDateProvider(hour: 13)
        let handler = GoodAdsHandler(dateProvider: dateProvider)
        
        handler.showAd(presentFunction: nil)
        
        XCTAssertEqual(dateProvider.getDate(), handler.lastAdShowedTime)
    }
    
    func testLastAdShowedSet_1AM() {
        
        let dateProvider = FakeDateProvider(hour: 1)
        let handler = GoodAdsHandler(dateProvider: dateProvider)
        
        handler.showAd(presentFunction: nil)
        
        XCTAssertNil(handler.lastAdShowedTime)
    }
    
    func testShowAd_callPresent() {
    
        var presented = false
        let presentFunction = { (adType : AdType) -> Void in
            presented = true
        }
        
        let dateProvider = FakeDateProvider(hour: 10)
        let handler = GoodAdsHandler(dateProvider: dateProvider)
        
        //handler.showAd(presentFunction: AdPresenter.sharedInstance.presentAd)
        handler.showAd(presentFunction: presentFunction)
        
        XCTAssertTrue(presented)
    }
    
    func testShowAd_rejectPresent() {
        
        var presented = false
        let presentFunction = { (adType : AdType) -> Void in
            presented = true
        }
        
        let dateProvider = FakeDateProvider(hour: 1)
        let handler = GoodAdsHandler(dateProvider: dateProvider)
        
        handler.showAd(presentFunction: presentFunction)
        
        XCTAssertFalse(presented)
    }

}
