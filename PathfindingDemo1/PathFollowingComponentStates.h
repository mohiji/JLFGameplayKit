//
//  PathFollowingComponentStates.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/3/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "PathFollowingComponent.h"
#import "JLFGKState.h"
#import "JLFGKStateMachine.h"

@interface PathFollowingComponentState : JLFGKState

@property (weak, nonatomic) PathFollowingComponent *owner;
@property (readonly, nonatomic) JLFGKEntity *entity;

@end

@interface IdleState : PathFollowingComponentState
@end

@interface MoveState : PathFollowingComponentState

@property (assign, nonatomic) CGPoint destination;

@end

@interface PauseState : PathFollowingComponentState

@property (assign, nonatomic) CFTimeInterval timeRemaining;

@end
