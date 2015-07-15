//
//  JLFGKCircleObstacle.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/15/15.
//

#import "JLFGKCircleObstacle.h"

@implementation JLFGKCircleObstacle

+ (instancetype)obstacleWithRadius:(float)radius
{
    return [[[self class] alloc] initWithRadius:radius];
}

- (instancetype)initWithRadius:(float)radius
{
    // Interesting question here: a negative radius never makes sense, right? Should I stop that from happening?
    // TODO: Find out what the real GameplayKit does.

    self = [super init];
    if (self != nil) {
        _radius = radius;
        _position = (vector_float2){0, 0};
    }
    return self;
}

@end
