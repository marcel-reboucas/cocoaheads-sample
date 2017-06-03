//
//  Utils.h
//  cocoaheads-sample
//
//  Created by Rafael Gouveia on 5/29/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "KIF.h"

#define WAIT_FOR_AUTHORIZATION \
CLAuthorizationStatus auth = [CLLocationManager authorizationStatus]; \
CLLocationManager *authManager = [[CLLocationManager alloc] init];    \
while (auth == kCLAuthorizationStatusNotDetermined) {                 \
    NSLog(@"Please allow location access");                           \
    [authManager requestAlwaysAuthorization];                         \
    [Utils unblockingMainThreadSleep:1 forTestClass:self];            \
    [tester acknowledgeSystemAlert];                                  \
    auth = [CLLocationManager authorizationStatus];                   \
}

typedef void (^ILMRunBlock)(void);

@interface Utils : NSObject

+ (void)backgroundTest:(ILMRunBlock)block;
+ (void)fullfillExpectationOn:(XCTestExpectation *)expectation;
+ (void)unblockingMainThreadSleep:(NSTimeInterval)time forTestClass:(XCTestCase *)testCase;

@end
