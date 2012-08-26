//
//  TimedWaitOperation.m
//  AsyncOperationQueues
//
//  Created by Anurag Mishra on 8/26/12.
//

#import "TimedWaitOperation.h"

@implementation TimedWaitOperation {
    BOOL _finished;
    BOOL _executing;
    NSTimeInterval _waitTime;
}

- (id)initWithWaitTime:(NSTimeInterval)waitTime {
    self = [super init];
    if (self) {
        _waitTime = waitTime;
    }
    return self;
}

- (void)doneWaiting {
    NSLog(@"Waited for %f seconds.", _waitTime);
    [self finish];    
}

- (void)start {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        });

        return;
    }

    NSLog(@"Starting wait for %f seconds.", _waitTime);
    if ([self isCancelled]) {
        [self finishOnly];
        return;
    }

    [self willChangeValueForKey:@"isExecuting"];

    _executing = YES;
    [NSTimer scheduledTimerWithTimeInterval:_waitTime target:self selector:@selector(doneWaiting) userInfo:nil repeats:NO];

    [self didChangeValueForKey:@"isExecuting"];
}

// Only changes the finished property, and notifies observers.
- (void)finishOnly {
    [self willChangeValueForKey:@"isFinished"];
    _finished = YES;
    [self didChangeValueForKey:@"isFinished"];
    return;
}

// Modified the finished and executing properties, and notifies observers.
- (void)finish {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];

    _executing = NO;
    _finished = YES;

    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isFinished {
    return _finished;
}


@end
