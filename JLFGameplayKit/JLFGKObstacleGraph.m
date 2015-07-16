//
//  JLFGKObstacleGraph.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/15/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "JLFGKObstacleGraph.h"

@interface JLFGKObstacleGraph ()

@property (strong, nonatomic) NSMutableArray *realObstacles;
@property (assign, nonatomic) float bufferRadius;

@end

@implementation JLFGKObstacleGraph
@synthesize bufferRadius = _bufferRadius;

+ (instancetype)graphWithObstacles:(NSArray *)obstacles bufferRadius:(float)radius
{
    return [[[self class] alloc] initWithObstacles:obstacles bufferRadius:radius];
}

- (instancetype)initWithObstacles:(NSArray *)obstacles bufferRadius:(float)radius
{
    NSAssert(radius > 0.0f, @"JLFGKObstacleGraph -initWithObstacles:bufferRadius: Buffer radius cannot be <= 0!");

    if (obstacles == nil) {
        obstacles = [NSArray array];
    }

    for (id obj in obstacles) {
        NSAssert([obj isKindOfClass:[JLFGKPolygonObstacle class]], @"JLFGKObstacleGraph only works with polygon obstacles.");
    }

    self = [super initWithNodes:@[]];
    if (self != nil) {
        self.realObstacles = [NSMutableArray arrayWithArray:obstacles];
        self.bufferRadius = radius;
    }

    return self;
}

- (instancetype)initWithNodes:(NSArray *)nodes
{
    NSAssert(NO, @"JLFGKObstacleGraph must be initialized using -initWithObstacles:bufferRadius:");
    return nil;
}

- (instancetype)init
{
    NSAssert(NO, @"JLFGKObstacleGraph must be initialized using -initWithObstacles:bufferRadius:");
    return nil;
}


@end
