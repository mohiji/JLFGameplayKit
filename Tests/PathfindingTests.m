//
//  PathfindingTests.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/2/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "JLFGKGraphNode.h"
#import "JLFGKGraph.h"
#import "JLFGKGridGraph.h"

@interface PathfindingTests : XCTestCase
@end

@implementation PathfindingTests

- (void)testConnectingToNodesOneWay
{
    JLFGKGraphNode *n1, *n2, *n3, *n4, *n5, *n6;

    n1 = [[JLFGKGraphNode alloc] init];
    n2 = [[JLFGKGraphNode alloc] init];
    n3 = [[JLFGKGraphNode alloc] init];
    n4 = [[JLFGKGraphNode alloc] init];
    n5 = [[JLFGKGraphNode alloc] init];
    n6 = [[JLFGKGraphNode alloc] init];

    [n1 addConnectionsToNodes:@[n2, n3, n4] bidirectional:NO];
    [n2 addConnectionsToNodes:@[n5, n6] bidirectional:NO];

    XCTAssert([n1.connectedNodes containsObject:n2]);
    XCTAssert([n1.connectedNodes containsObject:n3]);
    XCTAssert([n1.connectedNodes containsObject:n4]);
    XCTAssert([n2.connectedNodes containsObject:n5]);
    XCTAssert([n2.connectedNodes containsObject:n6]);

    XCTAssertFalse([n2.connectedNodes containsObject:n1]);
    XCTAssertFalse([n3.connectedNodes containsObject:n1]);
    XCTAssertFalse([n4.connectedNodes containsObject:n1]);
    XCTAssertFalse([n5.connectedNodes containsObject:n2]);
    XCTAssertFalse([n6.connectedNodes containsObject:n2]);
}

- (void)testConnectingToNodesBidirectional
{
    JLFGKGraphNode *n1, *n2, *n3, *n4, *n5, *n6;

    n1 = [[JLFGKGraphNode alloc] init];
    n2 = [[JLFGKGraphNode alloc] init];
    n3 = [[JLFGKGraphNode alloc] init];
    n4 = [[JLFGKGraphNode alloc] init];
    n5 = [[JLFGKGraphNode alloc] init];
    n6 = [[JLFGKGraphNode alloc] init];

    [n1 addConnectionsToNodes:@[n2, n3, n4] bidirectional:YES];
    [n2 addConnectionsToNodes:@[n5, n6] bidirectional:NO];

    XCTAssert([n1.connectedNodes containsObject:n2]);
    XCTAssert([n1.connectedNodes containsObject:n3]);
    XCTAssert([n1.connectedNodes containsObject:n4]);
    XCTAssert([n2.connectedNodes containsObject:n5]);
    XCTAssert([n2.connectedNodes containsObject:n6]);

    XCTAssert([n2.connectedNodes containsObject:n1]);
    XCTAssert([n3.connectedNodes containsObject:n1]);
    XCTAssert([n4.connectedNodes containsObject:n1]);
    XCTAssertFalse([n5.connectedNodes containsObject:n2]);
    XCTAssertFalse([n6.connectedNodes containsObject:n2]);
}

- (void)testRemoveConnectionsToNodes
{
    JLFGKGraphNode *n1, *n2, *n3, *n4, *n5, *n6;

    n1 = [[JLFGKGraphNode alloc] init];
    n2 = [[JLFGKGraphNode alloc] init];
    n3 = [[JLFGKGraphNode alloc] init];
    n4 = [[JLFGKGraphNode alloc] init];
    n5 = [[JLFGKGraphNode alloc] init];
    n6 = [[JLFGKGraphNode alloc] init];

    [n1 addConnectionsToNodes:@[n2, n3, n4] bidirectional:YES];
    [n2 addConnectionsToNodes:@[n5, n6] bidirectional:YES];
    [n2 removeConnectionsToNodes:@[n5] bidirectional:NO];

    XCTAssert([n1.connectedNodes containsObject:n2]);
    XCTAssert([n1.connectedNodes containsObject:n3]);
    XCTAssert([n1.connectedNodes containsObject:n4]);
    XCTAssertFalse([n2.connectedNodes containsObject:n5]);
    XCTAssert([n2.connectedNodes containsObject:n6]);

    XCTAssert([n2.connectedNodes containsObject:n1]);
    XCTAssert([n3.connectedNodes containsObject:n1]);
    XCTAssert([n4.connectedNodes containsObject:n1]);
    XCTAssert([n5.connectedNodes containsObject:n2]);
    XCTAssert([n6.connectedNodes containsObject:n2]);
}

- (void)testCostsAreCorrect
{
    JLFGKGraphNode *n1, *n2;

    n1 = [[JLFGKGraphNode alloc] init];
    n2 = [[JLFGKGraphNode alloc] init];

    [n1 addConnectionsToNodes:@[n2] bidirectional:NO];
    XCTAssertEqual(1.0f, [n1 costToNode:n2]);
    XCTAssertEqual(FLT_MAX, [n2 costToNode:n1]);
}

