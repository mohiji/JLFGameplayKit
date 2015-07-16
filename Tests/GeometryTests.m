//
//  GeometryTests.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/16/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "JLFGKPolygonObstacle.h"
#import "JLFGKPolygonObstacle+Geometry.h"
#import "JLFGKGeometry.h"

@interface GeometryTests : XCTestCase

@end

@implementation GeometryTests

- (void)testPolygonCentroid
{
    vector_float2 pointsAroundOrigin[] = {
        {1, -1},
        {1, 1},
        {-1, 1},
        {-1, -1}
    };

    vector_float2 pointsAround33[] = {
        {4, 2},
        {4, 4},
        {2, 4},
        {2, 2}
    };

    JLFGKPolygonObstacle *p1 = [JLFGKPolygonObstacle obstacleWithPoints:pointsAroundOrigin count:4];
    JLFGKPolygonObstacle *p2 = [JLFGKPolygonObstacle obstacleWithPoints:pointsAround33 count:4];
    vector_float2 centroid1 = p1.centroid;
    vector_float2 centroid2 = p2.centroid;

    XCTAssertEqual(centroid1.x, 0);
    XCTAssertEqual(centroid1.y, 0);
    XCTAssertEqual(centroid2.x, 3);
    XCTAssertEqual(centroid2.y, 3);
}

- (void)testPolygonArea
{
    vector_float2 pointsAroundOrigin[] = {
        {1, -1},
        {1, 1},
        {-1, 1},
        {-1, -1}
    };

    vector_float2 pointsAround33[] = {
        {4, 2},
        {4, 4},
        {2, 4},
        {2, 2}
    };

    JLFGKPolygonObstacle *p1 = [JLFGKPolygonObstacle obstacleWithPoints:pointsAroundOrigin count:4];
    JLFGKPolygonObstacle *p2 = [JLFGKPolygonObstacle obstacleWithPoints:pointsAround33 count:4];
    float area1 = p1.area;
    float area2 = p2.area;

    XCTAssertEqual(area1, area2);
}

- (void)testPolygonNodesWithRadius
{
    vector_float2 pointsAroundOrigin[] = {
        {1, -1},
        {1, 1},
        {-1, 1},
        {-1, -1}
    };

    vector_float2 sampleDirection = {1, 1};
    vector_float2 unitDirection = vector_float2_normalized(sampleDirection);
    vector_float2 expected = vector_float2_add(sampleDirection, unitDirection);

    JLFGKPolygonObstacle *p1 = [JLFGKPolygonObstacle obstacleWithPoints:pointsAroundOrigin count:4];
    NSArray *nodes = [p1 nodesWithBufferRadius:1.0f];
    XCTAssertNotNil(nodes);
    XCTAssertEqual(nodes.count, 4);

    JLFGKGraphNode2D *node = nodes[0];
    XCTAssertEqual(node.position.x, expected.x);
    XCTAssertEqual(node.position.y, -expected.y);
    node = nodes[1];
    XCTAssertEqual(node.position.x, expected.x);
    XCTAssertEqual(node.position.y, expected.y);
    node = nodes[2];
    XCTAssertEqual(node.position.x, -expected.x);
    XCTAssertEqual(node.position.y, expected.y);
    node = nodes[3];
    XCTAssertEqual(node.position.x, -expected.x);
    XCTAssertEqual(node.position.y, -expected.y);
}

- (void)testVector2Functions
{
    vector_float2 v = {0, 5.0f};
    XCTAssertEqual(vector_float2_magnitude(v), 5.0f);

    vector_float2 normal = vector_float2_normalized(v);
    XCTAssertEqual(normal.x, 0.0f);
    XCTAssertEqual(normal.y, 1.0f);

    vector_float2 scaled = vector_float2_scale(normal, 3.0f);
    XCTAssertEqual(scaled.x, 0.0f);
    XCTAssertEqual(scaled.y, 3.0f);

    vector_float2 added = vector_float2_add((vector_float2){1, 1}, scaled);
    XCTAssertEqual(added.x, 1.0f);
    XCTAssertEqual(added.y, 4.0f);

    vector_float2 subtracted = vector_float2_subtract(added, (vector_float2){6, 7});
    XCTAssertEqual(subtracted.x, -5.0f);
    XCTAssertEqual(subtracted.y, -3.0f);
}

@end
