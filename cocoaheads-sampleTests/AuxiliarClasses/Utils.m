//
//  Utils.m
//  cocoaheads-sample
//
//  Created by Rafael Gouveia on 5/29/17.
//  Copyright © 2017 inlocomedia. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (void)backgroundTest:(ILMRunBlock)block
{
    __block BOOL finishTest = NO;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        block();
        finishTest = YES;
    });
    
    while (!finishTest) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

+ (void)fullfillExpectiationOn:(XCTestExpectation *)expectation
{
    [expectation fulfill];
}

+ (void)unblockingMainThreadSleep:(NSTimeInterval)time forTestClass:(XCTestCase *)testCase
{
    if (NSThread.isMainThread) {
        XCTestExpectation *sleepExpectation = [testCase expectationWithDescription:@"Sleep"];
        [self performSelector:@selector(fullfillExpectiationOn:) withObject:sleepExpectation afterDelay:time];
        [testCase waitForExpectationsWithTimeout:(4 * time) handler:nil];
    } else {
        [NSThread sleepForTimeInterval:time];
    }
}

@end
