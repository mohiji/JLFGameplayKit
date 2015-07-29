//
//  ObstacleTests.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/15/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "JLFGameplayKit.h"
#import "JLFGKObstacleGraph.h"
#import "JLFGKObstacleGraphConnection.h"

@interface ObstacleTests : XCTestCase

@end

@implementation ObstacleTests

- (void)testCreateCircles
{
    JLFGKCircleObstacle *circle = [JLFGKCircleObstacle obstacleWithRadius:10.0f];
    XCTAssertNotNil(circle);
    XCTAssertEqual(circle.radius, 10.0f);
}

- (void)testCreatePolygons
{
    vector_float2 vertices[] = {
        {10, 10},
        {12, 12},
        {14, 14}
    };

    JLFGKPolygonObstacle *polygon = [JLFGKPolygonObstacle obstacleWithPoints:vertices count:3];
    XCTAssertNotNil(polygon);
    XCTAssertEqual(polygon.vertexCount, 3);

    for (int i = 0; i < 3; i++) {
        vector_float2 vertex = [polygon vertexAtIndex:i];
        XCTAssertEqual(vertex.x, vertices[i].x);
        XCTAssertEqual(vertex.y, vertices[i].y);
    }
}

- (void)testCannotCreateEmptyPolygons
{
    vector_float2 vertices[] = {
        {10, 10},
        {12, 12},
        {14, 14}
    };

    XCTAssertThrows([JLFGKPolygonObstacle obstacleWithPoints:NULL count:0]);
    XCTAssertThrows([JLFGKPolygonObstacle obstacleWithPoints:vertices count:0]);
    XCTAssertThrows([JLFGKPolygonObstacle obstacleWithPoints:vertices count:1]);
    XCTAssertNoThrow([JLFGKPolygonObstacle obstacleWithPoints:vertices count:2]);
}


- (void)test2DNodeCreation
{
    XCTAssertThrows([[JLFGKGraphNode2D alloc] init]);

    JLFGKGraphNode2D *node = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){0, 0}];
    XCTAssertNotNil(node);
}

- (void)test2DNodeCosts
{
    JLFGKGraphNode2D *node1 = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){2, 2}];
    JLFGKGraphNode2D *node2 = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){2, 4}];

    float costNode1ToNode2 = [node1 costToNode:node2];
    float costNode2ToNode1 = [node2 costToNode:node1];
    XCTAssertEqual(costNode1ToNode2, 2.0f);
    XCTAssertEqual(costNode1ToNode2, costNode2ToNode1);
}

- (void)test2DNodeSimplePathfinding
{
    // I drew out a graph by hand on graph paper to set up this test. You'll just have to trust
    // that I did it right. :-P
    JLFGKGraphNode2D *n0, *n1, *n2, *n3, *n4, *n5, *n6, *n7, *n8, *n9, *n10, *n11, *n12;

    n0 = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){4, 15}];
    n1 = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){5, 7}];
    n2 = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){7, 11}];
    n3 = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){9, 18}];
    n4 = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){11, 5}];
    n5 = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){13, 10}];
    n6 = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){15, 19}];
    n7 = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){17, 16}];
    n8 = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){21, 12}];
    n9 = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){20, 8}];
    n10 = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){16, 3}];
    n11 = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){24, 4}];

    // This one's left unconnected to the rest.
    n12 = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){21, 19}];

    // These connections are all bidirectional, it's just easier for me to reason about if I lay them
    // all out explicity
    [n0 addConnectionsToNodes:@[n1, n2, n3] bidirectional:NO];
    [n1 addConnectionsToNodes:@[n0, n2, n4] bidirectional:NO];
    [n2 addConnectionsToNodes:@[n0, n1, n3, n4] bidirectional:NO];
    [n3 addConnectionsToNodes:@[n0, n2, n6] bidirectional:NO];
    [n4 addConnectionsToNodes:@[n1, n2, n5, n10] bidirectional:NO];
    [n5 addConnectionsToNodes:@[n2, n4, n7] bidirectional:NO];
    [n6 addConnectionsToNodes:@[n3, n7] bidirectional:NO];
    [n7 addConnectionsToNodes:@[n5, n6] bidirectional:NO];
    [n8 addConnectionsToNodes:@[n9, n11] bidirectional:NO];
    [n9 addConnectionsToNodes:@[n8, n10, n11] bidirectional:NO];
    [n10 addConnectionsToNodes:@[n4, n9, n11] bidirectional:NO];
    [n11 addConnectionsToNodes:@[n8, n9, n10] bidirectional:NO];

    NSArray *path = [n0 findPathToNode:n7];
    XCTAssertEqual(path.count, 4);
    XCTAssertEqualObjects(path[0], n0);
    XCTAssertEqualObjects(path[1], n3);
    XCTAssertEqualObjects(path[2], n6);
    XCTAssertEqualObjects(path[3], n7);

    path = [n0 findPathToNode:n8];
    XCTAssertEqual(path.count, 6);
    XCTAssertEqualObjects(path[0], n0);
    XCTAssertEqualObjects(path[1], n2);
    XCTAssertEqualObjects(path[2], n4);
    XCTAssertEqualObjects(path[3], n10);
    XCTAssertEqualObjects(path[4], n9);
    XCTAssertEqualObjects(path[5], n8);

    path = [n0 findPathToNode:n12];
    XCTAssertNil(path);
}

