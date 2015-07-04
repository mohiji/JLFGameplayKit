//
//  PathFollowingComponent.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/3/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "PathFollowingComponent.h"
#import "PathFollowingComponentStates.h"
#import "JLFGKEntity.h"
#import "JLFGKStateMachine.h"
#import "BouncyComponent.h"
@import SpriteKit;

const CGFloat kDefaultPlayerMoveSpeed = 150.0f;

@interface PathFollowingComponent ()

@property (assign, nonatomic) NSUInteger waypointCount;
@property (assign, nonatomic) CGPoint *waypoints;
@property (strong, nonatomic) JLFGKStateMachine *stateMachine;

@end

@implementation PathFollowingComponent

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.waypointCount = 0;
        self.waypoints = NULL;
        self.moveSpeed = kDefaultPlayerMoveSpeed;

        IdleState *idle = [IdleState state];
        PauseState *pause = [PauseState state];
        MoveState *move = [MoveState state];
        idle.owner = self;
        pause.owner = self;
        move.owner = self;

        NSArray *states = @[idle, pause, move];
        self.stateMachine = [JLFGKStateMachine stateMachineWithStates:states];
        [self.stateMachine enterState:IdleState.class];
    }
    return self;
}

- (void)dealloc
{
    free(self.waypoints);
}

- (void)followPath:(NSArray *)path
{
    NSAssert(path != nil, @"PathFollowingComponent -followPath: Called with a nil path.");
    free(self.waypoints);
    self.waypointCount = path.count;
    self.waypoints = calloc(sizeof(CGPoint), self.waypointCount);

    int i = 0;
    NSEnumerator *pathEnum = [path reverseObjectEnumerator];
    SKNode *node = (SKNode *)[pathEnum nextObject];
    while (node != nil) {
        self.waypoints[i] = node.position;
        node = [pathEnum nextObject];
        i++;
    }

    [self.stateMachine enterState:IdleState.class];
}

- (CGPoint)takeNextWaypoint
{
    NSAssert(self.waypointCount > 0, @"Out of waypoints.");
    self.waypointCount--;
    return self.waypoints[self.waypointCount];
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [self.stateMachine updateWithDeltaTime:seconds];
}

@end