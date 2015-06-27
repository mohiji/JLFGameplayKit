//
//  JLFGKState.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/26/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "JLFGKState.h"
#import "JLFGKState+Private.h"

@interface JLFGKState ()

@property (nonatomic, readwrite, weak) JLFGKStateMachine *stateMachine;

@end

@implementation JLFGKState

+ (instancetype)state
{
    return [[[self class] alloc] init];
}

- (BOOL)isValidNextState:(Class)stateClass
{
    // TODO: Find out what the real GKState class default is.
    return NO;
}

- (void)didEnterWithPreviousState:(JLFGKState *)previousState
{
    // nop
}

- (void)willExitWithNextState:(JLFGKState *)nextState
{
    // nop
}

- (void)updateWithDeltaTime:(CFTimeInterval)seconds
{
    // nop
}

@end
