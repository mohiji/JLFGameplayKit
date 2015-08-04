//
//  JLFGKLinearCongruentialRandomSource.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 8/2/15.
//

#import "JLFGKRandomSource.h"

@interface JLFGKLinearCongruentialRandomSource : JLFGKRandomSource<NSCopying, NSSecureCoding>

- (instancetype)init;
- (instancetype)initWithSeed:(uint64_t)seed;

@property (assign, nonatomic) uint64_t seed;

@end
