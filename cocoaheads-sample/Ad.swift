//
//  Ad.swift
//  cocoaheads-sample
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/4/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

import Foundation

public class Ad : NSObject {

    let adType : AdType
    
    init(adType : AdType) {
        self.adType = adType
    }
}
