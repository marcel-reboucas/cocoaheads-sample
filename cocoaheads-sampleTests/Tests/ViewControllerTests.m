//
//  ViewControllerTests.m
//  cocoaheads-sample
//
//  Created by Marcel de Siqueira Campos Rebouças on 5/23/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

// Private Category Trick to expose private properties for testing
@interface ViewController (Test)

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *emailLabel;

@end

@interface ViewControllerTests : XCTestCase

@property NSString *myName;
@property NSString *myEmail;

@end

@implementation ViewControllerTests

- (void)setUp
{
    [super setUp];
    _myName = @"João";
    _myEmail = @"joao@notanemail.com";
    
    [[NSUserDefaults standardUserDefaults] setObject:_myName forKey:@"name"];
    [[NSUserDefaults standardUserDefaults] setObject:_myEmail forKey:@"email"];
}

- (void)testViewDidLoad_SetsLabels_Always
{
    // Create objects
    ViewController *toTest = [[ViewController alloc] init];
    
    // Call the method to be tested
    [toTest viewDidLoad];
    
    // Verify
    XCTAssertEqualObjects(_myName, toTest.nameLabel.text);
    XCTAssertEqualObjects(_myEmail, toTest.emailLabel.text);
}

- (void)tearDown
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
    [super tearDown];
}

@end
