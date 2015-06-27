//
//  JLFGKState.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/26/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JLFGKStateMachine;

@interface JLFGKState : NSObject

+ (instancetype)state;

@property (nonatomic, readonly, weak) JLFGKStateMachine *stateMachine;

- (BOOL)isValidNextState:(Class)stateClass;
- (void)didEnterWithPreviousState:(JLFGKState *)previousState;
- (void)willExitWithNextState:(JLFGKState *)nextState;
- (void)updateWithDeltaTime:(CFTimeInterval)seconds;

@end
