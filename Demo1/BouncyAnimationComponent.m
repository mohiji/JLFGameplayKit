//
//  BouncyAnimationComponent.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/25/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "BouncyAnimationComponent.h"
#import "MoveComponent.h"
#import "SpriteComponent.h"
#import "JLFGKEntity.h"

const CGFloat kDefaultBounceSpeed = 0.1f;

@interface BouncyAnimationComponent ()

@property (copy,   nonatomic) NSString *baseTextureName;
@property (strong, nonatomic) SKTextureAtlas *characterAtlas;

@property (assign, nonatomic) BOOL bouncing;
@property (assign, nonatomic) CFTimeInterval bounceTime;
@property (assign, nonatomic) CFTimeInterval shouldStopBouncingTime;

@end

@implementation BouncyAnimationComponent

- (id)initWithBaseTextureName:(NSString *)baseTextureName characterAtlas:(SKTextureAtlas *)atlas
{
    self = [super init];
    if (self != nil) {
        self.baseTextureName = baseTextureName;
        self.characterAtlas = atlas;
        self.bounceSpeed = kDefaultBounceSpeed;
    }

    return self;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    MoveComponent *move = (MoveComponent*)[self.entity componentForClass:[MoveComponent class]];
    SpriteComponent *sprite = (SpriteComponent*)[self.entity componentForClass:[SpriteComponent class]];

    const BOOL startBouncing = (self.bouncing == NO && move.moving == YES);
    const BOOL stopBouncing = (self.bouncing == YES && move.moving == NO);

    if (startBouncing) {
        self.bouncing = YES;
        self.bounceTime = 0.0f;
    }

    if (stopBouncing) {
        self.bouncing = NO;
        sprite.sprite.anchorPoint = CGPointMake(0.5f, 0.5f);
    }

    if (self.bouncing) {
        self.bounceTime += seconds;
        CGFloat offset = fabs(sin(self.bounceTime / (self.bounceSpeed / 2.0f))) / 3.0f;
        sprite.sprite.anchorPoint = CGPointMake(0.5f, 0.5f - offset);
    }

    NSString *textureName;
    if (move.moveDirection.x > 0) {
        textureName = [self.baseTextureName stringByAppendingString:@"-right"];
    } else {
        textureName = [self.baseTextureName stringByAppendingString:@"-left"];
    }
    sprite.sprite.texture = [self.characterAtlas textureNamed:textureName];
}

@end