- (void)testObstacleGraphNoObstacles
{
    int numNodes = 5;
    NSMutableArray *nodes = [NSMutableArray arrayWithCapacity:numNodes];

    JLFGKObstacleGraph *graph = [JLFGKObstacleGraph graphWithObstacles:@[] bufferRadius:10.0f];

    for (int i = 0; i < numNodes; i++) {
        int x = arc4random_uniform(50) - 50;
        int y = arc4random_uniform(50) - 50;
        JLFGKGraphNode2D *node = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){x, y}];
        [graph connectNodeUsingObstacles:node];
        [nodes addObject:node];
    }

    XCTAssertEqual(graph.nodes.count, numNodes);
    for (JLFGKGraphNode2D *node in nodes) {
        XCTAssertEqual(node.connectedNodes.count, numNodes - 1);
        for (JLFGKGraphNode *other in nodes) {
            if (node == other) {
                continue;
            }

            XCTAssertTrue([node.connectedNodes containsObject:other]);

            NSArray *path = [graph findPathFromNode:node toNode:other];
            XCTAssertNotNil(path);
            XCTAssertEqual(path.count, 2);
            XCTAssertEqualObjects([path firstObject], node);
            XCTAssertEqualObjects([path lastObject], other);
        }
    }
}

- (void)testObstacleGraphAddObstacles
{
    vector_float2 points1[] = {
        {7, 12},
        {5, 9},
        {6, 6},
        {8, 6},
        {9, 9}
    };

    vector_float2 points2[] = {
        {10, 17},
        {21, 17},
        {21, 20},
        {10, 20}
    };

    JLFGKPolygonObstacle *obstacle1 = [JLFGKPolygonObstacle obstacleWithPoints:points1 count:5];
    JLFGKPolygonObstacle *obstacle2 = [JLFGKPolygonObstacle obstacleWithPoints:points2 count:4];

    JLFGKObstacleGraph *graph = [JLFGKObstacleGraph graphWithObstacles:@[obstacle1]
                                                          bufferRadius:1.0f];

    // Each obstacle's nodes should be connected in a loop around the obstacle.
    NSArray *nodes1 = [graph nodesForObstacle:obstacle1];
    XCTAssertEqual(nodes1.count, 5);
    for (int i = 0; i < nodes1.count; i++) {
        JLFGKGraphNode2D *current = nodes1[i];
        JLFGKGraphNode2D *previous = nodes1[(i + nodes1.count - 1) % nodes1.count];
        JLFGKGraphNode2D *next = nodes1[(i + 1) % nodes1.count];

        XCTAssertEqual(current.connectedNodes.count, 2);
        XCTAssertTrue([current.connectedNodes containsObject:previous]);
        XCTAssertTrue([current.connectedNodes containsObject:next]);
    }

    [graph addObstacles:@[obstacle2]];
    XCTAssertEqual(graph.nodes.count, 9);

    NSArray *nodes2 = [graph nodesForObstacle:obstacle2];
    XCTAssertEqual(nodes2.count, 4);

    JLFGKGraphNode2D *n0 = nodes1[0];
    JLFGKGraphNode2D *n1 = nodes1[1];
    JLFGKGraphNode2D *n2 = nodes1[2];
    JLFGKGraphNode2D *n3 = nodes1[3];
    JLFGKGraphNode2D *n4 = nodes1[4];
    JLFGKGraphNode2D *n5 = nodes2[0];
    JLFGKGraphNode2D *n6 = nodes2[1];
    JLFGKGraphNode2D *n7 = nodes2[2];
    JLFGKGraphNode2D *n8 = nodes2[3];

    NSLog(@"n0 -> n6: {%.5f, %.5f} -> {%.5f, %.5f}", n0.position.x, n0.position.y, n6.position.x, n6.position.y);

    XCTAssertEqual([n0.connectedNodes containsObject:n0], NO);
    XCTAssertEqual([n0.connectedNodes containsObject:n1], YES);
    XCTAssertEqual([n0.connectedNodes containsObject:n2], NO);
    XCTAssertEqual([n0.connectedNodes containsObject:n3], NO);
    XCTAssertEqual([n0.connectedNodes containsObject:n4], YES);
    XCTAssertEqual([n0.connectedNodes containsObject:n5], YES);
    XCTAssertEqual([n0.connectedNodes containsObject:n6], YES);
    XCTAssertEqual([n0.connectedNodes containsObject:n7], NO);
    XCTAssertEqual([n0.connectedNodes containsObject:n8], YES);

    XCTAssertEqual([n1.connectedNodes containsObject:n0], YES);
    XCTAssertEqual([n1.connectedNodes containsObject:n1], NO);
    XCTAssertEqual([n1.connectedNodes containsObject:n2], YES);
    XCTAssertEqual([n1.connectedNodes containsObject:n3], NO);
    XCTAssertEqual([n1.connectedNodes containsObject:n4], NO);
    XCTAssertEqual([n1.connectedNodes containsObject:n5], YES);
    XCTAssertEqual([n1.connectedNodes containsObject:n6], NO);
    XCTAssertEqual([n1.connectedNodes containsObject:n7], NO);
    XCTAssertEqual([n1.connectedNodes containsObject:n8], YES);

    XCTAssertEqual([n2.connectedNodes containsObject:n0], NO);
    XCTAssertEqual([n2.connectedNodes containsObject:n1], YES);
    XCTAssertEqual([n2.connectedNodes containsObject:n2], NO);
    XCTAssertEqual([n2.connectedNodes containsObject:n3], YES);
    XCTAssertEqual([n2.connectedNodes containsObject:n4], NO);
    XCTAssertEqual([n2.connectedNodes containsObject:n5], NO);
    XCTAssertEqual([n2.connectedNodes containsObject:n6], NO);
    XCTAssertEqual([n2.connectedNodes containsObject:n7], NO);
    XCTAssertEqual([n2.connectedNodes containsObject:n8], NO);

    XCTAssertEqual([n3.connectedNodes containsObject:n0], NO);
    XCTAssertEqual([n3.connectedNodes containsObject:n1], NO);
    XCTAssertEqual([n3.connectedNodes containsObject:n2], YES);
    XCTAssertEqual([n3.connectedNodes containsObject:n3], NO);
    XCTAssertEqual([n3.connectedNodes containsObject:n4], YES);
    XCTAssertEqual([n3.connectedNodes containsObject:n5], NO);
    XCTAssertEqual([n3.connectedNodes containsObject:n6], YES);
    XCTAssertEqual([n3.connectedNodes containsObject:n7], NO);
    XCTAssertEqual([n3.connectedNodes containsObject:n8], NO);

    XCTAssertEqual([n4.connectedNodes containsObject:n0], YES);
    XCTAssertEqual([n4.connectedNodes containsObject:n1], NO);
    XCTAssertEqual([n4.connectedNodes containsObject:n2], NO);
    XCTAssertEqual([n4.connectedNodes containsObject:n3], YES);
    XCTAssertEqual([n4.connectedNodes containsObject:n4], NO);
    XCTAssertEqual([n4.connectedNodes containsObject:n5], YES);
    XCTAssertEqual([n4.connectedNodes containsObject:n6], YES);
    XCTAssertEqual([n4.connectedNodes containsObject:n7], NO);
    XCTAssertEqual([n4.connectedNodes containsObject:n8], NO);

    XCTAssertEqual([n5.connectedNodes containsObject:n0], YES);
    XCTAssertEqual([n5.connectedNodes containsObject:n1], YES);
    XCTAssertEqual([n5.connectedNodes containsObject:n2], NO);
    XCTAssertEqual([n5.connectedNodes containsObject:n3], NO);
    XCTAssertEqual([n5.connectedNodes containsObject:n4], YES);
    XCTAssertEqual([n5.connectedNodes containsObject:n5], NO);
    XCTAssertEqual([n5.connectedNodes containsObject:n6], YES);
    XCTAssertEqual([n5.connectedNodes containsObject:n7], NO);
    XCTAssertEqual([n5.connectedNodes containsObject:n8], YES);

    XCTAssertEqual([n6.connectedNodes containsObject:n0], YES);
    XCTAssertEqual([n6.connectedNodes containsObject:n1], NO);
    XCTAssertEqual([n6.connectedNodes containsObject:n2], NO);
    XCTAssertEqual([n6.connectedNodes containsObject:n3], YES);
    XCTAssertEqual([n6.connectedNodes containsObject:n4], YES);
    XCTAssertEqual([n6.connectedNodes containsObject:n5], YES);
    XCTAssertEqual([n6.connectedNodes containsObject:n6], NO);
    XCTAssertEqual([n6.connectedNodes containsObject:n7], YES);
    XCTAssertEqual([n6.connectedNodes containsObject:n8], NO);

    XCTAssertEqual([n7.connectedNodes containsObject:n0], NO);
    XCTAssertEqual([n7.connectedNodes containsObject:n1], NO);
    XCTAssertEqual([n7.connectedNodes containsObject:n2], NO);
    XCTAssertEqual([n7.connectedNodes containsObject:n3], NO);
    XCTAssertEqual([n7.connectedNodes containsObject:n4], NO);
    XCTAssertEqual([n7.connectedNodes containsObject:n5], NO);
    XCTAssertEqual([n7.connectedNodes containsObject:n6], YES);
    XCTAssertEqual([n7.connectedNodes containsObject:n7], NO);
    XCTAssertEqual([n7.connectedNodes containsObject:n8], YES);

    XCTAssertEqual([n8.connectedNodes containsObject:n0], YES);
    XCTAssertEqual([n8.connectedNodes containsObject:n1], YES);
    XCTAssertEqual([n8.connectedNodes containsObject:n2], NO);
    XCTAssertEqual([n8.connectedNodes containsObject:n3], NO);
    XCTAssertEqual([n8.connectedNodes containsObject:n4], NO);
    XCTAssertEqual([n8.connectedNodes containsObject:n5], YES);
    XCTAssertEqual([n8.connectedNodes containsObject:n6], NO);
    XCTAssertEqual([n8.connectedNodes containsObject:n7], YES);
    XCTAssertEqual([n8.connectedNodes containsObject:n8], NO);
}

