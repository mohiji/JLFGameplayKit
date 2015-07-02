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
@end
