//
//  LocationDelegateWithBlocks.h
//  cocoaheads-sample
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/3/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationManager.h"

@interface LocationDelegateWithBlocks : NSObject <LocationDelegate>

@property (nonatomic, assign) void (^receivedLocationBlock)(CLLocation *, NSError *);

@end
