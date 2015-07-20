//
//  JLFGKGraph.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "JLFGKGraph.h"

@interface JLFGKGraph ()

@property (strong, nonatomic) NSMutableArray *realNodes;

@end

@implementation JLFGKGraph

+ (instancetype)graphWithNodes:(NSArray *)nodes
{
    return [[[self class] alloc] initWithNodes:nodes];
}

- (instancetype)initWithNodes:(NSArray *)nodes
{
    NSAssert(nodes != nil, @"JLFGKGraph -initWithNodes: Cannot be initialized with a nil nodes array.");
    self = [super init];
    if (self != nil) {
        self.realNodes = [NSMutableArray arrayWithArray:nodes];
    }
    return self;
}

- (NSArray *)nodes
{
    return self.realNodes;
}

- (void)addNodes:(NSArray *)nodes
{
    NSAssert(nodes != nil, @"JLFGKGraph -addNodes: Cannot be called with a nil nodes array.");

    // Make sure we're not adding any duplicates
    for (JLFGKGraphNode *node in nodes) {
        if (![self.realNodes containsObject:node]) {
            [self.realNodes addObject:node];
        }
    }
}

- (void)connectNodeToLowestCostNode:(JLFGKGraphNode *)node bidirectional:(BOOL)bidirectional
{
    JLFGKGraphNode *lowestCostNode = nil;
    float lowestCost = FLT_MAX;

    for (JLFGKGraphNode *n in self.realNodes) {
        float cost = [node costToNode:n];
        if (cost < lowestCost) {
            lowestCost = cost;
            lowestCostNode = n;
        }
    }

    if (lowestCostNode != nil) {
        [node addConnectionsToNodes:@[lowestCostNode] bidirectional:bidirectional];
    }
}

- (void)removeNodes:(NSArray *)nodes
{
    NSAssert(nodes != nil, @"JLFGKGraph -removeNodes: Cannot be called with a nil nodes array.");

    // Take out any connections from nodes still within the graph to the one being removed.
    for (JLFGKGraphNode *node in nodes) {
        [node removeConnectionsToNodes:self.realNodes bidirectional:YES];
    }

    [self.realNodes removeObjectsInArray:nodes];
}

- (NSArray *)findPathFromNode:(JLFGKGraphNode *)startNode toNode:(JLFGKGraphNode *)endNode
{
    return [startNode findPathToNode:endNode];
}

@end
