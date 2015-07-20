//
//  JLFGKGraphNode2D.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/15/15.
//

#import "JLFGKGraphNode2D.h"
#import "JLFGKGraphNode2D+Private.h"

@interface JLFGKGraphNode2D ()

@property (strong, nonatomic) NSMutableSet *lockedConnections;

@end

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
        self.lockedConnections = [NSMutableSet set];
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
    return vector_distance(other.position, self.position);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{%.2f, %.2f}", self.position.x, self.position.y];
}

@end
