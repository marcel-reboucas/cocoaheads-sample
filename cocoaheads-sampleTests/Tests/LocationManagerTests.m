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
#import "LocationDelegateWithBlocks.h"

// Private Category Trick to expose private properties for testing
@interface LocationManager (Test)

@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) CLLocation *lastLocation;
@property (strong, nonatomic) ThreadWait *waiter;
- (CLAuthorizationStatus)authorizationStatus;
- (NSString *)currentAuthorization;
- (BOOL)isAuthorized;
// Delegate calls
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(nonnull NSError *)error;

@end

@interface LocationManagerTests : XCTestCase

@property (nonatomic, strong) LocationManager *manager;
@property (nonatomic, strong) LocationManager *managerMock;
@property (nonatomic, strong) id cllManagerMock;

@end

@implementation LocationManagerTests

- (void)setUp
{
    [super setUp];
    
    self.manager = [[LocationManager alloc] init];
    self.cllManagerMock = OCMClassMock([CLLocationManager class]);
    self.managerMock = OCMPartialMock(self.manager);
}

- (void)tearDown
{
    [self.cllManagerMock stopMocking];
    [(OCMockObject *)self.managerMock stopMocking];
    self.cllManagerMock = nil;
    self.managerMock = nil;
    [super tearDown];   
}

- (void)testCurrentAuthorization
{
    OCMExpect([self.cllManagerMock authorizationStatus]).andReturn(kCLAuthorizationStatusAuthorizedWhenInUse);
    XCTAssertEqualObjects(@"Authorized When In Use", [self.manager currentAuthorization]);
    
    OCMExpect([self.cllManagerMock authorizationStatus]).andReturn(kCLAuthorizationStatusAuthorizedAlways);
    XCTAssertEqualObjects(@"Authorized Always", [self.manager currentAuthorization]);
    
    OCMExpect([self.cllManagerMock authorizationStatus]).andReturn(kCLAuthorizationStatusRestricted);
    XCTAssertEqualObjects(@"Not Authorized", [self.manager currentAuthorization]);
    
    OCMExpect([self.cllManagerMock authorizationStatus]).andReturn(kCLAuthorizationStatusDenied);
    XCTAssertEqualObjects(@"Not Authorized", [self.manager currentAuthorization]);
    
    OCMExpect([self.cllManagerMock authorizationStatus]).andReturn(kCLAuthorizationStatusNotDetermined);
    XCTAssertEqualObjects(@"Not Authorized", [self.manager currentAuthorization]);
}

// -------------- Sync example ----------------

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
    //Grants permission
    OCMStub([self.managerMock isAuthorized]).andReturn(YES);
    
    //Avoids the usage of the default API
    self.managerMock.manager = self.cllManagerMock;
    OCMStub([self.cllManagerMock requestLocation]).andDo(nil);
    
    //Tracks the threadWait
    id threadWaitMock = OCMClassMock([ThreadWait class]);
    OCMStub([threadWaitMock alloc]).andReturn(threadWaitMock);
    OCMStub([threadWaitMock initDefault]).andReturn(threadWaitMock);
    
    //Injects the test location
    __block CLLocation *testLocation = [[CLLocation alloc] init];
    void (^block)(NSInvocation *) = ^(NSInvocation *invocation) {
        [self.managerMock locationManager:self.cllManagerMock didUpdateLocations:@[testLocation]];
    };
    OCMStub([threadWaitMock wait]).andDo(block);
    
    CLLocation *location = [self.managerMock requestLocationUpdateSync];
    XCTAssertEqualObjects(testLocation, location);
}

// -------------- Delegate example ----------------


- (void)testRequestLocationDelegate_success
{
    //Grants permission
    OCMStub([self.managerMock isAuthorized]).andReturn(YES);
    
    //Avoids the usage of the default API
    self.managerMock.manager = self.cllManagerMock;
    
    //Injects the test location
    __block CLLocation *testLocation = [[CLLocation alloc] init];
    void (^block)(NSInvocation *) = ^(NSInvocation *invocation) {
        [self.managerMock locationManager:self.cllManagerMock didUpdateLocations:@[testLocation]];
    };
    OCMStub([self.cllManagerMock requestLocation]).andDo(block);
    
    //Starts the delegate
    LocationDelegateWithBlocks *testDelegate = [[LocationDelegateWithBlocks alloc] init];
    testDelegate.receivedLocationBlock = ^(CLLocation *location, NSError *error) {
        //Asserts
        XCTAssertEqualObjects(testLocation, location);
        XCTAssertNil(error);
        
        // Could also use a expectation to check if the delegate method is being called.
    };

    self.managerMock.delegate = testDelegate;
    
    [self.managerMock requestLocationUpdateAsyncDelegate];
}

- (void)testRequestLocationDelegate_error
{
    //Grants permission
    OCMStub([self.managerMock isAuthorized]).andReturn(YES);
    
    //Avoids the usage of the default API
    self.managerMock.manager = self.cllManagerMock;
    
    //Injects the test location
    __block NSError *testError = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:0 userInfo:nil];
    void (^block)(NSInvocation *) = ^(NSInvocation *invocation) {
        [self.managerMock locationManager:self.cllManagerMock didFailWithError:testError];
    };
    OCMStub([self.cllManagerMock requestLocation]).andDo(block);
    
    //Starts the delegate
    LocationDelegateWithBlocks *testDelegate = [[LocationDelegateWithBlocks alloc] init];
    testDelegate.receivedLocationBlock = ^(CLLocation *location, NSError *error) {
        //Asserts
        XCTAssertEqualObjects(testError, error);
        XCTAssertNil(location);
        
        // Could also use a expectation to check if the delegate method is being called.
    };
    
    self.managerMock.delegate = testDelegate;
    
    [self.managerMock requestLocationUpdateAsyncDelegate];
}

@end
