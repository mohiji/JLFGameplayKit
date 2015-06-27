//
//  WanderComponent.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/25/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "JLFGKEntity.h"
#import "JLFGKStateMachine.h"

#import "WanderComponent.h"
#import "MoveComponent.h"
#import "CGPointMath.h"

static CGFloat waitTime()
{
    // Minimum 1 second, maximum 4 seconds
    return 1.0f + (arc4random_uniform(3000) / 1000.0f);
}

@interface WaitingState : JLFGKState

- (id)initWithComponent:(JLFGKComponent *)move;

@property (weak, nonatomic) JLFGKComponent *component;
@property (assign, nonatomic) CFTimeInterval timeRemaining;

@end

@interface WalkingState : JLFGKState

- (id)initWithComponent:(JLFGKComponent *)component;

@property (weak, nonatomic) JLFGKComponent *component;
@property (assign, nonatomic) CFTimeInterval timeRemaining;
@property (assign, nonatomic) CGPoint direction;

@end

@implementation WaitingState

- (id)initWithComponent:(JLFGKComponent *)component
{
    self = [super init];
    if (self != nil) {
        self.component = component;
    }
    return self;
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [WalkingState class];
}

- (void)didEnterWithPreviousState:(JLFGKState *)previousState
{
    self.timeRemaining = waitTime();

    MoveComponent *move = (MoveComponent *)[self.component.entity componentForClass:[MoveComponent class]];
    move.moving = NO;
}

- (void)updateWithDeltaTime:(CFTimeInterval)seconds
{
    self.timeRemaining -= seconds;
    MoveComponent *move = (MoveComponent *)[self.component.entity componentForClass:[MoveComponent class]];
    move.moving = NO;

    if (self.timeRemaining <= 0.0f) {
        [self.stateMachine enterState:[WalkingState class]];
    }
}

@end

@implementation WalkingState

- (id)initWithComponent:(JLFGKComponent *)component
{
    self = [super init];
    if (self != nil) {
        self.component = component;
    }
    return self;
}

- (BOOL)isValidNextState:(Class)stateClass
{
    return stateClass == [WaitingState class];
}

- (void)didEnterWithPreviousState:(JLFGKState *)previousState
{
    self.timeRemaining = waitTime();
    int degrees = arc4random_uniform(360);
    self.direction = CGPointMake(cosf(degrees * M_PI / 180.0f), sinf(degrees * M_PI / 180.0f));
}

- (void)updateWithDeltaTime:(CFTimeInterval)seconds
{
    self.timeRemaining -= seconds;
    if (self.timeRemaining <= 0.0f) {
        [self.stateMachine enterState:[WaitingState class]];
    }

    MoveComponent *move = (MoveComponent *)[self.component.entity componentForClass:[MoveComponent class]];

    CGPoint offset = CGPointScale(self.direction, 50.0f);
    move.moveTarget = CGPointAdd(offset, move.lastLocation);
    move.moving = YES;
}
@end

@interface WanderComponent ()
@property (strong, nonatomic) JLFGKStateMachine *stateMachine;
@end

@implementation WanderComponent

- (id)init
{
    self = [super init];
    if (self != nil) {
        WaitingState *wait = [[WaitingState alloc] initWithComponent:self];
        WalkingState *walk = [[WalkingState alloc] initWithComponent:self];
        self.stateMachine = [JLFGKStateMachine stateMachineWithStates:@[wait, walk]];
        [self.stateMachine enterState:[WaitingState class]];
    }
    return self;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [self.stateMachine updateWithDeltaTime:seconds];
}

@end
