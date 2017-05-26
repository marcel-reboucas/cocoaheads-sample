//
//  ILMLooper.h
//  InLocoMediaAPI
//
//  Created by Vitor on 3/3/15.
//  Copyright (c) 2015 InLocoMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RunBlock)(void);

@interface ThreadWait : NSObject

@property (nonatomic, assign) BOOL waiting;
@property (nonatomic, assign) BOOL busy;
@property (nonatomic, assign) BOOL timeoutFired;

- (instancetype)initDefault;

- (void)wait;
- (void)waitWithTimeout:(NSTimeInterval)timeout;
- (void)stopWait;

@end
