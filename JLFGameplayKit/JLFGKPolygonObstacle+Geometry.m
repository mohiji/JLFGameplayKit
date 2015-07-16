//
//  JLFGKPolygonObstacle+Geometry.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/16/15.
//
//  The implementations for the area and centroid of the polygon are adapted from Paul Bourke's geometry articles:
//  http://paulbourke.net/geometry/polygonmesh/

#import "JLFGKPolygonObstacle+Geometry.h"
#import "JLFGKGeometry.h"

@implementation JLFGKPolygonObstacle (Geometry)

- (float)area
{
    NSAssert(self.vertexCount >= 3, @"JLFGKPolygonObstacle -area: A polygon must have at least 3 vertices before you can ask for its area.");

    float sum = 0.0f;
    NSUInteger numVertices = self.vertexCount;
    for (NSUInteger i = 0; i < numVertices; i++) {
        NSUInteger j = (i + 1) % numVertices;

        vector_float2 current = [self vertexAtIndex:i];
        vector_float2 next = [self vertexAtIndex:j];
        sum += (current.x * next.y) - (next.x * current.y);
    }

    sum = sum / 2.0f;
    return (sum < 0 ? -sum : sum);
}

- (vector_float2)centroid
{
    NSAssert(self.vertexCount >= 3, @"JLFGKPolygonObstacle -area: A polygon must have at least 3 vertices before you can ask for its center.");

    const float area = self.area;
    float sumX = 0.0f, sumY = 0.0f;
    NSUInteger numVertices = self.vertexCount;
    for (NSUInteger i = 0; i < numVertices; i++) {
        NSUInteger j = (i + 1) % numVertices;

        vector_float2 current = [self vertexAtIndex:i];
        vector_float2 next = [self vertexAtIndex:j];

        float commonFactor = (current.x * next.y - next.x * current.y);
        sumX += (current.x + next.x) * commonFactor;
        sumY += (current.y + next.y) * commonFactor;
    }

    return (vector_float2){sumX / (6 * area), sumY / (6 * area)};
}

- (NSArray *)nodesWithBufferRadius:(float)radius
{
    NSAssert(self.vertexCount >= 3, @"JLFGKPolygonObstacle -nodesWithBufferRadius: Only works with a fully polygon, not a line or point.");

    const NSUInteger numVertices = self.vertexCount;
    const vector_float2 centroid = self.centroid;

    NSMutableArray *nodes = [NSMutableArray arrayWithCapacity:self.vertexCount];
    for (NSUInteger i = 0; i < numVertices; i++) {
        const vector_float2 point = [self vertexAtIndex:i];
        vector_float2 dv = vector_float2_subtract(point, centroid);
        dv = vector_float2_normalized(dv);
        dv = vector_float2_scale(dv, radius);

        vector_float2 result = vector_float2_add(point, dv);
        [nodes addObject:[JLFGKGraphNode2D nodeWithPoint:result]];
    }

    return nodes;
}

@end
