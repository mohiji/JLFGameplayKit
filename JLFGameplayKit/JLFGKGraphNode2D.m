//
//  JLFGKGraphNode2D.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/15/15.
//

#import "JLFGKGraphNode2D.h"

static float vector_float2_distance(vector_float2 a, vector_float2 b)
{
    vector_float2 diff;
    diff.x = a.x - b.x;
    diff.y = a.y - b.y;

    float magnitudeSquared = diff.x * diff.x + diff.y * diff.y;
    if (magnitudeSquared != 0) {
        return sqrtf(magnitudeSquared);
    } else {
        return 0;
    }
}

@implementation JLFGKGraphNode2D

+ (instancetype)nodeWithPoint:(vector_float2)point
{
    return [[[self class] alloc] initWithPoint:point];
}

- (instancetype)init
{
    NSAssert(NO, @"JLFGKGraphNode2D -init: Must use the designated initializer -initWithPoint:");
    return nil;
}

- (instancetype)initWithPoint:(vector_float2)point
{
    self = [super init];
    if (self != nil) {
        self.position = point;
    }
    return self;
}

- (float)estimatedCostToNode:(JLFGKGraphNode *)node
{
    return [self costToNode:node];
}

- (float)costToNode:(JLFGKGraphNode *)node
{
    NSAssert([node isKindOfClass:[JLFGKGraphNode2D class]], @"JLFGKGraphNode2D -costToNode: Only works with JLFGKGraphNode2D.");
    JLFGKGraphNode2D *other = (JLFGKGraphNode2D *)node;
    return vector_float2_distance(other.position, self.position);
}

@end
