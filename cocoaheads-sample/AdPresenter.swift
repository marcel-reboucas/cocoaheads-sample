//
//  AdPresenter.swift
//  cocoaheads-sample
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/4/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

import UIKit

public class AdPresenter: NSObject {

    static let sharedInstance = AdPresenter()
    
    func presentAd(ad : Ad) {
        print("Presenting ad of type \(ad.adType).")
    }
}
