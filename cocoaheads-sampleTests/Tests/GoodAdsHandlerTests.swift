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
    
    func testShowAd_verifyCall() {
    
        var presentedAd : Ad?
        let presentFunction = { (ad : Ad) -> Void in
            presentedAd = ad
        }
        
        let dateProvider = FakeDateProvider(hour: 10)
        let handler = GoodAdsHandler(dateProvider: dateProvider)
        
        //handler.showAd(presentFunction: AdPresenter.sharedInstance.presentAd)
        handler.showAd(presentFunction: presentFunction)
        
        let expectedAd = handler.currentAdType(date: dateProvider.getDate())
        XCTAssertEqual(expectedAd, presentedAd?.adType)
    }
    
    func testShowAd_rejectCall() {
        
        var presentedAd : Ad?
        let presentFunction = { (ad : Ad) -> Void in
            presentedAd = ad
        }
        
        let dateProvider = FakeDateProvider(hour: 1)
        let handler = GoodAdsHandler(dateProvider: dateProvider)
        
        handler.showAd(presentFunction: presentFunction)
        
        XCTAssertNil(presentedAd)
    }

}
