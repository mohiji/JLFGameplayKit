//
//  AnimationComponent.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/25/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "CharacterAnimationComponent.h"
#import "SpriteComponent.h"
#import "MoveComponent.h"
#import "JLFGKEntity.h"

typedef NS_ENUM(NSUInteger, AnimationFacing)
{
    FacingLeft,
    FacingRight,
    FacingUp,
    FacingDown
};

static NSString *directionForFacing(AnimationFacing facing)
{
    switch (facing) {
        case FacingLeft:
            return @"left";

        case FacingRight:
            return @"right";

        case FacingDown:
            return @"down";

        case FacingUp:
            return @"up";
    }
}

@interface CharacterAnimationComponent ()

@property (copy, nonatomic) NSString *baseTextureName;
@property (strong, nonatomic) SKTextureAtlas *atlas;

@property (assign, nonatomic) BOOL wasMoving;
@property (assign, nonatomic) AnimationFacing facing;
@property (assign, nonatomic) CFTimeInterval animationTime;

@property (assign, nonatomic) BOOL isWaving;

@end

@implementation CharacterAnimationComponent

- (id)initWithBaseTextureName:(NSString *)baseTextureName characterAtlas:(id)atlas
{
    NSAssert(baseTextureName != nil && baseTextureName.length > 0, @"Bad texture name");
    NSAssert(atlas != nil, @"Bad character atlas");

    self = [super init];
    if (self != nil) {
        self.baseTextureName = baseTextureName;
        self.atlas = atlas;
        self.facing = FacingDown;
    }
    return self;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    SpriteComponent *c = (SpriteComponent *)[self.entity componentForClass:[SpriteComponent class]];
    MoveComponent *m = (MoveComponent *)[self.entity componentForClass:[MoveComponent class]];
    if (c != nil && m != nil) {
        SKSpriteNode *node = c.sprite;

        NSString *textureName = @"stand-down";
        if (self.isWaving) {
            self.animationTime += seconds;
            int animationFrame = (int)floor(self.animationTime / 0.2) % 2 + 1;
            textureName = [NSString stringWithFormat:@"wave-%d", animationFrame];
        } else {

            // Is the entity moving? If not, just make sure it's using the right standing texture
            if (!m.moving) {
                self.wasMoving = NO;
                textureName = [NSString stringWithFormat:@"stand-%@", directionForFacing(self.facing)];
            } else {
                // The entity's moving. If it wasn't moving last frame, reset the movement timer.
                if (!self.wasMoving) {
                    self.animationTime = 0;
                    self.wasMoving = YES;
                } else {
                    self.animationTime += seconds;
                }

                CGPoint direction = m.moveDirection;
                if (fabs(direction.x) > fabs(direction.y)) {
                    self.facing = (direction.x > 0) ? FacingRight : FacingLeft;
                } else {
                    self.facing = (direction.y > 0) ? FacingUp : FacingDown;
                }

                NSString *dirName = directionForFacing(self.facing);
                int animationFrame = (int)floor(self.animationTime / 0.2) % 4 + 1;
                textureName = [NSString stringWithFormat:@"walk-%@-%d", dirName, animationFrame];
            }
        }

        textureName = [NSString stringWithFormat:@"%@-%@", self.baseTextureName, textureName];
        node.texture = [self.atlas textureNamed:textureName];
    }
}

- (BOOL)hasWavingAnimation
{
    return [self.baseTextureName isEqualToString:@"man"];
}

- (void)startWaving
{
    if (![self hasWavingAnimation]) {
        return;
    }

    self.isWaving = YES;
    self.animationTime = 0;
}

- (void)stopWaving
{
    self.isWaving = NO;
    self.animationTime = 0;
}

@end
