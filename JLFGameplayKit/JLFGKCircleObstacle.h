//
//  JLFGKCircleObstacle.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/15/15.
//

#import "JLFGKObstacle.h"
#import <simd/vector.h>

@interface JLFGKCircleObstacle : JLFGKObstacle

+ (instancetype)obstacleWithRadius:(float)radius;
- (instancetype)initWithRadius:(float)radius;

@property (assign, nonatomic) vector_float2 position;
@property (assign, nonatomic) float radius;

@end
