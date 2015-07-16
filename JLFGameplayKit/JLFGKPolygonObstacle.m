//
//  JLFGKPolygonObstacle.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/15/15.
//

#import "JLFGKPolygonObstacle.h"

@interface JLFGKPolygonObstacle ()

@property (assign, nonatomic) vector_float2 *vertices;
@property (assign, nonatomic) NSUInteger vertexCount;

@end

@implementation JLFGKPolygonObstacle

+ (instancetype)obstacleWithPoints:(vector_float2 *)points count:(size_t)numPoints
{
    return [[[self class] alloc] initWithPoints:points count:numPoints];
}

- (instancetype)initWithPoints:(vector_float2 *)points count:(size_t)numPoints
{
    NSAssert(points != NULL, @"JLFGKPolygonObstacle -initWithPoints:count: Cannot create an obstacle with a null points array.");
    NSAssert(numPoints > 1, @"JLFGKPolygonObstacle -initWithPoints:count: Cannot create an obstacle with < 2 points.");

    self = [super init];
    if (self != nil) {
        self.vertexCount = numPoints;
        self.vertices = calloc(sizeof(vector_float2), numPoints);
        memcpy(self.vertices, points, sizeof(vector_float2) * numPoints);
    }

    return self;
}

- (instancetype)init
{
    NSAssert(NO, @"JLFGKPolygonObstacle instances must be initialized via -initWithPoints:count:");
    return nil;
}

- (void)dealloc
{
    free(self.vertices);
}

- (vector_float2)vertexAtIndex:(NSUInteger)idx
{
    NSAssert(idx < self.vertexCount, @"JLFGKPolygonObstacle -vertexAtIndex: Index is out of range.");
    return self.vertices[idx];
}

@end