- (void)testFindSimplePath
{
    JLFGKGraphNode *n1, *n2, *n3, *n4, *n5, *n6;

    n1 = [[JLFGKGraphNode alloc] init];
    n2 = [[JLFGKGraphNode alloc] init];
    n3 = [[JLFGKGraphNode alloc] init];
    n4 = [[JLFGKGraphNode alloc] init];
    n5 = [[JLFGKGraphNode alloc] init];
    n6 = [[JLFGKGraphNode alloc] init];

    [n1 addConnectionsToNodes:@[n2, n3, n4] bidirectional:YES];
    [n2 addConnectionsToNodes:@[n5, n6] bidirectional:YES];

    NSArray *path = [n1 findPathToNode:n6];
    XCTAssertNotNil(path);
    XCTAssertEqual(path.count, 3);
    XCTAssertEqual(path[0], n1);
    XCTAssertEqual(path[1], n2);
    XCTAssertEqual(path[2], n6);
}

- (void)testFindMoreComplexPath
{
    JLFGKGraphNode *n1, *n2, *n3, *n4, *n5, *n6;

    n1 = [[JLFGKGraphNode alloc] init];
    n2 = [[JLFGKGraphNode alloc] init];
    n3 = [[JLFGKGraphNode alloc] init];
    n4 = [[JLFGKGraphNode alloc] init];
    n5 = [[JLFGKGraphNode alloc] init];
    n6 = [[JLFGKGraphNode alloc] init];

    for (JLFGKGraphNode *node in @[n1, n2, n3, n4, n5, n6]) {
        NSMutableArray *moreNodes = [NSMutableArray array];
        for (int i = 0; i < 12; i++) {
            [moreNodes addObject:[[JLFGKGraphNode alloc] init]];
        }

        [node addConnectionsToNodes:moreNodes bidirectional:YES];
    }

    [n1.connectedNodes[1] addConnectionsToNodes:@[n2] bidirectional:YES];
    [n2.connectedNodes[2] addConnectionsToNodes:@[n3] bidirectional:YES];
    [n3.connectedNodes[3] addConnectionsToNodes:@[n4] bidirectional:YES];
    [n4.connectedNodes[4] addConnectionsToNodes:@[n5] bidirectional:YES];
    [n5.connectedNodes[5] addConnectionsToNodes:@[n6] bidirectional:YES];

    NSArray *path = [n1 findPathToNode:n6];
    XCTAssertNotNil(path);
    XCTAssertEqual(path.count, 11);
    XCTAssertEqual(path[0], n1);
    XCTAssertEqual(path[1], n1.connectedNodes[1]);
    XCTAssertEqual(path[2], n2);
    XCTAssertEqual(path[3], n2.connectedNodes[2]);
    XCTAssertEqual(path[4], n3);
    XCTAssertEqual(path[5], n3.connectedNodes[3]);
    XCTAssertEqual(path[6], n4);
    XCTAssertEqual(path[7], n4.connectedNodes[4]);
    XCTAssertEqual(path[8], n5);
    XCTAssertEqual(path[9], n5.connectedNodes[5]);
    XCTAssertEqual(path[10], n6);
}

- (void)testFindPathsInDirectedGraph
{
    JLFGKGraphNode *n1, *n2, *n3, *n4, *n5, *n6;

    n1 = [[JLFGKGraphNode alloc] init];
    n2 = [[JLFGKGraphNode alloc] init];
    n3 = [[JLFGKGraphNode alloc] init];
    n4 = [[JLFGKGraphNode alloc] init];
    n5 = [[JLFGKGraphNode alloc] init];
    n6 = [[JLFGKGraphNode alloc] init];

    [n1 addConnectionsToNodes:@[n2, n3] bidirectional:YES];
    [n2 addConnectionsToNodes:@[n5] bidirectional:YES];
    [n3 addConnectionsToNodes:@[n4] bidirectional:NO];
    [n4 addConnectionsToNodes:@[n6] bidirectional:NO];
    [n6 addConnectionsToNodes:@[n5] bidirectional:NO];

    NSArray *n1_n6 = [n1 findPathToNode:n6];
    NSArray *n6_n1 = [n1 findPathFromNode:n6];

    XCTAssertNotNil(n1_n6);
    XCTAssertEqual(n1_n6.count, 4);
    XCTAssertEqual(n1_n6[0], n1);
    XCTAssertEqual(n1_n6[1], n3);
    XCTAssertEqual(n1_n6[2], n4);
    XCTAssertEqual(n1_n6[3], n6);

    XCTAssertNotNil(n6_n1);
    XCTAssertEqual(n6_n1.count, 4);
    XCTAssertEqual(n6_n1[0], n6);
    XCTAssertEqual(n6_n1[1], n5);
    XCTAssertEqual(n6_n1[2], n2);
    XCTAssertEqual(n6_n1[3], n1);
}

- (void)testNoDuplicateConnections
{
    JLFGKGraphNode *n1, *n2;

    n1 = [[JLFGKGraphNode alloc] init];
    n2 = [[JLFGKGraphNode alloc] init];

    [n1 addConnectionsToNodes:@[n2] bidirectional:YES];
    [n2 addConnectionsToNodes:@[n1] bidirectional:YES];
    XCTAssertEqual(n1.connectedNodes.count, 1);
    XCTAssertEqual(n2.connectedNodes.count, 1);
}

