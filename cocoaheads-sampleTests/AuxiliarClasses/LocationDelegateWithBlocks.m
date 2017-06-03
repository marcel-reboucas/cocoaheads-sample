//
//  LocationDelegateWithBlocks.m
//  cocoaheads-sample
//
//  Created by Marcel de Siqueira Campos Rebouças on 6/3/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

#import "LocationDelegateWithBlocks.h"

@implementation LocationDelegateWithBlocks

- (void)receivedLocation:(CLLocation *)location error:(NSError *)error
{
    if (self.receivedLocationBlock) {
        self.receivedLocationBlock(location, error);
    }
}

@end
