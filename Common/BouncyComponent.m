//
//  BouncyComponent.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/3/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "BouncyComponent.h"
#import "SpriteComponent.h"
#import "JLFGKEntity.h"

const float kDefaultBounceSpeed = 0.18f;

@interface BouncyComponent ()

@property (assign, nonatomic) BOOL bouncing;
@property (assign, nonatomic) CFTimeInterval bounceTime;
@property (assign, nonatomic) CFTimeInterval shouldStopBouncingTime;

@end

@implementation BouncyComponent

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.bounceSpeed = kDefaultBounceSpeed;
        self.baseAnchorPoint = CGPointMake(0.5f, 0.5f);
    }
    return self;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    SpriteComponent *sprite = (SpriteComponent*)[self.entity componentForClass:[SpriteComponent class]];

    if (self.bouncing) {
        self.bounceTime += seconds;
        CGFloat offset = fabs(sin(self.bounceTime / (self.bounceSpeed / 2.0f))) / 3.0f;
        sprite.sprite.anchorPoint = CGPointMake(self.baseAnchorPoint.x, self.baseAnchorPoint.y - offset);
    }
}

- (void)startBouncing
{
    self.bounceTime = 0.0f;
    self.bouncing = YES;
}

- (void)stopBouncing
{
    self.bouncing = NO;

    SpriteComponent *sprite = (SpriteComponent*)[self.entity componentForClass:[SpriteComponent class]];
    sprite.sprite.anchorPoint = self.baseAnchorPoint;
}

@end