- (void)testCantConnectNodeToItself
{
    JLFGKGraphNode *n1 = [[JLFGKGraphNode alloc] init];
    [n1 addConnectionsToNodes:@[n1] bidirectional:YES];
    XCTAssertEqual(n1.connectedNodes.count, 0);
}

- (void)testRemovingNodesFromGraphRemovesConnections
{
    JLFGKGraphNode *n1, *n2, *n3;

    n1 = [[JLFGKGraphNode alloc] init];
    n2 = [[JLFGKGraphNode alloc] init];
    n3 = [[JLFGKGraphNode alloc] init];

    [n1 addConnectionsToNodes:@[n2, n3] bidirectional:YES];
    JLFGKGraph *graph = [JLFGKGraph graphWithNodes:@[n1, n2]];

    XCTAssertEqual([n1.connectedNodes containsObject:n2], YES);
    XCTAssertEqual([n1.connectedNodes containsObject:n3], YES);
    [graph removeNodes:@[n2]];

    XCTAssertEqual([n1.connectedNodes containsObject:n2], NO);
    XCTAssertEqual([n2.connectedNodes containsObject:n1], NO);
    XCTAssertEqual([n1.connectedNodes containsObject:n3], YES);
    XCTAssertEqual([n3.connectedNodes containsObject:n1], YES);
}

- (void)testGridGraphProperties
{
    JLFGKGridGraph *graph = [JLFGKGridGraph graphFromGridStartingAt:(vector_int2){-3, -7}
                                                              width:3
                                                             height:3
                                                   diagonalsAllowed:YES];

    XCTAssertEqual(graph.gridOrigin.x, -3);
    XCTAssertEqual(graph.gridOrigin.y, -7);
    XCTAssertEqual(graph.gridWidth, 3);
    XCTAssertEqual(graph.gridHeight, 3);
    XCTAssertEqual(graph.diagonalsAllowed, YES);
}

- (void)testGridGraphNodeLookup
{
    JLFGKGridGraph *originGraph = [JLFGKGridGraph graphFromGridStartingAt:(vector_int2){0, 0}
                                                                    width:3
                                                                   height:3
                                                         diagonalsAllowed:NO];

    for (int x = 0; x < 3; x++) {
        for (int y = 0; y < 3; y++) {
            JLFGKGridGraphNode *node = [originGraph nodeAtGridPosition:(vector_int2){x, y}];
            XCTAssertEqual(node.position.x, x);
            XCTAssertEqual(node.position.y, y);
        }
    }

    JLFGKGridGraphNode *invalidNode = [originGraph nodeAtGridPosition:(vector_int2){-1, 0}];
    XCTAssertNil(invalidNode);
    invalidNode = [originGraph nodeAtGridPosition:(vector_int2){3, 0}];
    XCTAssertNil(invalidNode);
    invalidNode = [originGraph nodeAtGridPosition:(vector_int2){1, -1}];
    XCTAssertNil(invalidNode);
    invalidNode = [originGraph nodeAtGridPosition:(vector_int2){1, 3}];
    XCTAssertNil(invalidNode);

    JLFGKGridGraph *notOriginGraph = [JLFGKGridGraph graphFromGridStartingAt:(vector_int2){-7, 10}
                                                                       width:3
                                                                      height:3
                                                            diagonalsAllowed:NO];

    for (int x = -7; x < -4; x++) {
        for (int y = 10; y < 13; y++) {
            JLFGKGridGraphNode *node = [notOriginGraph nodeAtGridPosition:(vector_int2){x, y}];
            XCTAssertEqual(node.position.x, x);
            XCTAssertEqual(node.position.y, y);
        }
    }

    invalidNode = [notOriginGraph nodeAtGridPosition:(vector_int2){-8, 11}];
    XCTAssertNil(invalidNode);
    invalidNode = [notOriginGraph nodeAtGridPosition:(vector_int2){-4, 11}];
    XCTAssertNil(invalidNode);
    invalidNode = [notOriginGraph nodeAtGridPosition:(vector_int2){-5, 9}];
    XCTAssertNil(invalidNode);
    invalidNode = [notOriginGraph nodeAtGridPosition:(vector_int2){-5, 13}];
    XCTAssertNil(invalidNode);
}