- (void)testObstacleGraphConnectNodes
{
    vector_float2 points1[] = {
        {7, 12},
        {5, 9},
        {6, 6},
        {8, 6},
        {9, 9}
    };

    vector_float2 points2[] = {
        {10, 17},
        {21, 17},
        {21, 20},
        {10, 20}
    };

    JLFGKPolygonObstacle *obstacle1 = [JLFGKPolygonObstacle obstacleWithPoints:points1 count:5];
    JLFGKPolygonObstacle *obstacle2 = [JLFGKPolygonObstacle obstacleWithPoints:points2 count:4];

    JLFGKObstacleGraph *graph = [JLFGKObstacleGraph graphWithObstacles:@[obstacle1, obstacle2]
                                                          bufferRadius:1.0f];

    JLFGKGraphNode2D *node = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){4, 19}];
    [graph connectNodeUsingObstacles:node ignoringObstacles:@[]];
    XCTAssertEqual(graph.nodes.count, 10);
    XCTAssertEqual(node.connectedNodes.count, 5);

    NSArray *nodes1 = [graph nodesForObstacle:obstacle1];
    NSArray *nodes2 = [graph nodesForObstacle:obstacle2];

    JLFGKGraphNode2D *n0 = nodes1[0];
    JLFGKGraphNode2D *n1 = nodes1[1];
    JLFGKGraphNode2D *n2 = nodes1[2];
    JLFGKGraphNode2D *n3 = nodes1[3];
    JLFGKGraphNode2D *n4 = nodes1[4];
    JLFGKGraphNode2D *n5 = nodes2[0];
    JLFGKGraphNode2D *n6 = nodes2[1];
    JLFGKGraphNode2D *n7 = nodes2[2];
    JLFGKGraphNode2D *n8 = nodes2[3];

    XCTAssertEqual([node.connectedNodes containsObject:n0], YES);
    XCTAssertEqual([node.connectedNodes containsObject:n1], YES);
    XCTAssertEqual([node.connectedNodes containsObject:n2], NO);
    XCTAssertEqual([node.connectedNodes containsObject:n3], NO);
    XCTAssertEqual([node.connectedNodes containsObject:n4], YES);
    XCTAssertEqual([node.connectedNodes containsObject:n5], YES);
    XCTAssertEqual([node.connectedNodes containsObject:n6], NO);
    XCTAssertEqual([node.connectedNodes containsObject:n7], NO);
    XCTAssertEqual([node.connectedNodes containsObject:n8], YES);
}

