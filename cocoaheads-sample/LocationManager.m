//
//  LocationViewController.m
//  cocoaheads-sample
//
//  Created by Marcel de Siqueira Campos Rebouças on 5/28/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

#import "LocationManager.h"
#import "ThreadWait.h"

@interface LocationManager () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) CLLocation *lastLocation;
@property (strong, nonatomic) ThreadWait *waiter;

@end

@implementation LocationManager

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.manager = [[CLLocationManager alloc] init];
        [self.manager requestAlwaysAuthorization];
        self.manager.delegate = self;
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations.count > 0) {
        self.lastLocation = locations.firstObject;
        [self.locationListener receivedLocation:self.lastLocation];
    }
    if (self.waiter != nil){
        [self.waiter stopWait];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(nonnull NSError *)error
{
    NSLog(@"FALHOU! MAS QUE DUREZA!");
}

- (void)requestLocationUpdateAsync:(LocationBlock)completionBlock
{
    if (![self isAuthorized]) {
        if (completionBlock) {
            completionBlock(nil);
        }
        return;
    }
    // É feio e eu sei, mas é só um exemplo :P
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // mockable init
        self.waiter = [[ThreadWait alloc] initDefault];
        [self.manager requestLocation];
        [self.waiter wait];
        self.waiter = nil;
        if (completionBlock) {
            completionBlock(self.lastLocation);
        }
    });
}

- (CLLocation *)requestLocationUpdateSync
{
    if (![self isAuthorized]) {
        return nil;
    }
    // mockable init
    self.waiter = [[ThreadWait alloc] initDefault];
    [self.manager requestLocation];
    [self.waiter wait];
    self.waiter = nil;
    return self.lastLocation;
}

// *************************
// ** Write testable code **
// *************************

// Since we deal with location data, we have to know if we are
// authorized to use location updates. However, OCMock has some
// problems with the authorizationStatus method and we can't stub it.
- (NSString *)currentAuthorizationNonTestable
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
            return @"Authorized Always";
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return @"Authorized When In Use";
        default:
            return @"Not Authorized";
    }
}

// So, sometimes, we need to encapsulate a method to allow the stubing.
- (CLAuthorizationStatus)authorizationStatus
{
    return [CLLocationManager authorizationStatus];
}

- (NSString *)currentAuthorizationTestable
{
    CLAuthorizationStatus status = [self authorizationStatus];
    
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
            return @"Authorized Always";
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return @"Authorized When In Use";
        case kCLAuthorizationStatusRestricted:
            return @"Not Authorized";
        default:
            return @"Not Authorized";
    }
}

- (BOOL)isAuthorized
{
    CLAuthorizationStatus status = [self authorizationStatus];
    return status == kCLAuthorizationStatusAuthorizedAlways ||
    status == kCLAuthorizationStatusAuthorizedWhenInUse;
}

@end