- (void)testGridGraphCreatedFullyConnectedNoDiagonals
{
    JLFGKGridGraph *graph = [JLFGKGridGraph graphFromGridStartingAt:(vector_int2){0, 0}
                                                              width:3
                                                             height:3
                                                   diagonalsAllowed:NO];

    XCTAssertNotNil(graph);
    XCTAssertEqual(graph.nodes.count, 9);

    JLFGKGridGraphNode *n00 = [graph nodeAtGridPosition:(vector_int2){0, 0}];
    JLFGKGridGraphNode *n01 = [graph nodeAtGridPosition:(vector_int2){0, 1}];
    JLFGKGridGraphNode *n02 = [graph nodeAtGridPosition:(vector_int2){0, 2}];
    JLFGKGridGraphNode *n10 = [graph nodeAtGridPosition:(vector_int2){1, 0}];
    JLFGKGridGraphNode *n11 = [graph nodeAtGridPosition:(vector_int2){1, 1}];
    JLFGKGridGraphNode *n12 = [graph nodeAtGridPosition:(vector_int2){1, 2}];
    JLFGKGridGraphNode *n20 = [graph nodeAtGridPosition:(vector_int2){2, 0}];
    JLFGKGridGraphNode *n21 = [graph nodeAtGridPosition:(vector_int2){2, 1}];
    JLFGKGridGraphNode *n22 = [graph nodeAtGridPosition:(vector_int2){2, 2}];

    XCTAssertEqual([n00.connectedNodes containsObject:n00], NO);
    XCTAssertEqual([n00.connectedNodes containsObject:n10], YES);
    XCTAssertEqual([n00.connectedNodes containsObject:n20], NO);
    XCTAssertEqual([n00.connectedNodes containsObject:n01], YES);
    XCTAssertEqual([n00.connectedNodes containsObject:n11], NO);
    XCTAssertEqual([n00.connectedNodes containsObject:n21], NO);
    XCTAssertEqual([n00.connectedNodes containsObject:n02], NO);
    XCTAssertEqual([n00.connectedNodes containsObject:n12], NO);
    XCTAssertEqual([n00.connectedNodes containsObject:n22], NO);

    XCTAssertEqual([n10.connectedNodes containsObject:n00], YES);
    XCTAssertEqual([n10.connectedNodes containsObject:n10], NO);
    XCTAssertEqual([n10.connectedNodes containsObject:n20], YES);
    XCTAssertEqual([n10.connectedNodes containsObject:n01], NO);
    XCTAssertEqual([n10.connectedNodes containsObject:n11], YES);
    XCTAssertEqual([n10.connectedNodes containsObject:n21], NO);
    XCTAssertEqual([n10.connectedNodes containsObject:n02], NO);
    XCTAssertEqual([n10.connectedNodes containsObject:n12], NO);
    XCTAssertEqual([n10.connectedNodes containsObject:n22], NO);

    XCTAssertEqual([n20.connectedNodes containsObject:n00], NO);
    XCTAssertEqual([n20.connectedNodes containsObject:n10], YES);
    XCTAssertEqual([n20.connectedNodes containsObject:n20], NO);
    XCTAssertEqual([n20.connectedNodes containsObject:n01], NO);
    XCTAssertEqual([n20.connectedNodes containsObject:n11], NO);
    XCTAssertEqual([n20.connectedNodes containsObject:n21], YES);
    XCTAssertEqual([n20.connectedNodes containsObject:n02], NO);
    XCTAssertEqual([n20.connectedNodes containsObject:n12], NO);
    XCTAssertEqual([n20.connectedNodes containsObject:n22], NO);

    XCTAssertEqual([n01.connectedNodes containsObject:n00], YES);
    XCTAssertEqual([n01.connectedNodes containsObject:n10], NO);
    XCTAssertEqual([n01.connectedNodes containsObject:n20], NO);
    XCTAssertEqual([n01.connectedNodes containsObject:n01], NO);
    XCTAssertEqual([n01.connectedNodes containsObject:n11], YES);
    XCTAssertEqual([n01.connectedNodes containsObject:n21], NO);
    XCTAssertEqual([n01.connectedNodes containsObject:n02], YES);
    XCTAssertEqual([n01.connectedNodes containsObject:n12], NO);
    XCTAssertEqual([n01.connectedNodes containsObject:n22], NO);

    XCTAssertEqual([n11.connectedNodes containsObject:n00], NO);
    XCTAssertEqual([n11.connectedNodes containsObject:n10], YES);
    XCTAssertEqual([n11.connectedNodes containsObject:n20], NO);
    XCTAssertEqual([n11.connectedNodes containsObject:n01], YES);
    XCTAssertEqual([n11.connectedNodes containsObject:n11], NO);
    XCTAssertEqual([n11.connectedNodes containsObject:n21], YES);
    XCTAssertEqual([n11.connectedNodes containsObject:n02], NO);
    XCTAssertEqual([n11.connectedNodes containsObject:n12], YES);
    XCTAssertEqual([n11.connectedNodes containsObject:n22], NO);

    XCTAssertEqual([n21.connectedNodes containsObject:n00], NO);
    XCTAssertEqual([n21.connectedNodes containsObject:n10], NO);
    XCTAssertEqual([n21.connectedNodes containsObject:n20], YES);
    XCTAssertEqual([n21.connectedNodes containsObject:n01], NO);
    XCTAssertEqual([n21.connectedNodes containsObject:n11], YES);
    XCTAssertEqual([n21.connectedNodes containsObject:n21], NO);
    XCTAssertEqual([n21.connectedNodes containsObject:n02], NO);
    XCTAssertEqual([n21.connectedNodes containsObject:n12], NO);
    XCTAssertEqual([n21.connectedNodes containsObject:n22], YES);

    XCTAssertEqual([n02.connectedNodes containsObject:n00], NO);
    XCTAssertEqual([n02.connectedNodes containsObject:n10], NO);
    XCTAssertEqual([n02.connectedNodes containsObject:n20], NO);
    XCTAssertEqual([n02.connectedNodes containsObject:n01], YES);
    XCTAssertEqual([n02.connectedNodes containsObject:n11], NO);
    XCTAssertEqual([n02.connectedNodes containsObject:n21], NO);
    XCTAssertEqual([n02.connectedNodes containsObject:n02], NO);
    XCTAssertEqual([n02.connectedNodes containsObject:n12], YES);
    XCTAssertEqual([n02.connectedNodes containsObject:n22], NO);

    XCTAssertEqual([n12.connectedNodes containsObject:n00], NO);
    XCTAssertEqual([n12.connectedNodes containsObject:n10], NO);
    XCTAssertEqual([n12.connectedNodes containsObject:n20], NO);
    XCTAssertEqual([n12.connectedNodes containsObject:n01], NO);
    XCTAssertEqual([n12.connectedNodes containsObject:n11], YES);
    XCTAssertEqual([n12.connectedNodes containsObject:n21], NO);
    XCTAssertEqual([n12.connectedNodes containsObject:n02], YES);
    XCTAssertEqual([n12.connectedNodes containsObject:n12], NO);
    XCTAssertEqual([n12.connectedNodes containsObject:n22], YES);

    XCTAssertEqual([n22.connectedNodes containsObject:n00], NO);
    XCTAssertEqual([n22.connectedNodes containsObject:n10], NO);
    XCTAssertEqual([n22.connectedNodes containsObject:n20], NO);
    XCTAssertEqual([n22.connectedNodes containsObject:n01], NO);
    XCTAssertEqual([n22.connectedNodes containsObject:n11], NO);
    XCTAssertEqual([n22.connectedNodes containsObject:n21], YES);
    XCTAssertEqual([n22.connectedNodes containsObject:n02], NO);
    XCTAssertEqual([n22.connectedNodes containsObject:n12], YES);
    XCTAssertEqual([n22.connectedNodes containsObject:n22], NO);
}

