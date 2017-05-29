//
//  Utils.h
//  cocoaheads-sample
//
//  Created by Rafael Gouveia on 5/29/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

typedef void (^ILMRunBlock)(void);

@interface Utils : NSObject

+ (void)backgroundTest:(ILMRunBlock)block;
+ (void)fullfillExpectiationOn:(XCTestExpectation *)expectation;
+ (void)unblockingMainThreadSleep:(NSTimeInterval)time forTestClass:(XCTestCase *)testCase;

@end
