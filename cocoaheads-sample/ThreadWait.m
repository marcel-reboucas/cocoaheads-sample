//
//  ILMLooper.m
//  InLocoMediaAPI
//
//  Created by Vitor on 3/3/15.
//  Copyright (c) 2015 InLocoMedia. All rights reserved.
//

#import "ThreadWait.h"

@interface ThreadWait ()

@property (nonatomic, strong) NSThread *loopThread;
@property (nonatomic, assign) BOOL stopping;
@property (nonatomic, strong) ThreadWait *strongSelf;
@property (nonatomic, strong) NSLock *lock;

@end

@implementation ThreadWait

- (instancetype)initDefault
{
    return [self init];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.waiting = NO;
        self.stopping = NO;
        self.lock = [[NSLock alloc] init];
    }
    
    return self;
}

- (void)wait
{
    NSAssert(!NSThread.isMainThread, @"This method should not execute on main thread");
    NSAssert(!self.waiting, @"Wait method should not be called twice in the same ILMWaiter instance.");
    
    [self.lock lock];
    
    if (!self.waiting && !self.stopping) {
        self.waiting = YES;
        self.stopping = NO;
        self.loopThread = [NSThread currentThread];
        self.strongSelf = self;
        
        [self.lock unlock];
        
        while (self.waiting && !self.stopping) {
            @autoreleasepool {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
            }
        }
        
        self.strongSelf = nil;
    } else {
        [self.lock unlock];
    }
}

- (void)waitWithTimeout:(NSTimeInterval)timeout
{
    [self performSelector:@selector(stopWaitingWithTimeout) withObject:nil afterDelay:timeout];
    [self wait];
}

- (void)stopWaitingAfterBlock:(RunBlock)block
{
    if (_stopping) {
        return;
    }
    
    [self.lock lock];
    
    if (!_stopping) {
        block();
        [self stopWaitThreadUnsafe];
    }
    
    [self.lock unlock];
}

- (void)stopWaitingWithTimeout
{
    if (_stopping) {
        return;
    }
    
    [self.lock lock];
    
    if (!_stopping) {
        _timeoutFired = YES;
        [self stopWaitThreadUnsafe];
    }
    
    [self.lock unlock];
}

- (void)stopWait
{
    if (_stopping) {
        return;
    }
    
    [self.lock lock];
    
    if (!_stopping) {
        [self stopWaitThreadUnsafe];
    }
    
    [self.lock unlock];
}

- (void)stopWaitThreadUnsafe
{
    [ThreadWait cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopWait) object:nil];
    self.stopping = YES;
    self.waiting = NO;
    [self notifyRunLoop];
}

- (void)notifyRunLoop
{
    // Awake the run loop
    if (self.loopThread) {
        [ThreadWait performSelector:@selector(dummy) onThread:self.loopThread withObject:nil waitUntilDone:NO];
    }
}

+ (void)dummy
{
    // Do nothing
    // Used only for notifying the runLoop.
}

@end
