//
//  JLFGKStateMachine.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/26/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLFGKState.h"

@interface JLFGKStateMachine : NSObject

+ (instancetype)stateMachineWithStates:(NSArray *)states;
- (instancetype)initWithStates:(NSArray *)states;

@property (nonatomic, readonly) JLFGKState *currentState;

- (BOOL)canEnterState:(Class)stateClass;
- (BOOL)enterState:(Class)stateClass;
- (JLFGKState *)stateForClass:(Class)stateClass;
- (void)updateWithDeltaTime:(CFTimeInterval)seconds;

@end
