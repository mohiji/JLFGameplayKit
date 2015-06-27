//
//  StateMachineTests.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/26/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
@import ObjectiveC;

#import "JLFGKState.h"
#import "JLFGKStateMachine.h"

/********************************************
 * The state graph used in these tests
 *
 * StateOne -----> StateTwo -----> State Three
 *     ^            |  ^                |
 *     |            |  |                |
 *     -------------|  |----------------|
 *
 * StateThree will set properties when it receives any of the lifecycle messages
 * so that we can make sure they were called.
 *
 * StateFour is a valid JLFGKStateClass, but isn't part of the state machine.
 *
 * And then a fake one that's just not a state: NotAState
 */

@interface StateOne : JLFGKState
@end

@interface StateTwo : JLFGKState
@end

@interface StateThree : JLFGKState

@property (assign, nonatomic) BOOL didEnterStateCalled;
@property (assign, nonatomic) BOOL willLeaveStateCalled;
@property (assign, nonatomic) CFTimeInterval deltaTimeAtLastUpdate;

@end

@interface StateFour : JLFGKState
@end

@interface NotAState : NSObject
@end

@implementation StateOne

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [StateTwo class];
}

@end

@implementation StateTwo

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [StateOne class] || stateClass == [StateThree class];
}

@end

@implementation StateThree

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [StateTwo class];
}

- (void)didEnterWithPreviousState:(JLFGKState *)previousState
{
    self.didEnterStateCalled = YES;
}

- (void)willExitWithNextState:(JLFGKState *)nextState
{
    self.willLeaveStateCalled = YES;
}

- (void)updateWithDeltaTime:(CFTimeInterval)seconds
{
    self.deltaTimeAtLastUpdate = seconds;
}

@end

@implementation StateFour

- (BOOL)isValidNextState:(Class)stateClass
{
    NSAssert(false, @"Should never reach this.");
    return YES;
}

@end
@implementation NotAState

- (BOOL)isValidNextState:(Class)stateClass
{
    NSAssert(false, @"Should never reach this.");
    return YES;
}

@end

@interface StateMachineTests : XCTestCase
@end

@implementation StateMachineTests

- (void)testStateCreation
{
    // Making sure I got JLFGKState's +state method right.
    JLFGKState *baseClass = [JLFGKState state];
    XCTAssert([baseClass isMemberOfClass:[JLFGKState class]]);

    JLFGKState *subClass = [StateOne state];
    XCTAssertFalse([subClass isMemberOfClass:[JLFGKState class]]);
    XCTAssert([subClass isMemberOfClass:[StateOne class]]);
}

- (void)testEmptyStateMachineFails
{
    XCTAssertThrows([JLFGKStateMachine stateMachineWithStates:@[]]);
}

- (void)testBadStateClassesFails
{
    XCTAssertThrows([JLFGKStateMachine stateMachineWithStates:@[[NSNumber numberWithBool:NO]]]);
}

- (void)testNormalStateMachineCreationSucceeds
{
    NSArray *states = @[[StateOne state], [StateTwo state]];
    XCTAssertNoThrow([JLFGKStateMachine stateMachineWithStates:states]);
}

- (void)testNotUniqueStateClassesFails
{
    NSArray *states = @[[StateOne state], [StateOne state]];
    XCTAssertThrows([JLFGKStateMachine stateMachineWithStates:states]);
}

- (void)testCanEnterInitialState
{
    NSArray *states = @[[StateOne state], [StateTwo state]];
    JLFGKStateMachine *machine = [JLFGKStateMachine stateMachineWithStates:states];
    XCTAssert([machine canEnterState:[StateOne class]]);
    XCTAssert([machine canEnterState:[StateTwo class]]);
    XCTAssertFalse([machine canEnterState:[StateThree class]]);
}

- (void)testRetrieveStates
{
    StateOne *stateOne = [StateOne state];
    StateTwo *stateTwo = [StateTwo state];
    StateThree *stateThree = [StateThree state];
    NSArray *states = @[stateOne, stateTwo, stateThree];
    JLFGKStateMachine *machine = [JLFGKStateMachine stateMachineWithStates:states];

    XCTAssertEqualObjects(stateOne, [machine stateForClass:[StateOne class]]);
    XCTAssertEqualObjects(stateTwo, [machine stateForClass:[StateTwo class]]);
    XCTAssertEqualObjects(stateThree, [machine stateForClass:[StateThree class]]);
    XCTAssertNil([machine stateForClass:[StateFour class]]);
}

- (void)testEnterInitialState
{
    StateOne *stateOne = [StateOne state];
    StateTwo *stateTwo = [StateTwo state];
    StateThree *stateThree = [StateThree state];
    NSArray *states = @[stateOne, stateTwo, stateThree];
    JLFGKStateMachine *machine = [JLFGKStateMachine stateMachineWithStates:states];

    XCTAssert([machine enterState:[StateOne class]]);
    XCTAssertEqualObjects(stateOne, machine.currentState);
}

- (void)testEnterNextState
{
    StateOne *stateOne = [StateOne state];
    StateTwo *stateTwo = [StateTwo state];
    StateThree *stateThree = [StateThree state];
    NSArray *states = @[stateOne, stateTwo, stateThree];
    JLFGKStateMachine *machine = [JLFGKStateMachine stateMachineWithStates:states];

    XCTAssert([machine enterState:[StateOne class]]);
    XCTAssertEqualObjects(stateOne, machine.currentState);
    XCTAssert([machine enterState:[StateTwo class]]);
    XCTAssertEqualObjects(stateTwo, machine.currentState);
}

- (void)testCantEnterInvalidState
{
    StateOne *stateOne = [StateOne state];
    StateTwo *stateTwo = [StateTwo state];
    StateThree *stateThree = [StateThree state];
    NSArray *states = @[stateOne, stateTwo, stateThree];
    JLFGKStateMachine *machine = [JLFGKStateMachine stateMachineWithStates:states];

    XCTAssert([machine enterState:[StateOne class]]);
    XCTAssertEqualObjects(stateOne, machine.currentState);
    XCTAssertFalse([machine enterState:[StateThree class]]);
    XCTAssertEqualObjects(stateOne, machine.currentState);
}

- (void)testLifecycleMethods
{
    StateOne *stateOne = [StateOne state];
    StateTwo *stateTwo = [StateTwo state];
    StateThree *stateThree = [StateThree state];
    NSArray *states = @[stateOne, stateTwo, stateThree];
    JLFGKStateMachine *machine = [JLFGKStateMachine stateMachineWithStates:states];

    [machine enterState:[StateThree class]];
    XCTAssert(stateThree.didEnterStateCalled);

    CFTimeInterval seconds = 0.6;
    [machine updateWithDeltaTime:seconds];
    XCTAssertEqual(stateThree.deltaTimeAtLastUpdate, seconds);

    [machine enterState:[StateTwo class]];
    XCTAssert(stateThree.willLeaveStateCalled);
}

@end
