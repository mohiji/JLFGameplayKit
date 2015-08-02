//
//  JLFGKSystemRandomSource.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 8/2/15.
//

#import "JLFGKSystemRandomSource.h"

@implementation JLFGKSystemRandomSource

- (NSInteger)nextInt
{
    return arc4random() - INT32_MIN;
}

- (NSUInteger)nextIntWithUpperBound:(NSUInteger)upperBound
{
    return arc4random_uniform((u_int32_t)upperBound);
}

@end
