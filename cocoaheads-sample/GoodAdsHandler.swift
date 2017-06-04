//
//  GoodAdsHandler.swift
//  cocoaheads-sample
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/4/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

import Foundation

public class GoodAdsHandler {
    
    var lastAdShowedTime : Date?
    
    let dateProvider : DateProvider
    
    init (dateProvider : DateProvider) {
        self.dateProvider = dateProvider
    }
    
    func currentAdType(date : Date) -> AdType {
        let hour = Calendar.current.component(.hour, from: date)
        
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
    
    func showAd(presentFunction : ((AdType) -> ())?) {
        
        let date = dateProvider.getDate()
        let adType = currentAdType(date: date)
        
        if (adType != AdType.Unknown) {
            lastAdShowedTime = date
            presentFunction?(adType)
        } else {
            print("No ad available.")
        }
    }
    
    func fetchAd() {
        let date = dateProvider.getDate()
        let adType = currentAdType(date: date)
    }
}
