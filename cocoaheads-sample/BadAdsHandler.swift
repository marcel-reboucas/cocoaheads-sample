//
//  AdsHandler.swift
//  cocoaheads-sample
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/4/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

import Foundation
import UIKit

public class BadAdsHandler {
    
    var lastAdShowedTime : Date?
    
    func currentAdType() -> AdType {
        
        let now = Date()
        let hour = Calendar.current.component(.hour, from: now)
        
        if 4...9 ~= hour {
            return AdType.Coffee
        } else if 10...14 ~= hour {
            return AdType.Restaurant
        } else if 15...21 ~= hour {
            return AdType.TransportApp
        } else if 22...23 ~= hour {
            return AdType.Bed
        }
        
        return AdType.Unknown
    }
    
    func showAd() {
        
        let adType = currentAdType()
        
        if (adType != AdType.Unknown) {
            lastAdShowedTime = Date()
            let ad = Ad(adType: adType)
            AdPresenter.sharedInstance.presentAd(ad: ad)
        } else {
            print("No ad available.")
        }
    }
}
