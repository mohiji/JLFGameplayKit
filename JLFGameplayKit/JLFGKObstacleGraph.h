//
//  JLFGKObstacleGraph.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/15/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "JLFGKGraph.h"
#import "JLFGKPolygonObstacle.h"

@interface JLFGKObstacleGraph : JLFGKGraph

+ (instancetype)graphWithObstacles:(NSArray *)obstacles bufferRadius:(float)radius;
- (instancetype)initWithObstacles:(NSArray *)obstacles bufferRadius:(float)radius;

@property (readonly, nonatomic) NSArray *obstacles;
@property (readonly, nonatomic) float bufferRadius;

- (void)addObstacles:(NSArray *)obstacles;
- (void)removeObstacles:(NSArray *)obstacles;
- (void)removeAllObstacles;
- (NSArray *)nodesForObstacle:(JLFGKPolygonObstacle *)obstacle;

@end
