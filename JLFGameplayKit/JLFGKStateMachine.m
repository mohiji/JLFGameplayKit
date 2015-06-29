//
//  JLFGKStateMachine.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/26/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "JLFGKStateMachine.h"
#import "JLFGKState+Private.h"
@import ObjectiveC;

@interface JLFGKStateMachine ()

@property (strong, readwrite, nonatomic) NSMapTable *states;
@property (strong, readwrite, nonatomic) JLFGKState *currentState;

@end

@implementation JLFGKStateMachine

+ (instancetype)stateMachineWithStates:(NSArray *)states
{
    return [[[self class] alloc] initWithStates:states];
}

/**
 * The states used in the state machine must all be subclasses of JLFGKState, and must
 * all be unique. This function ensures that, and throws an NSAssertionException if it's
 * not true.
 */
+ (void)ensureClassesAreStatesAndUnique:(NSArray *)states
{
    NSHashTable *statesTable = [NSHashTable hashTableWithOptions:NSHashTableObjectPointerPersonality];
    for (id obj in states) {
        NSAssert([obj isKindOfClass:[JLFGKState class]], @"%s is not a subclass of JLFGKState.", class_getName([obj class]));
        NSAssert(![statesTable containsObject:[obj class]], @"State class %s was present more than once in the states array.", class_getName([obj class]));
        [statesTable addObject:[obj class]];
    }
}

- (instancetype)initWithStates:(NSArray *)states
{
    NSAssert(states != nil && states.count > 0, @"Can't create a JLFGKStateMachine with an empty states array.");
    [JLFGKStateMachine ensureClassesAreStatesAndUnique:states];
    self = [super init];
    if (self != nil) {
        self.states = [NSMapTable mapTableWithKeyOptions:NSMapTableObjectPointerPersonality
                                            valueOptions:NSMapTableStrongMemory];

        for (JLFGKState *state in states) {
            state.stateMachine = self;
            [self.states setObject:state forKey:[state class]];
        }
    }
    return self;
}

- (instancetype)init
{
    NSAssert(false, @"JLFGKStateMachine must be initialized using -initWithStates:");
    return nil;
}

- (BOOL)canEnterState:(Class)stateClass
{
    // Can't switch to a state that isn't present in self.states
    if ([self.states objectForKey:stateClass] == nil) {
        return NO;
    }

    // If there's not already a current state set, then of course we can enter it.
    if (self.currentState == nil) {
        return YES;
    } else {
        // Otherwise, ask the current state if it's allowed.
        return [self.currentState isValidNextState:stateClass];
    }
}

- (BOOL)enterState:(Class)stateClass
{
    if ([self canEnterState:stateClass] == NO) {
        return NO;
    }

    JLFGKState *previousState = self.currentState;
    JLFGKState *nextState = [self.states objectForKey:stateClass];
    [previousState willExitWithNextState:nextState];
    self.currentState = nextState;
    [self.currentState didEnterWithPreviousState:previousState];
    return YES;
}

- (JLFGKState *)stateForClass:(Class)stateClass
{
    return [self.states objectForKey:stateClass];
}

- (void)updateWithDeltaTime:(CFTimeInterval)seconds
{
    [self.currentState updateWithDeltaTime:seconds];
}

@end
