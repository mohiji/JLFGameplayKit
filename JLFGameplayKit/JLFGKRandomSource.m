//
//  JLFKGRandomSource.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 8/2/15.
//

#import "JLFGKRandomSource.h"
#import "JLFGKSystemRandomSource.h"

@implementation JLFGKRandomSource

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    // This particular class doesn't have any state to decode.
    return [self init];
}

- (NSInteger)nextInt
{
    NSAssert(false, @"JLFGKRandomSource does not implement -nextInt: use one of its subclasses instead.");
    return 4;
}

- (NSUInteger)nextIntWithUpperBound:(NSUInteger)upperBound
{
    NSAssert(false, @"JLFGKRandomSource does not implement -nextIntWithUpperBound: use one of its subclasses instead.");
    return 4;
}

- (float)nextUniform
{
    return [self nextIntWithUpperBound:(NSUInteger)INT32_MAX] / (float)INT32_MAX;
}

- (BOOL)nextBool
{
    return [self nextIntWithUpperBound:1] == 1;
}

- (NSArray *)arrayByShufflingObjectsInArrays:(NSArray *)array
{
    NSMutableArray *copy = [array copy];
    NSUInteger count = copy.count;
    for (NSUInteger i = 0; i < count; i++) {
        NSUInteger other = [self nextIntWithUpperBound:count];
        [copy exchangeObjectAtIndex:i withObjectAtIndex:other];
    }

    return copy;
}

+ (JLFGKRandomSource *)sharedRandom
{
    static JLFGKSystemRandomSource *systemRandom = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemRandom = [[JLFGKSystemRandomSource alloc] init];
    });

    return systemRandom;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    JLFGKRandomSource *source = [[[self class] alloc] init];
    return source;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // This particular random source class doesn't have any state to persist.
}

@end
