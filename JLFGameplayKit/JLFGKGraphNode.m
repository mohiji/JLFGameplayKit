//
//  JLFGKGraphNode.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "JLFGKGraphNode.h"
#import "JLFGKSimplePriorityQueue.h"

@interface JLFGKGraphNode ()

@property (strong, nonatomic) NSMutableArray *nodes;

@end

@implementation JLFGKGraphNode

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.nodes = [NSMutableArray array];
    }

    return self;
}

- (NSArray *)connectedNodes
{
    return self.nodes;
}

- (void)addConnectionsToNodes:(NSArray *)nodes bidirectional:(BOOL)bidirectional
{
    NSAssert(nodes != nil, @"JLFGKGraphNode -addConnectionsToNodes:bidirectional: Cannot call with a nil nodes array.");

    for (JLFGKGraphNode *node in nodes) {
        if (node == self) {
            // Let's not add circular connections to ourselves, shall we?
            continue;
        }

        if (![self.nodes containsObject:node]) {
            [self.nodes addObject:node];
        }

        if (bidirectional) {
            [node addConnectionsToNodes:@[self] bidirectional:NO];
        }
    }
}

- (void)removeConnectionsToNodes:(NSArray *)nodes bidirectional:(BOOL)bidirectional
{
    NSAssert(nodes != nil, @"JLFGKGraphNode -removeConnectionsToNodes:bidirectional: Cannot call with a nil nodes array.");

    for (JLFGKGraphNode *node in nodes) {
        if ([self.nodes containsObject:node]) {
            [self.nodes removeObject:node];
            if (bidirectional) {
                [node removeConnectionsToNodes:@[self] bidirectional:NO];
            }
        }
    }
}

- (float)costToNode:(JLFGKGraphNode *)node
{
    if ([self.nodes containsObject:node]) {
        return 1.0f;
    } else {
        return FLT_MAX;
    }
}

- (float)estimatedCostToNode:(JLFGKGraphNode *)node
{
    if ([self.nodes containsObject:node]) {
        return 0.0f;
    } else {
        return FLT_MAX;
    }
}

- (NSArray *)findPathFromNode:(JLFGKGraphNode *)startNode
{
    return [startNode findPathToNode:self];
}

- (NSArray *)findPathToNode:(JLFGKGraphNode *)goalNode
{
    JLFGKSimplePriorityQueue *frontier = [[JLFGKSimplePriorityQueue alloc] init];
    NSMapTable *cameFrom = [NSMapTable mapTableWithKeyOptions:NSMapTableObjectPointerPersonality
                                                 valueOptions:NSMapTableWeakMemory];
    NSMapTable *costSoFar = [NSMapTable mapTableWithKeyOptions:NSMapTableObjectPointerPersonality
                                                  valueOptions:NSMapTableStrongMemory];

    [frontier insertObject:self withPriority:0.0f];
    [costSoFar setObject:[NSNumber numberWithFloat:0.0f] forKey:self];

    while (frontier.count > 0) {
        JLFGKGraphNode *current = [frontier get];

        if (current == goalNode) {
            // Done. Walk back through the cameFrom map to build up the node list, reverse and return it.
            NSMutableArray *reversedPath = [NSMutableArray array];
            [reversedPath addObject:current];
            JLFGKGraphNode *previousNode = [cameFrom objectForKey:current];
            while (previousNode != nil) {
                [reversedPath addObject:previousNode];
                previousNode = [cameFrom objectForKey:previousNode];
            }

            NSEnumerator *enumerator = [reversedPath reverseObjectEnumerator];
            return [enumerator allObjects];
        }

        for (JLFGKGraphNode *next in current.connectedNodes) {
            float newCost = [[costSoFar objectForKey:current] floatValue] + [current costToNode:next];
            NSNumber *existingCost = [costSoFar objectForKey:next];
            if (existingCost == nil || newCost < [existingCost floatValue]) {
                [costSoFar setObject:[NSNumber numberWithFloat:newCost] forKey:next];
                float priority = newCost + [next estimatedCostToNode:goalNode];
                [frontier insertObject:next withPriority:priority];
                [cameFrom setObject:current forKey:next];
            }
        }
    }

    // If we end up here, that means the goal node wasn't reachable from the start node.
    return nil;
}

@end
