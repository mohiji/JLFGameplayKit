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
#import "JLFGKObstacleGraphUserNode.h"
#import "JLFGKObstacleGraphConnection.h"

@interface JLFGKObstacleGraph ()

@property (strong, nonatomic) NSMapTable *obstacleToNodes;
@property (assign, nonatomic) float bufferRadius;

@property (strong, nonatomic) NSMutableArray *userNodes;
@property (strong, nonatomic) NSMutableArray *lockedConnections;

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
        self.lockedConnections = [NSMutableArray array];
        self.userNodes = [NSMutableArray array];
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
    // The most straightforward way to do this is:
    //  - Remove all nodes. Start with a clean slate.
    //  - For each obstacle, connect all of its nodes together in a loop.
    //  - Again for each obstacle, connect each of its nodes to every other
    //    obstacle node that we can reach without intersecting an obstacle.
    //  - Finally, for each user connection (added with
    //    -connectNodeUsingObstacles:ignoringObstacles:)
    [self removeNodes:self.nodes];

    // Connect each obstacle's nodes together in a loop.
    NSArray *obstacles = [[self.obstacleToNodes keyEnumerator] allObjects];
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
    }

    // Run through the obstacle list again. This time, connect the nodes for the obstacle
    // to the nodes for every other obstacle. (not to its own nodes)
    //
    // Man, that's a lot of nested loops.
    for (JLFGKObstacle *obstacle in obstacles) {
        NSArray *obstacleNodes = [self.obstacleToNodes objectForKey:obstacle];

        for (JLFGKObstacle *otherObstacle in obstacles) {
            // Don't connect the obstacle to itself
            if (obstacle == otherObstacle) {
                continue;
            }

            for (JLFGKGraphNode2D *node in obstacleNodes) {
                NSMutableArray *connections = [NSMutableArray array];
                for (JLFGKGraphNode2D *otherNode in [self.obstacleToNodes objectForKey:otherObstacle]) {
                    if (![self anyObstaclesBetweenStart:node.position
                                                    end:otherNode.position]) {
                        [connections addObject:otherNode];
                    }
                }
                [node addConnectionsToNodes:connections bidirectional:YES];
            }
        }
    }

    // Connect the user nodes back up
    for (JLFGKObstacleGraphUserNode *userNode in self.userNodes) {
        [self realConnectNodeUsingObstacles:userNode.node ignoringObstacles:userNode.ignoredObstacles];
    }

    // Put any connections that the user specifically asked for (via locking) back in place.
    for (JLFGKObstacleGraphConnection *connection in self.lockedConnections) {
        [connection.from addConnectionsToNodes:@[connection.to] bidirectional:YES];
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
    JLFGKObstacleGraphUserNode *userNode = [[JLFGKObstacleGraphUserNode alloc] initWithNode:node
                                                                           ignoredObstacles:obstaclesToIgnore];
    [self.userNodes addObject:userNode];
    [self realConnectNodeUsingObstacles:node ignoringObstacles:obstaclesToIgnore];
}

- (void)realConnectNodeUsingObstacles:(JLFGKGraphNode2D *)node ignoringObstacles:(NSArray *)obstaclesToIgnore
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
                                       end:end]) {
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
{
    // This is horribly inefficient: it just loops through each obstacle comparing
    // each line segment that makes up the polygon with the start/end point. It
    // will bail out as soon as an intersection is found, but if there aren't any
    // intersections it has to go through the whole list.
    //
    // It should be augmented with a spatial partition of some kind, but for now
    // let's just get it working.
    for (JLFGKPolygonObstacle *obstacle in [self.obstacleToNodes keyEnumerator]) {
        NSArray *nodes = [self.obstacleToNodes objectForKey:obstacle];
        NSUInteger numNodes = nodes.count;
        for (NSUInteger i = 0; i < numNodes; i++) {
            JLFGKGraphNode2D *n1 = nodes[i];
            JLFGKGraphNode2D *n2 = nodes[(i + 1) % numNodes];

            if (line_segments_intersect(start, end, n1.position, n2.position)) {
                return YES;

            }
        }
    }
    return NO;
}

- (void)lockConnectionFromNode:(JLFGKGraphNode2D *)startNode toNode:(JLFGKGraphNode2D *)endNode
{
    for (JLFGKObstacleGraphConnection *connection in self.lockedConnections) {
        if (connection.from == startNode && connection.to == endNode) {
            // This connection is already locked.
            return;
        }
    }

    JLFGKObstacleGraphConnection *connection = [JLFGKObstacleGraphConnection connectionFromNode:startNode toNode:endNode];
    [self.lockedConnections addObject:connection];
}

- (void)unlockConnectionFromNode:(JLFGKGraphNode2D *)startNode toNode:(JLFGKGraphNode2D *)endNode
{
    NSMutableIndexSet *indices = [[NSMutableIndexSet alloc] init];
    NSUInteger numConnections = self.lockedConnections.count;
    for (NSUInteger i = 0; i < numConnections; i++) {
        JLFGKObstacleGraphConnection *conn = self.lockedConnections[i];
        if (conn.from == startNode && conn.to == endNode) {
            [indices addIndex:i];
        }
    }

    [self.lockedConnections removeObjectsAtIndexes:indices];
}

- (BOOL)isConnectionLockedFromNode:(JLFGKGraphNode2D *)startNode toNode:(JLFGKGraphNode2D *)endNode
{
    for (JLFGKObstacleGraphConnection *connection in self.lockedConnections) {
        if (connection.from == startNode && connection.to == endNode) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Overriden methods

- (void)removeNodes:(NSArray *)nodes
{
    [super removeNodes:nodes];

    NSUInteger numUserNodes = self.userNodes.count;
    NSMutableIndexSet *indices = [NSMutableIndexSet indexSet];

    for (JLFGKGraphNode2D *node in nodes) {
        for (NSUInteger i = 0; i < numUserNodes; i++) {
            JLFGKObstacleGraphUserNode *userNode = self.userNodes[i];
            if (userNode.node == node) {
                [indices addIndex:i];
            }
        }
    }

    [self.userNodes removeObjectsAtIndexes:indices];
}

@end
