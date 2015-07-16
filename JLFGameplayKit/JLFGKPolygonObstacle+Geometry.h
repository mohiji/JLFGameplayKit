//
//  JLFGKPolygonObstacle+Geometry.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/16/15.
//
//  These methods are mostly used internally by JLFGKObstacleGraph, but they're useful enough that
//  I'm adding them as a category on JLFGKPolygonObstacle for others to use.

#import "JLFGKPolygonObstacle.h"
#import "JLFGKGraphNode2D.h"

@interface JLFGKPolygonObstacle (Geometry)

@property (readonly, nonatomic) float area;
@property (readonly, nonatomic) vector_float2 centroid;

- (NSArray *)nodesWithBufferRadius:(float)radius;

@end
