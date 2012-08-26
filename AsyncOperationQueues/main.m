//
//  main.m
//  AsyncOperationQueues
//
//  Created by Anurag Mishra on 8/26/12.
//

#import <Foundation/Foundation.h>
#import "TimedWaitOperation.h"

typedef void (^CompletionBlock)();

@interface QueueWatcher : NSObject

@property BOOL isComplete;

@end

@implementation QueueWatcher

- (id)init {
    self = [super init];
    if (self) {
        _isComplete = NO;
    }
    return self;
}

- (void)watchQueue:(NSOperationQueue *)queue {
    [queue addObserver:self forKeyPath:@"operations" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"operations"]) {
        NSOperationQueue *queue = (NSOperationQueue *)object;
        if (queue.operations.count == 0) {
            _isComplete = YES;
        }
    }
}

@end

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        QueueWatcher *watcher = [[QueueWatcher alloc] init];
        [watcher watchQueue:queue];
        
        TimedWaitOperation *a = [[TimedWaitOperation alloc] initWithWaitTime:2];
        TimedWaitOperation *b = [[TimedWaitOperation alloc] initWithWaitTime:3];
        TimedWaitOperation *c = [[TimedWaitOperation alloc] initWithWaitTime:1];
        
        [b addDependency:a];
        [c addDependency:b];
        
        [queue addOperations:@[ a, b, c ] waitUntilFinished:NO];

        while (!watcher.isComplete) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }

    return 0;
}