- (void)testGridGraphCreatedFullyConnectedWithDiagonals
{
    JLFGKGridGraph *graph = [JLFGKGridGraph graphFromGridStartingAt:(vector_int2){0, 0}
                                                              width:3
                                                             height:3
                                                   diagonalsAllowed:YES];

    XCTAssertNotNil(graph);
    XCTAssertEqual(graph.nodes.count, 9);

    JLFGKGridGraphNode *n00 = [graph nodeAtGridPosition:(vector_int2){0, 0}];
    JLFGKGridGraphNode *n01 = [graph nodeAtGridPosition:(vector_int2){0, 1}];
    JLFGKGridGraphNode *n02 = [graph nodeAtGridPosition:(vector_int2){0, 2}];
    JLFGKGridGraphNode *n10 = [graph nodeAtGridPosition:(vector_int2){1, 0}];
    JLFGKGridGraphNode *n11 = [graph nodeAtGridPosition:(vector_int2){1, 1}];
    JLFGKGridGraphNode *n12 = [graph nodeAtGridPosition:(vector_int2){1, 2}];
    JLFGKGridGraphNode *n20 = [graph nodeAtGridPosition:(vector_int2){2, 0}];
    JLFGKGridGraphNode *n21 = [graph nodeAtGridPosition:(vector_int2){2, 1}];
    JLFGKGridGraphNode *n22 = [graph nodeAtGridPosition:(vector_int2){2, 2}];

    XCTAssertEqual([n00.connectedNodes containsObject:n00], NO);
    XCTAssertEqual([n00.connectedNodes containsObject:n10], YES);
    XCTAssertEqual([n00.connectedNodes containsObject:n20], NO);
    XCTAssertEqual([n00.connectedNodes containsObject:n01], YES);
    XCTAssertEqual([n00.connectedNodes containsObject:n11], YES);
    XCTAssertEqual([n00.connectedNodes containsObject:n21], NO);
    XCTAssertEqual([n00.connectedNodes containsObject:n02], NO);
    XCTAssertEqual([n00.connectedNodes containsObject:n12], NO);
    XCTAssertEqual([n00.connectedNodes containsObject:n22], NO);

    XCTAssertEqual([n10.connectedNodes containsObject:n00], YES);
    XCTAssertEqual([n10.connectedNodes containsObject:n10], NO);
    XCTAssertEqual([n10.connectedNodes containsObject:n20], YES);
    XCTAssertEqual([n10.connectedNodes containsObject:n01], YES);
    XCTAssertEqual([n10.connectedNodes containsObject:n11], YES);
    XCTAssertEqual([n10.connectedNodes containsObject:n21], YES);
    XCTAssertEqual([n10.connectedNodes containsObject:n02], NO);
    XCTAssertEqual([n10.connectedNodes containsObject:n12], NO);
    XCTAssertEqual([n10.connectedNodes containsObject:n22], NO);

    XCTAssertEqual([n20.connectedNodes containsObject:n00], NO);
    XCTAssertEqual([n20.connectedNodes containsObject:n10], YES);
    XCTAssertEqual([n20.connectedNodes containsObject:n20], NO);
    XCTAssertEqual([n20.connectedNodes containsObject:n01], NO);
    XCTAssertEqual([n20.connectedNodes containsObject:n11], YES);
    XCTAssertEqual([n20.connectedNodes containsObject:n21], YES);
    XCTAssertEqual([n20.connectedNodes containsObject:n02], NO);
    XCTAssertEqual([n20.connectedNodes containsObject:n12], NO);
    XCTAssertEqual([n20.connectedNodes containsObject:n22], NO);

    XCTAssertEqual([n01.connectedNodes containsObject:n00], YES);
    XCTAssertEqual([n01.connectedNodes containsObject:n10], YES);
    XCTAssertEqual([n01.connectedNodes containsObject:n20], NO);
    XCTAssertEqual([n01.connectedNodes containsObject:n01], NO);
    XCTAssertEqual([n01.connectedNodes containsObject:n11], YES);
    XCTAssertEqual([n01.connectedNodes containsObject:n21], NO);
    XCTAssertEqual([n01.connectedNodes containsObject:n02], YES);
    XCTAssertEqual([n01.connectedNodes containsObject:n12], YES);
    XCTAssertEqual([n01.connectedNodes containsObject:n22], NO);

    XCTAssertEqual([n11.connectedNodes containsObject:n00], YES);
    XCTAssertEqual([n11.connectedNodes containsObject:n10], YES);
    XCTAssertEqual([n11.connectedNodes containsObject:n20], YES);
    XCTAssertEqual([n11.connectedNodes containsObject:n01], YES);
    XCTAssertEqual([n11.connectedNodes containsObject:n11], NO);
    XCTAssertEqual([n11.connectedNodes containsObject:n21], YES);
    XCTAssertEqual([n11.connectedNodes containsObject:n02], YES);
    XCTAssertEqual([n11.connectedNodes containsObject:n12], YES);
    XCTAssertEqual([n11.connectedNodes containsObject:n22], YES);

    XCTAssertEqual([n21.connectedNodes containsObject:n00], NO);
    XCTAssertEqual([n21.connectedNodes containsObject:n10], YES);
    XCTAssertEqual([n21.connectedNodes containsObject:n20], YES);
    XCTAssertEqual([n21.connectedNodes containsObject:n01], NO);
    XCTAssertEqual([n21.connectedNodes containsObject:n11], YES);
    XCTAssertEqual([n21.connectedNodes containsObject:n21], NO);
    XCTAssertEqual([n21.connectedNodes containsObject:n02], NO);
    XCTAssertEqual([n21.connectedNodes containsObject:n12], YES);
    XCTAssertEqual([n21.connectedNodes containsObject:n22], YES);

    XCTAssertEqual([n02.connectedNodes containsObject:n00], NO);
    XCTAssertEqual([n02.connectedNodes containsObject:n10], NO);
    XCTAssertEqual([n02.connectedNodes containsObject:n20], NO);
    XCTAssertEqual([n02.connectedNodes containsObject:n01], YES);
    XCTAssertEqual([n02.connectedNodes containsObject:n11], YES);
    XCTAssertEqual([n02.connectedNodes containsObject:n21], NO);
    XCTAssertEqual([n02.connectedNodes containsObject:n02], NO);
    XCTAssertEqual([n02.connectedNodes containsObject:n12], YES);
    XCTAssertEqual([n02.connectedNodes containsObject:n22], NO);

    XCTAssertEqual([n12.connectedNodes containsObject:n00], NO);
    XCTAssertEqual([n12.connectedNodes containsObject:n10], NO);
    XCTAssertEqual([n12.connectedNodes containsObject:n20], NO);
    XCTAssertEqual([n12.connectedNodes containsObject:n01], YES);
    XCTAssertEqual([n12.connectedNodes containsObject:n11], YES);
    XCTAssertEqual([n12.connectedNodes containsObject:n21], YES);
    XCTAssertEqual([n12.connectedNodes containsObject:n02], YES);
    XCTAssertEqual([n12.connectedNodes containsObject:n12], NO);
    XCTAssertEqual([n12.connectedNodes containsObject:n22], YES);

    XCTAssertEqual([n22.connectedNodes containsObject:n00], NO);
    XCTAssertEqual([n22.connectedNodes containsObject:n10], NO);
    XCTAssertEqual([n22.connectedNodes containsObject:n20], NO);
    XCTAssertEqual([n22.connectedNodes containsObject:n01], NO);
    XCTAssertEqual([n22.connectedNodes containsObject:n11], YES);
    XCTAssertEqual([n22.connectedNodes containsObject:n21], YES);
    XCTAssertEqual([n22.connectedNodes containsObject:n02], NO);
    XCTAssertEqual([n22.connectedNodes containsObject:n12], YES);
    XCTAssertEqual([n22.connectedNodes containsObject:n22], NO);
}

