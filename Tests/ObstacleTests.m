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

@end
