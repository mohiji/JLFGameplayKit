//
//  JLFGKObstacleGraph.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/15/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "JLFGKObstacleGraph.h"
#import "JLFGKPolygonObstacle+Geometry.h"
#import "JLFGKGeometry.h"

@interface JLFGKObstacleGraph ()

@property (strong, nonatomic) NSMapTable *obstacleToNodes;
@property (assign, nonatomic) float bufferRadius;

@property (strong, nonatomic) NSMapTable *lockedConnections;

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
        self.obstacleToNodes = [NSMapTable mapTableWithKeyOptions:NSMapTableObjectPointerPersonality
                                                     valueOptions:NSMapTableStrongMemory];
        self.lockedConnections = [NSMapTable mapTableWithKeyOptions:NSMapTableObjectPointerPersonality
                                                       valueOptions:NSMapTableStrongMemory];
        self.bufferRadius = radius;
        [self addObstacles:obstacles];
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

- (NSArray *)obstacles
{
    return [[self.obstacleToNodes keyEnumerator] allObjects];
}

- (void)rebuildConnections
{
    // First, remove the nodes for each obstacle, and then make a copy of what's leftover.
    // Those leftover nodes will be ones that the user added manually.
    for (NSArray *nodes in [self.obstacleToNodes objectEnumerator]) {
        [self removeNodes:nodes];
    }
    NSArray *userNodes = [self.nodes copy];

    // Each obstacle's nodes should be connected in a loop around the obstacle.
    // While we're at it, also build up a list of all the obstacle nodes in the graph:
    // we'll use it while connecting obstacles up to each other in a moment.
    NSArray *obstacles = [[self.obstacleToNodes keyEnumerator] allObjects];
    NSMutableArray *allObstacleNodes = [NSMutableArray array];
    for (JLFGKObstacle *obstacle in obstacles) {
        NSArray *nodes = [self.obstacleToNodes objectForKey:obstacle];
        NSUInteger numNodes = nodes.count;
        for (NSUInteger i = 0; i < numNodes; i++) {
            JLFGKGraphNode2D *current = nodes[i];
            JLFGKGraphNode2D *previous = nodes[(i + numNodes - 1) % numNodes];
            JLFGKGraphNode2D *next = nodes[(i + 1) % numNodes];
            [current addConnectionsToNodes:@[previous, next] bidirectional:YES];
        }

        // Make sure the obstacle's nodes get back into the main node list.
        [self addNodes:nodes];

        // And build up that list of all obstacle nodes
        [allObstacleNodes addObjectsFromArray:nodes];
    }

    // Run through the obstacle list again. This time, connect the nodes for the obstacle
    // to the nodes for every other obstacle. (not to its own nodes)
    //
    // Man, that's a lot of nested loops.
    for (JLFGKObstacle *obstacle in obstacles) {
        NSArray *obstacleNodes = [self.obstacleToNodes objectForKey:obstacle];
        NSMutableArray *otherNodes = [allObstacleNodes mutableCopy];
        [otherNodes removeObjectsInArray:obstacleNodes];

        for (JLFGKGraphNode2D *node in obstacleNodes) {
            NSMutableArray *connections = [NSMutableArray array];
            for (JLFGKGraphNode2D *otherNode in otherNodes) {
                if (![self anyObstaclesBetweenStart:node.position
                                                end:otherNode.position
                                  ignoringObstacles:@[]]) {
                    [connections addObject:otherNode];
                }
            }
            [node addConnectionsToNodes:connections bidirectional:YES];
        }
    }
//        NSArray *obstacleNodes = [self.obstacleToNodes objectForKey:obstacle];
//
//        for (JLFGKObstacle *otherObstacle in obstacles) {
//            if (obstacle == otherObstacle) {
//                continue;
//            }
//
//            NSArray *otherNodes = [self.obstacleToNodes objectForKey:otherObstacle];
//            for (JLFGKGraphNode2D *obstacleNode in obstacleNodes) {
//                for (JLFGKGraphNode2D *otherNode in otherNodes) {
//                    if (![self anyObstaclesBetweenStart:obstacleNode.position
//                                                    end:otherNode.position
//                                      ignoringObstacles:@[]]) {
//                        [obstacleNode addConnectionsToNodes:@[otherNode] bidirectional:YES];
//                    }
//                }
//            }
//        }
//    }

    // Now take the leftover user nodes and connect them back up.
    for (JLFGKGraphNode2D *node in userNodes) {
        [self connectNodeUsingObstacles:node ignoringObstacles:@[]];
    }
}

