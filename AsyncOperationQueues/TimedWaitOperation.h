//
//  TimedWaitOperation.h
//  AsyncOperationQueues
//
//  Created by Anurag Mishra on 8/26/12.
//

#import <Foundation/Foundation.h>

@interface TimedWaitOperation : NSOperation

// Designated initializer.
- (id)initWithWaitTime:(NSTimeInterval)waitTime;

@end
