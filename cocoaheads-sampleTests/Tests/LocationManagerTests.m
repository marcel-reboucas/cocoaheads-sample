//
//  LocationViewControllerTests.m
//  cocoaheads-sample
//
//  Created by Marcel de Siqueira Campos Rebouças on 5/28/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LocationManager.h"
#import "ThreadWait.h"
#import "OCMock.h"
#import "KIF.h"
#import "Utils.h"
#import "NameConflictExample.h"

#define WAIT_FOR_AUTHORIZATION \
CLAuthorizationStatus auth = [CLLocationManager authorizationStatus];\
CLLocationManager *authManager = [[CLLocationManager alloc] init];    \
while (auth == kCLAuthorizationStatusNotDetermined) {                 \
    NSLog(@"Please allow location access");                           \
    [authManager requestAlwaysAuthorization];                         \
    [Utils unblockingMainThreadSleep:1 forTestClass:self];            \
    [tester acknowledgeSystemAlert];                                  \
    auth = [CLLocationManager authorizationStatus];                   \
}

// Private Category Trick to expose private properties for testing
@interface LocationManager (Test)

@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) CLLocation *lastLocation;
@property (strong, nonatomic) ThreadWait *waiter;
- (CLAuthorizationStatus)authorizationStatus;
- (NSString *)currentAuthorizationNonTestable;
- (NSString *)currentAuthorizationTestable;
-(BOOL)isAuthorized;

@end

@interface LocationManagerTests : XCTestCase

@property (nonatomic, strong) LocationManager *manager;
@property (nonatomic, strong) LocationManager *managerMock;
@property (nonatomic, strong) id cllmanager;

@end

@implementation LocationManagerTests

- (void)setUp
{
    [super setUp];
    
    self.manager = [[LocationManager alloc] init];
    self.cllmanager = OCMClassMock([CLLocationManager class]);
    self.managerMock = OCMPartialMock(self.manager);
}

- (void)tearDown
{
    [self.cllmanager stopMocking];
    self.cllmanager = nil;
    [super tearDown];
}

- (void)testCurrentAuthorizationTestable
{
    OCMExpect([self.managerMock authorizationStatus]).andReturn(kCLAuthorizationStatusAuthorizedWhenInUse);
    XCTAssertEqualObjects(@"Authorized When In Use", [self.managerMock currentAuthorizationTestable]);
    
    OCMExpect([self.managerMock authorizationStatus]).andReturn(kCLAuthorizationStatusAuthorizedAlways);
    XCTAssertEqualObjects(@"Authorized Always", [self.managerMock currentAuthorizationTestable]);
    
    OCMExpect([self.managerMock authorizationStatus]).andReturn(kCLAuthorizationStatusRestricted);
    XCTAssertEqualObjects(@"Not Authorized", [self.managerMock currentAuthorizationTestable]);
    
    OCMExpect([self.managerMock authorizationStatus]).andReturn(kCLAuthorizationStatusDenied);
    XCTAssertEqualObjects(@"Not Authorized", [self.managerMock currentAuthorizationTestable]);
    
    OCMExpect([self.managerMock authorizationStatus]).andReturn(kCLAuthorizationStatusNotDetermined);
    XCTAssertEqualObjects(@"Not Authorized", [self.managerMock currentAuthorizationTestable]);
}

// The imported class NameCollisionExample.h creates a name collision
- (void)testCurrentAuthorizationNonTestable
{
    id cllocationManagerMock;
    
    @try {
        // We would need to mock the CLLocationManager class.
        cllocationManagerMock = OCMClassMock([CLLocationManager class]);
        
        // However, the authorizationStatus exists in multiple classes.
        //OCMExpect([(CLLocationManager *)cllocationManagerMock authorizationStatus]).andReturn(kCLAuthorizationStatusAuthorizedWhenInUse);
        // We can't fix - Not even with casts
        //OCMExpect([(CLLocationManager *)cllocationManagerMock authorizationStatus]).andReturn(kCLAuthorizationStatusAuthorizedWhenInUse);
    
        //XCTAssertEqualObjects(@"Authorized When In Use", [self.manager currentAuthorizationNonTestable]);
    } @finally {
        [cllocationManagerMock stopMocking];
    }
}

// Is this an good unit test ?
- (void)testRequestLocationSync
{
    WAIT_FOR_AUTHORIZATION;
    [Utils backgroundTest:^{
        OCMStub([self.managerMock isAuthorized]).andReturn(YES);
        CLLocation *location = [self.manager requestLocationUpdateSync];
        XCTAssertNotNil(location);
    }];
}

- (void)testRequestLocationSync_MockingManager
{
    //Grant permision
    OCMStub([self.managerMock isAuthorized]).andReturn(YES);
    
    //Avoid usage of API
    self.managerMock.manager = self.cllmanager;
    OCMStub([self.cllmanager requestLocation]).andDo(nil);
    
    //Track the threadWait
    id threadWaitMock = OCMClassMock([ThreadWait class]);
    OCMStub([threadWaitMock alloc]).andReturn(threadWaitMock);
    OCMStub([threadWaitMock initDefault]).andReturn(threadWaitMock);
    
    //inject location
    __block CLLocation* testLocation = [[CLLocation alloc] init];
    void (^block)(NSInvocation*) = ^(NSInvocation *invocation){
        self.managerMock.lastLocation = testLocation;
    };
    OCMStub([threadWaitMock wait]).andDo(block);
    
    CLLocation *location = [self.managerMock requestLocationUpdateSync];
    XCTAssertEqualObjects(testLocation,location);
}

@end
