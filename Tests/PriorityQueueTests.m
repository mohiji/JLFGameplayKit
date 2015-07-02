//
//  PriorityQueueTests.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/2/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "JLFGKSimplePriorityQueue.h"

@interface PriorityQueueTests : XCTestCase

@end

@implementation PriorityQueueTests

- (void)testCountIsCorrect
{
    JLFGKSimplePriorityQueue *queue = [[JLFGKSimplePriorityQueue alloc] init];
    NSObject *one = [[NSObject alloc] init];
    NSObject *two = [[NSObject alloc] init];
    NSObject *three = [[NSObject alloc] init];

    [queue insertObject:two withPriority:2.0f];
    [queue insertObject:one withPriority:1.0f];
    [queue insertObject:three withPriority:3.0f];

    XCTAssertEqual(queue.count, 3);
}

- (void)testInsertsAreOrderedProperly
{
    JLFGKSimplePriorityQueue *queue = [[JLFGKSimplePriorityQueue alloc] init];
    NSObject *one = [[NSObject alloc] init];
    NSObject *two = [[NSObject alloc] init];
    NSObject *three = [[NSObject alloc] init];

    [queue insertObject:two withPriority:2.0f];
    [queue insertObject:one withPriority:1.0f];
    [queue insertObject:three withPriority:3.0f];

    XCTAssertEqualObjects([queue get], one);
    XCTAssertEqualObjects([queue get], two);
    XCTAssertEqualObjects([queue get], three);
}

- (void)testCanRetrievePriorities
{
    JLFGKSimplePriorityQueue *queue = [[JLFGKSimplePriorityQueue alloc] init];
    NSObject *one = [[NSObject alloc] init];
    NSObject *two = [[NSObject alloc] init];
    NSObject *three = [[NSObject alloc] init];

    [queue insertObject:two withPriority:2.0f];
    [queue insertObject:one withPriority:1.0f];
    [queue insertObject:three withPriority:3.0f];

    XCTAssertEqual([queue priorityForObject:one], 1.0f);
    XCTAssertEqual([queue priorityForObject:two], 2.0f);
    XCTAssertEqual([queue priorityForObject:three], 3.0f);
}

- (void)testCanUpdatePriorities
{
    JLFGKSimplePriorityQueue *queue = [[JLFGKSimplePriorityQueue alloc] init];
    NSObject *one = [[NSObject alloc] init];
    NSObject *two = [[NSObject alloc] init];
    NSObject *three = [[NSObject alloc] init];

    [queue insertObject:two withPriority:2.0f];
    [queue insertObject:one withPriority:1.0f];
    [queue insertObject:three withPriority:3.0f];

    XCTAssertEqual(queue.count, 3);
    [queue insertObject:one withPriority:4.0f];
    XCTAssertEqual(queue.count, 3);
    XCTAssertEqual([queue priorityForObject:one], 4.0f);

    XCTAssertEqualObjects([queue get], two);
    XCTAssertEqualObjects([queue get], three);
    XCTAssertEqualObjects([queue get], one);
}
@end