- (void)testGridGraphConnectAdjacentNodes
{
    // This is kind of a silly-ish test, because -connectAdjacentNodes is used heavily within
    // the grid graph initializer, but I'm including it for clarity's sake.
    JLFGKGridGraph *graph = [JLFGKGridGraph graphFromGridStartingAt:(vector_int2){0, 0}
                                                              width:3
                                                             height:3
                                                   diagonalsAllowed:NO];

    JLFGKGridGraphNode *extraNode = [JLFGKGridGraphNode nodeWithGridPosition:(vector_int2){1, 1}];
    [graph connectNodeToAdjacentNodes:extraNode];

    JLFGKGridGraphNode *n00 = [graph nodeAtGridPosition:(vector_int2){0, 0}];
    JLFGKGridGraphNode *n01 = [graph nodeAtGridPosition:(vector_int2){0, 1}];
    JLFGKGridGraphNode *n02 = [graph nodeAtGridPosition:(vector_int2){0, 2}];
    JLFGKGridGraphNode *n10 = [graph nodeAtGridPosition:(vector_int2){1, 0}];
    JLFGKGridGraphNode *n11 = [graph nodeAtGridPosition:(vector_int2){1, 1}];
    JLFGKGridGraphNode *n12 = [graph nodeAtGridPosition:(vector_int2){1, 2}];
    JLFGKGridGraphNode *n20 = [graph nodeAtGridPosition:(vector_int2){2, 0}];
    JLFGKGridGraphNode *n21 = [graph nodeAtGridPosition:(vector_int2){2, 1}];
    JLFGKGridGraphNode *n22 = [graph nodeAtGridPosition:(vector_int2){2, 2}];

    XCTAssertEqual([extraNode.connectedNodes containsObject:n00], NO);
    XCTAssertEqual([extraNode.connectedNodes containsObject:n01], YES);
    XCTAssertEqual([extraNode.connectedNodes containsObject:n02], NO);
    XCTAssertEqual([extraNode.connectedNodes containsObject:n10], YES);
    XCTAssertEqual([extraNode.connectedNodes containsObject:n11], NO);
    XCTAssertEqual([extraNode.connectedNodes containsObject:n12], YES);
    XCTAssertEqual([extraNode.connectedNodes containsObject:n20], NO);
    XCTAssertEqual([extraNode.connectedNodes containsObject:n21], YES);
    XCTAssertEqual([extraNode.connectedNodes containsObject:n22], NO);

    graph = [JLFGKGridGraph graphFromGridStartingAt:(vector_int2){0, 0}
                                              width:3
                                             height:3
                                   diagonalsAllowed:YES];

    extraNode = [JLFGKGridGraphNode nodeWithGridPosition:(vector_int2){1, 1}];
    [graph connectNodeToAdjacentNodes:extraNode];

    n00 = [graph nodeAtGridPosition:(vector_int2){0, 0}];
    n01 = [graph nodeAtGridPosition:(vector_int2){0, 1}];
    n02 = [graph nodeAtGridPosition:(vector_int2){0, 2}];
    n10 = [graph nodeAtGridPosition:(vector_int2){1, 0}];
    n11 = [graph nodeAtGridPosition:(vector_int2){1, 1}];
    n12 = [graph nodeAtGridPosition:(vector_int2){1, 2}];
    n20 = [graph nodeAtGridPosition:(vector_int2){2, 0}];
    n21 = [graph nodeAtGridPosition:(vector_int2){2, 1}];
    n22 = [graph nodeAtGridPosition:(vector_int2){2, 2}];

    XCTAssertEqual([extraNode.connectedNodes containsObject:n00], YES);
    XCTAssertEqual([extraNode.connectedNodes containsObject:n01], YES);
    XCTAssertEqual([extraNode.connectedNodes containsObject:n02], YES);
    XCTAssertEqual([extraNode.connectedNodes containsObject:n10], YES);
    XCTAssertEqual([extraNode.connectedNodes containsObject:n11], NO);
    XCTAssertEqual([extraNode.connectedNodes containsObject:n12], YES);
    XCTAssertEqual([extraNode.connectedNodes containsObject:n20], YES);
    XCTAssertEqual([extraNode.connectedNodes containsObject:n21], YES);
    XCTAssertEqual([extraNode.connectedNodes containsObject:n22], YES);
}

