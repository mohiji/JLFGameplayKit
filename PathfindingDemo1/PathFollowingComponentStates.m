//
//  PathFollowingComponentStates.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/3/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "PathFollowingComponentStates.h"
#import "BouncyComponent.h"
#import "SpriteComponent.h"
#import "CGPointMath.h"
#import "JLFGKEntity.h"

static const CGFloat kMoveStopThreshold = 2.0f;
static const CGFloat kPauseTime = 0.15f;

@implementation PathFollowingComponentState

- (JLFGKEntity *)entity
{
    return self.owner.entity;
}

@end

@implementation IdleState

- (void)updateWithDeltaTime:(CFTimeInterval)seconds
{
    if (self.owner.waypointCount > 0) {
        [self.stateMachine enterState:MoveState.class];
    }
}

@end

@implementation PauseState

- (void)didEnterWithPreviousState:(JLFGKState *)previousState
{
    self.timeRemaining = kPauseTime;
}

- (void)updateWithDeltaTime:(CFTimeInterval)seconds
{
    if (self.owner.waypointCount == 0) {
        [self.stateMachine enterState:IdleState.class];
    }

    self.timeRemaining -= seconds;
    if (self.timeRemaining <= 0.0f) {
        [self.stateMachine enterState:MoveState.class];
    }
}

@end

@implementation MoveState

- (void)didEnterWithPreviousState:(JLFGKState *)previousState
{
    self.destination = [self.owner takeNextWaypoint];
    BouncyComponent *bouncy = (BouncyComponent *)[self.entity componentForClass:BouncyComponent.class];
    [bouncy startBouncing];
}

- (void)willExitWithNextState:(JLFGKState *)nextState
{
    BouncyComponent *bouncy = (BouncyComponent *)[self.entity componentForClass:BouncyComponent.class];
    [bouncy stopBouncing];
}

- (void)updateWithDeltaTime:(CFTimeInterval)seconds
{
    SpriteComponent *spriteComp = (SpriteComponent*)[self.entity componentForClass:[SpriteComponent class]];
    SKSpriteNode *sprite = spriteComp.sprite;
    if (sprite != nil) {
        CGPoint deltaV = CGPointSubtract(self.destination, sprite.position);
        if (CGPointMagnitude(deltaV) < kMoveStopThreshold) {
            [self.stateMachine enterState:PauseState.class];
            return;
        }

        deltaV = CGPointNormalize(deltaV);
        deltaV = CGPointScale(deltaV, self.owner.moveSpeed * seconds);
        sprite.position = CGPointAdd(sprite.position, deltaV);
    }
}

@end