- (void)addObstacles:(NSArray *)obstacles
{
    NSAssert(obstacles != nil, @"JLFGKObstacleGraph -addObstacles: obstacles was nil.");

    // For each obstacle:
    //  - add it to the obstacle list
    //  - get its list of nodes
    //  - connect those nodes together
    //  - connect them to the rest of the graph?

    for (JLFGKPolygonObstacle *obstacle in obstacles) {
        NSArray *nodes = [obstacle nodesWithBufferRadius:self.bufferRadius];
        [self.obstacleToNodes setObject:nodes forKey:obstacle];
    }

    [self rebuildConnections];
}

- (void)connectNodeUsingObstacles:(id)node
{
    [self connectNodeUsingObstacles:node ignoringObstacles:@[]];
}

- (void)connectNodeUsingObstacles:(JLFGKGraphNode2D *)node ignoringObstacles:(NSArray *)obstaclesToIgnore
{
    // For every node in the graph, if you can draw a line between this node and the other one without
    // bumping into an obstacle (not counting the ones in obstaclesToIgnore), then connect those nodes
    // together.
    const vector_float2 start = node.position;
    NSMutableArray *connections = [NSMutableArray array];
    for (JLFGKGraphNode2D *other in self.nodes) {
        if (node == other) {
            continue;
        }
        
        vector_float2 end = other.position;

        if (![self anyObstaclesBetweenStart:start
                                       end:end
                         ignoringObstacles:obstaclesToIgnore]) {
            [connections addObject:other];
        }
    }

    [node addConnectionsToNodes:connections bidirectional:YES];
    [self addNodes:@[node]];
}

- (void)removeObstacles:(NSArray *)obstacles
{
    for (JLFGKPolygonObstacle *obstacle in obstacles) {
        [self removeNodes:[self.obstacleToNodes objectForKey:obstacle]];
        [self.obstacleToNodes removeObjectForKey:obstacle];
    }

    [self rebuildConnections];
}

- (void)removeAllObstacles
{
    for (NSArray *nodes in [self.obstacleToNodes objectEnumerator]) {
        [self removeNodes:nodes];
    }

    [self.obstacleToNodes removeAllObjects];
    [self rebuildConnections];
}

- (NSArray *)nodesForObstacle:(JLFGKPolygonObstacle *)obstacle
{
    return [self.obstacleToNodes objectForKey:obstacle];
}

- (BOOL)anyObstaclesBetweenStart:(vector_float2)start
                             end:(vector_float2)end
               ignoringObstacles:(NSArray *)obstaclesToIgnore
{
    // This is horribly inefficient: it just loops through each obstacle comparing
    // each line segment that makes up the polygon with the start/end point. It
    // will bail out as soon as an intersection is found, but if there aren't any
    // intersections it has to go through the whole list.
    //
    // It should be augmented with a spatial partition of some kind, but for now
    // let's just get it working.
    for (JLFGKPolygonObstacle *obstacle in [self.obstacleToNodes keyEnumerator]) {
        if ([obstaclesToIgnore containsObject:obstacle]) {
            continue;
        }

        NSArray *nodes = [self.obstacleToNodes objectForKey:obstacle];
        NSUInteger numNodes = nodes.count;
        for (NSUInteger i = 0; i < numNodes; i++) {
            JLFGKGraphNode2D *n1 = nodes[i];
            JLFGKGraphNode2D *n2 = nodes[(i + 1) % numNodes];

            if (line_segments_intersect(start, end, n1.position, n2.position)) {
                NSLog(@"Lines intersected: [{%.5f, %.5f} {%.5f, %.5f}] with [{%.5f, %.5f} {%.5f, %.5f}]",
                      start.x, start.y, end.x, end.y,
                      n1.position.x, n1.position.y,
                      n2.position.x, n2.position.y);
                return YES;

            }
        }
    }
    return NO;
}

- (void)lockConnectionFromNode:(JLFGKGraphNode2D *)startNode toNode:(JLFGKGraphNode2D *)endNode
{
    NSMutableArray *connections = [self.lockedConnections objectForKey:startNode];
    if (connections == nil) {
        connections = [NSMutableArray array];
    }

    if (![connections containsObject:endNode]) {
        [connections addObject:endNode];
    }
}

- (void)unlockConnectionFromNode:(JLFGKGraphNode2D *)startNode toNode:(JLFGKGraphNode2D *)endNode
{
    NSMutableArray *connections = [self.lockedConnections objectForKey:startNode];
    if (connections == nil) {
        return;
    }

    [connections removeObject:endNode];

    // TODO: Does unlocking a connection mean that it should be removed from startNode.connectedNodes?
}

- (BOOL)isConnectionLockedFromNode:(JLFGKGraphNode2D *)startNode toNode:(JLFGKGraphNode2D *)endNode
{
    NSArray *connections = [self.lockedConnections objectForKey:startNode];
    return [connections containsObject:endNode];
}

@end
