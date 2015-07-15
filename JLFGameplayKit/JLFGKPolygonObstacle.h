//
//  JLFGKPolygonObstacle.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/15/15.
//

#import "JLFGKObstacle.h"
#import <simd/vector.h>

@interface JLFGKPolygonObstacle : JLFGKObstacle

+ (instancetype)obstacleWithPoints:(vector_float2 *)points count:(size_t)numPoints;
- (instancetype)initWithPoints:(vector_float2 *)points count:(size_t)numPoints;

@property (readonly, nonatomic) NSUInteger vertexCount;

- (vector_float2)vertexAtIndex:(NSUInteger)idx;

@end