- (void)testGridGraphFindPathNoDiagonals
{
    // The map being tested. 0s are clear space, 1s are walls, 5 is the start point, 9 the end,
    // 2s the expected path.
    const int mapWidth = 10;
    const int mapHeight = 10;
    const int map[] = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 2, 2, 2, 0, 0,
        0, 0, 0, 0, 2, 2, 1, 2, 0, 0,
        0, 0, 0, 0, 2, 1, 0, 2, 0, 0,
        0, 0, 0, 2, 2, 1, 0, 2, 0, 0,
        0, 0, 0, 2, 1, 0, 0, 2, 0, 0,
        0, 0, 0, 2, 2, 1, 0, 2, 0, 0,
        0, 0, 0, 0, 2, 0, 1, 9, 0, 0,
        0, 0, 0, 0, 5, 0, 1, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 1, 0, 0, 0
    };

    JLFGKGridGraph *graph = [JLFGKGridGraph graphFromGridStartingAt:(vector_int2){0, 0}
                                                              width:mapWidth
                                                             height:mapHeight
                                                   diagonalsAllowed:NO];

    JLFGKGridGraphNode *start = [graph nodeAtGridPosition:(vector_int2){4, 8}];
    JLFGKGridGraphNode *goal = [graph nodeAtGridPosition:(vector_int2){7, 7}];

    NSMutableArray *walls = [NSMutableArray array];
    for (int y = 0; y < mapHeight; y++) {
        for (int x = 0; x < mapWidth; x++) {
            int idx = x + (y * mapWidth);

            if (map[idx] == 1) {
                [walls addObject:[graph nodeAtGridPosition:(vector_int2){x, y}]];
            }
        }
    }

    [graph removeNodes:walls];
    NSArray *path = [graph findPathFromNode:start toNode:goal];
    XCTAssertNotNil(path);
    XCTAssertEqualObjects(start, path[0]);

    JLFGKGridGraphNode *step = [graph nodeAtGridPosition:(vector_int2){4, 7}];
    XCTAssertEqualObjects(step, path[1]);
    step = [graph nodeAtGridPosition:(vector_int2){4, 6}];
    XCTAssertEqualObjects(step, path[2]);
    step = [graph nodeAtGridPosition:(vector_int2){3, 6}];
    XCTAssertEqualObjects(step, path[3]);
    step = [graph nodeAtGridPosition:(vector_int2){3, 5}];
    XCTAssertEqualObjects(step, path[4]);
    step = [graph nodeAtGridPosition:(vector_int2){3, 4}];
    XCTAssertEqualObjects(step, path[5]);
    step = [graph nodeAtGridPosition:(vector_int2){4, 4}];
    XCTAssertEqualObjects(step, path[6]);
    step = [graph nodeAtGridPosition:(vector_int2){4, 3}];
    XCTAssertEqualObjects(step, path[7]);
    step = [graph nodeAtGridPosition:(vector_int2){4, 2}];
    XCTAssertEqualObjects(step, path[8]);
    step = [graph nodeAtGridPosition:(vector_int2){5, 2}];
    XCTAssertEqualObjects(step, path[9]);
    step = [graph nodeAtGridPosition:(vector_int2){5, 1}];
    XCTAssertEqualObjects(step, path[10]);
    step = [graph nodeAtGridPosition:(vector_int2){6, 1}];
    XCTAssertEqualObjects(step, path[11]);
    step = [graph nodeAtGridPosition:(vector_int2){7, 1}];
    XCTAssertEqualObjects(step, path[12]);
    step = [graph nodeAtGridPosition:(vector_int2){7, 2}];
    XCTAssertEqualObjects(step, path[13]);
    step = [graph nodeAtGridPosition:(vector_int2){7, 3}];
    XCTAssertEqualObjects(step, path[14]);
    step = [graph nodeAtGridPosition:(vector_int2){7, 4}];
    XCTAssertEqualObjects(step, path[15]);
    step = [graph nodeAtGridPosition:(vector_int2){7, 5}];
    XCTAssertEqualObjects(step, path[16]);
    step = [graph nodeAtGridPosition:(vector_int2){7, 6}];
    XCTAssertEqualObjects(step, path[17]);

    XCTAssertEqualObjects(goal, [path lastObject]);
}

