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
    vector_float2 unitDirection = vector_normalize(sampleDirection);
    vector_float2 expected = {sampleDirection.x + unitDirection.x, sampleDirection.y + unitDirection.y};

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

- (void)testSimdVectorFunctions
{
    vector_float2 v = {0, 5.0f};
    XCTAssertEqual(vector_length(v), 5.0f);

    vector_float2 normal = vector_normalize(v);
    XCTAssertEqual(normal.x, 0.0f);
    XCTAssertEqual(normal.y, 1.0f);
}

- (void)testLineIntersections
{
    // I drew out a bunch of points and polygons on a sheet of graph paper for this list. The
    // same set is used in PathfindingTests -testObstaclePathfinding
    vector_float2 points[] = {
        { -4, 13},
        { -6,  7},
        { -4,  6},
        { -1,  9},
        { -6, 11},
        { -1,  4},
        { -3, -4},
        {  2, 12},
        { 11, 13},
        {  7, 11},
        {  6,  5},
        { 12,  3},
        { 14,  7},
        {  2, -1},
        {  7, -4},
        { 16, -4},
        { 14, -2},
        { 16, 10},
        { 17,  4},
        {  6,  2},
        {  9, -6}
    };

    // These are just straightforward intersecting lines: make sure they give us an intersection regardless
    // of the order of the points.
    XCTAssertTrue(line_segments_intersect(points[19], points[17], points[10], points[11]));
    XCTAssertTrue(line_segments_intersect(points[17], points[19], points[10], points[11]));
    XCTAssertTrue(line_segments_intersect(points[19], points[17], points[11], points[10]));
    XCTAssertTrue(line_segments_intersect(points[17], points[19], points[11], points[10]));

    // These lines share an endpoint. For the purposes of the graph nodes, these should *not* be considered
    // to intersect.
    XCTAssertFalse(line_segments_intersect(points[19], points[10], points[10], points[9]));
    XCTAssertFalse(line_segments_intersect(points[10], points[19], points[10], points[9]));
    XCTAssertFalse(line_segments_intersect(points[19], points[10], points[9], points[10]));
    XCTAssertFalse(line_segments_intersect(points[10], points[19], points[9], points[10]));

    // These ones shouldn't intersect at all
    XCTAssertFalse(line_segments_intersect(points[5], points[6], points[14], points[15]));
    XCTAssertFalse(line_segments_intersect(points[6], points[5], points[14], points[15]));
    XCTAssertFalse(line_segments_intersect(points[5], points[6], points[15], points[14]));
    XCTAssertFalse(line_segments_intersect(points[6], points[5], points[15], points[14]));
}

@end
