//
//  PlayerMovementComponent.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/25/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "MoveComponent.h"
#import "JLFGKEntity.h"
#import "CGPointMath.h"
#import "SpriteComponent.h"

const CGFloat kDefaultPlayerMoveSpeed = 150.0f;
const CGFloat kMoveStopThreshold = 4.0f;

@interface MoveComponent ()

@property (assign, nonatomic) CGPoint lastLocation;
@property (assign, nonatomic) CGPoint moveDirection;

@end

@implementation MoveComponent

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.moveSpeed = kDefaultPlayerMoveSpeed;
    }

    return self;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    if (self.moving == NO) {
        return;
    }

    SpriteComponent *spriteComp = (SpriteComponent*)[self.entity componentForClass:[SpriteComponent class]];
    SKSpriteNode *sprite = spriteComp.sprite;
    if (sprite != nil) {
        self.lastLocation = sprite.position;

        CGPoint deltaV = CGPointSubtract(self.moveTarget, self.lastLocation);
        if (CGPointMagnitude(deltaV) < kMoveStopThreshold) {
            self.moving = NO;
            return;
        }

        deltaV = CGPointNormalize(deltaV);
        self.moveDirection = deltaV;
        
        deltaV = CGPointScale(deltaV, self.moveSpeed * seconds);
        sprite.position = CGPointAdd(sprite.position, deltaV);
    }
}

@end
