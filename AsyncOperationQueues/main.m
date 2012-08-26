//
//  main.m
//  AsyncOperationQueues
//
//  Created by Anurag Mishra on 8/26/12.
//

#import <Foundation/Foundation.h>
#import "TimedWaitOperation.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        TimedWaitOperation *a = [[TimedWaitOperation alloc] initWithWaitTime:2];
        TimedWaitOperation *b = [[TimedWaitOperation alloc] initWithWaitTime:3];
        TimedWaitOperation *c = [[TimedWaitOperation alloc] initWithWaitTime:1];
        
        [b addDependency:a];
        [c addDependency:b];

        [queue addOperations:[NSArray arrayWithObjects:a, b, c, nil] waitUntilFinished:NO];

        while (queue.operationCount > 0) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }

    return 0;
}