//
//  LocationViewControllerTests.m
//  cocoaheads-sample
//
//  Created by Marcel de Siqueira Campos Rebouças on 5/28/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LocationManager.h"
#import "OCMock.h"

// Private Category Trick to expose private properties for testing
@interface LocationManager (Test)

- (CLAuthorizationStatus)authorizationStatus;
- (NSString *)currentAuthorizationNonTestable;
- (NSString *)currentAuthorizationTestable;

@end

@interface LocationManagerTests : XCTestCase

@property (nonatomic, strong) LocationManager *manager;
@property (nonatomic, strong) LocationManager *managerMock;

@end

@implementation LocationManagerTests

- (void)setUp
{
    [super setUp];
    
    self.manager = [[LocationManager alloc] init];
    self.managerMock = OCMPartialMock(self.manager);
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testCurrentAuthorizationTestable
{
    OCMExpect([self.managerMock authorizationStatus]).andReturn(kCLAuthorizationStatusAuthorizedWhenInUse);
    XCTAssertEqualObjects(@"Authorized When In Use", [self.managerMock currentAuthorizationTestable]);
    
    OCMExpect([self.managerMock authorizationStatus]).andReturn(kCLAuthorizationStatusAuthorizedAlways);
    XCTAssertEqualObjects(@"Authorized Always", [self.managerMock currentAuthorizationTestable]);
    
    OCMExpect([self.managerMock authorizationStatus]).andReturn(kCLAuthorizationStatusRestricted);
    XCTAssertEqualObjects(@"Authorized but Restricted", [self.managerMock currentAuthorizationTestable]);
    
    OCMExpect([self.managerMock authorizationStatus]).andReturn(kCLAuthorizationStatusDenied);
    XCTAssertEqualObjects(@"Not Authorized", [self.managerMock currentAuthorizationTestable]);
    
    OCMExpect([self.managerMock authorizationStatus]).andReturn(kCLAuthorizationStatusNotDetermined);
    XCTAssertEqualObjects(@"Not Authorized", [self.managerMock currentAuthorizationTestable]);
}

//TODO: Import name collision
- (void)testCurrentAuthorizationNonTestable
{
    id cllocationManagerMock;
    
    @try {
        // We would need to mock the CLLocationManager class.
        cllocationManagerMock = OCMClassMock([CLLocationManager class]);
        
        // However, we can't find the authorizationStatus method.
        OCMExpect([cllocationManagerMock authorizationStatus]).andReturn(kCLAuthorizationStatusAuthorizedWhenInUse);
        XCTAssertEqualObjects(@"Authorized When In Use", [self.manager currentAuthorizationNonTestable]);
        // Not even with casts
        //OCMExpect([(CLLocationManager *)cllocationManagerMock authorizationStatus]).andReturn(kCLAuthorizationStatusAuthorizedWhenInUse);
    } @finally {
        [cllocationManagerMock stopMocking];
    }
}

@end
