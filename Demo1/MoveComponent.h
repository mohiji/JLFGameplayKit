//
//  PlayerMovementComponent.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/25/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "JLFGKComponent.h"

extern const CGFloat kDefaultPlayerMoveSpeed;

@interface MoveComponent : JLFGKComponent

@property (assign, nonatomic) BOOL moving;
@property (assign, nonatomic) CGPoint moveTarget;
@property (assign, nonatomic) CGFloat moveSpeed;

@property (readonly, nonatomic) CGPoint lastLocation;
@property (readonly, nonatomic) CGPoint moveDirection; // This is useful to other folks, so might as well expose it

@end
