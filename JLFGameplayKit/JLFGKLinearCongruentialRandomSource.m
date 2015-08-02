//
//  JLFGKLinearCongruentialRandomSource.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 8/2/15.
//

#import "JLFGKLinearCongruentialRandomSource.h"

static const int64_t MODULUS = 281474976710656L; //  2 ^ 48
static const int64_t MULTIPLIER = 25214903917L;
static const int64_t INCREMENT = 11L;

@implementation JLFGKLinearCongruentialRandomSource

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)init
{
    uint64_t seed;
    SecRandomCopyBytes(kSecRandomDefault, sizeof(seed), (uint8_t*)&seed);

    return [self initWithSeed:seed];
}

- (instancetype)initWithSeed:(uint64_t)seed
{
    self = [super init];
    if (self != nil) {
        self.seed = seed;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil) {
        self.seed = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"seed"] unsignedIntegerValue];
    }

    return self;
}

- (NSInteger)nextInt
{
    // I'm using Java's parameters from java.util.Random, according to the Wikipedia page on
    // Linear congruential generators:
    // https://en.wikipedia.org/wiki/Linear_congruential_generator

    int64_t next = (MULTIPLIER * self.seed + INCREMENT) % MODULUS;
    NSInteger result = (next >> 16) & 0xffffffff;
    self.seed = result;
    return result;
}

- (NSUInteger)nextIntWithUpperBound:(NSUInteger)upperBound
{
    // I'm not sure whether that modulus will mess with the uniformity of the generator, but a linear congruential generator
    // really isn't great anyway, so /shrug.
    NSUInteger value = ([self nextInt] + NSIntegerMax) % upperBound;
    return value;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithUnsignedLongLong:self.seed] forKey:@"seed"];
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    JLFGKLinearCongruentialRandomSource *source = [[[self class] alloc] init];
    source.seed = self.seed;
    return source;
}

@end

