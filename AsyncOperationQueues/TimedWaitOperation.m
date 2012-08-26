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

// Initializer method. This lets the caller specify the amount of time
// that this operation should wait before it completes.
//
// For your custom operation classes, modify this initializer method
// and pass whatever data is needed to initialize the operation.
//
// For example, to initialize a download operation where you download an mp3 file,
// you'd need to give it the url to the mp3 file.
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

// Must override this method for *concurrent* operations.

- (void)start {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        });

        return;
    }

    // Ensure the method hasn't been cancelled since it was
    // added to the queue. If it has been cancelled,
    // then we better not start it.
    NSLog(@"Starting wait for %f seconds.", _waitTime);
    if ([self isCancelled]) {
        [self finishOnly];
        return;
    }

    // 1. START the real work here
    // 2. Notify observers through KVO that we are starting the
    // execution of the work.
    //
    // This notification is crucial for this operation class
    // to work with a  NSOperationQueue.
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

// Changes both the finished and executing properties, and notifies observers.
- (void)finish {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];

    _executing = NO;
    _finished = YES;

    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

// Since this example is demonstrating how to deal with
// asynchronous and dependent operations, this example is
// purely concurrent.
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