- (void)testObstacleGraphConnectNodesIgnoringObstacles
{
    vector_float2 points1[] = {
        {7, 12},
        {5, 9},
        {6, 6},
        {8, 6},
        {9, 9}
    };

    vector_float2 points2[] = {
        {10, 17},
        {21, 17},
        {21, 20},
        {10, 20}
    };

    JLFGKPolygonObstacle *obstacle1 = [JLFGKPolygonObstacle obstacleWithPoints:points1 count:5];
    JLFGKPolygonObstacle *obstacle2 = [JLFGKPolygonObstacle obstacleWithPoints:points2 count:4];

    JLFGKObstacleGraph *graph = [JLFGKObstacleGraph graphWithObstacles:@[obstacle1, obstacle2]
                                                          bufferRadius:1.0f];

    JLFGKGraphNode2D *node = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){4, 6}];
    [graph connectNodeUsingObstacles:node ignoringObstacles:@[obstacle1]];
    XCTAssertEqual(graph.nodes.count, 10);
    XCTAssertEqual(node.connectedNodes.count, 8);

    NSArray *nodes1 = [graph nodesForObstacle:obstacle1];
    NSArray *nodes2 = [graph nodesForObstacle:obstacle2];

    JLFGKGraphNode2D *n0 = nodes1[0];
    JLFGKGraphNode2D *n1 = nodes1[1];
    JLFGKGraphNode2D *n2 = nodes1[2];
    JLFGKGraphNode2D *n3 = nodes1[3];
    JLFGKGraphNode2D *n4 = nodes1[4];
    JLFGKGraphNode2D *n5 = nodes2[0];
    JLFGKGraphNode2D *n6 = nodes2[1];
    JLFGKGraphNode2D *n7 = nodes2[2];
    JLFGKGraphNode2D *n8 = nodes2[3];

    XCTAssertEqual([node.connectedNodes containsObject:n0], YES);
    XCTAssertEqual([node.connectedNodes containsObject:n1], YES);
    XCTAssertEqual([node.connectedNodes containsObject:n2], YES);
    XCTAssertEqual([node.connectedNodes containsObject:n3], YES);
    XCTAssertEqual([node.connectedNodes containsObject:n4], YES);
    XCTAssertEqual([node.connectedNodes containsObject:n5], YES);
    XCTAssertEqual([node.connectedNodes containsObject:n6], YES);
    XCTAssertEqual([node.connectedNodes containsObject:n7], NO);
    XCTAssertEqual([node.connectedNodes containsObject:n8], YES);
}

