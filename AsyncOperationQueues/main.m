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
        
        // 1. Create an operation queue.
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        // 2. Create the operations we want to run.
        TimedWaitOperation *a = [[TimedWaitOperation alloc] initWithWaitTime:2];
        TimedWaitOperation *b = [[TimedWaitOperation alloc] initWithWaitTime:3];
        TimedWaitOperation *c = [[TimedWaitOperation alloc] initWithWaitTime:1];
        
        // 3. Define the dependencies between operations. In this example, it looks like:
        // c <- b <- a
        // meaning "c" must run only after "b" finishes and,
        // "b", must run only after "a" finishes.
        [b addDependency:a];
        [c addDependency:b];

        // 4. Add all operations to the queue, and watch it run :)
        [queue addOperations:[NSArray arrayWithObjects:a, b, c, nil] waitUntilFinished:NO];

        // This is simply to extend the life of the current run loop. In it's absence,
        // the program would simply terminate before all the operations have
        // finished execution.
        while (queue.operationCount > 0) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }

    return 0;
}