- (void)testGridGraphFindPathWithDiagonals
{
    // The map being tested. 0s are clear space, 1s are walls, 5 is the start point, 9 the end,
    // 2s the expected path.
    const int mapWidth = 10;
    const int mapHeight = 10;
    const int map[] = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 1, 0, 0, 0,
        0, 0, 0, 0, 0, 1, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 1, 0, 0, 0, 0,
        0, 0, 0, 0, 1, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 1, 2, 0, 0, 0,
        0, 0, 0, 0, 0, 2, 1, 9, 0, 0,
        0, 0, 0, 0, 5, 0, 1, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 1, 0, 0, 0
    };

    JLFGKGridGraph *graph = [JLFGKGridGraph graphFromGridStartingAt:(vector_int2){0, 0}
                                                              width:mapWidth
                                                             height:mapHeight
                                                   diagonalsAllowed:YES];

    JLFGKGridGraphNode *start = [graph nodeAtGridPosition:(vector_int2){4, 8}];
    JLFGKGridGraphNode *goal = [graph nodeAtGridPosition:(vector_int2){7, 7}];

    NSMutableArray *walls = [NSMutableArray array];
    for (int y = 0; y < mapHeight; y++) {
        for (int x = 0; x < mapWidth; x++) {
            int idx = x + (y * mapWidth);

            if (map[idx] == 1) {
                [walls addObject:[graph nodeAtGridPosition:(vector_int2){x, y}]];
            }
        }
    }

    [graph removeNodes:walls];
    NSArray *path = [graph findPathFromNode:start toNode:goal];
    XCTAssertNotNil(path);
    XCTAssertEqualObjects(start, path[0]);

    JLFGKGridGraphNode *step = [graph nodeAtGridPosition:(vector_int2){5, 7}];
    XCTAssertEqualObjects(step, path[1]);
    step = [graph nodeAtGridPosition:(vector_int2){6, 6}];
    XCTAssertEqualObjects(step, path[2]);

    XCTAssertEqualObjects(goal, [path lastObject]);
}
@end