- (void)testObstacleGraphLockedNodes
{
    vector_float2 points1[] = {
        {7, 12},
        {5, 9},
        {6, 6},
        {8, 6},
        {9, 9}
    };

    JLFGKPolygonObstacle *obstacle1 = [JLFGKPolygonObstacle obstacleWithPoints:points1 count:5];
    JLFGKObstacleGraph *graph = [JLFGKObstacleGraph graphWithObstacles:@[]
                                                          bufferRadius:1.0f];

    JLFGKGraphNode2D *node1 = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){4, 6}];
    JLFGKGraphNode2D *node2 = [JLFGKGraphNode2D nodeWithPoint:(vector_float2){12, 13}];
    [node1 addConnectionsToNodes:@[node2] bidirectional:YES];
    [graph addNodes:@[node1, node2]];
    [graph lockConnectionFromNode:node1 toNode:node2];
    XCTAssertTrue([node1.connectedNodes containsObject:node2]);

    [graph addObstacles:@[obstacle1]];
    XCTAssertTrue([node1.connectedNodes containsObject:node2]);

    NSArray *path = [graph findPathFromNode:node1 toNode:node2];
    XCTAssertEqual(path.count, 2);
    XCTAssertEqual(path[0], node1);
    XCTAssertEqual(path[1], node2);

    XCTAssertTrue([graph isConnectionLockedFromNode:node1 toNode:node2]);
    [graph unlockConnectionFromNode:node1 toNode:node2];
    XCTAssertFalse([graph isConnectionLockedFromNode:node1 toNode:node2]);

    [graph removeObstacles:@[obstacle1]];
    [graph addObstacles:@[obstacle1]];

    XCTAssertFalse([node1.connectedNodes containsObject:node2]);
    [node1 removeConnectionsToNodes:@[node2] bidirectional:YES];
    XCTAssertFalse([node1.connectedNodes containsObject:node2]);
}

@end
