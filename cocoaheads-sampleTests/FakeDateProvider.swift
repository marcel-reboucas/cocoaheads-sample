//
//  FakeDateProvider.swift
//  cocoaheads-sample
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/4/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

import Foundation

class FakeDateProvider : DateProvider {
    
    let date : Date
    
    init () {
        self.date = Date()
    }
    
    init (date : Date) {
        self.date = date
    }
    
    init (hour : Int) {
        var components = DateComponents()
        components.hour = hour
        self.date = Calendar.current.date(from: components)!
    }
    
    func getDate() -> Date {
        return date
    }
}
