//
//  LocationViewController.h
//  cocoaheads-sample
//
//  Created by Marcel de Siqueira Campos Rebouças on 5/28/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^LocationBlock)(CLLocation *);

@protocol LocationDelegate <NSObject>

- (void)receivedLocation:(CLLocation *)location error:(NSError *)error;

@end

@interface LocationManager : NSObject

@property (nonatomic, weak) NSObject<LocationDelegate> *delegate;
- (CLLocation *)requestLocationUpdateSync;
- (void)requestLocationUpdateAsync:(LocationBlock)completionBlock;
- (void)requestLocationUpdateAsyncDelegate;

@end
