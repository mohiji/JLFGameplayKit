//
//  GameScene.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/21/15.
//

#import "GameScene.h"
#import "JLFGKEntity.h"
#import "SpriteComponent.h"
#import "MoveComponent.h"
#import "CharacterAnimationComponent.h"

@interface GameScene ()

@property (strong, nonatomic) JLFGKEntity *playerEntity;

@property (assign, nonatomic) BOOL clickActive;
@property (assign, nonatomic) CGPoint clickLocation;

@property (assign, nonatomic) CFTimeInterval lastUpdateTime;
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    self.playerEntity = [self makePlayerEntity];
    SKSpriteNode *playerSprite = [(SpriteComponent *)[self.playerEntity componentForClass:[SpriteComponent class]] sprite];

    SKNode *playerStart = [self childNodeWithName:@"player_start"];
    playerSprite.position = playerStart.position;
    [self addChild:playerSprite];
}

-(void)mouseDown:(NSEvent *)theEvent {
    MoveComponent *component = (MoveComponent *)[self.playerEntity componentForClass:[MoveComponent class]];
    if (component != nil) {
        CGPoint location = [theEvent locationInNode:self];
        component.moving = YES;
        component.moveTarget = location;
    } else {
        NSLog(@"mouseDown: Missing player movement component.");
    }
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    MoveComponent *component = (MoveComponent *)[self.playerEntity componentForClass:[MoveComponent class]];
    if (component != nil) {
        CGPoint location = [theEvent locationInNode:self];
        component.moving = YES;
        component.moveTarget = location;
    }
}

- (void)mouseUp:(NSEvent *)theEvent
{
    MoveComponent *component = (MoveComponent *)[self.playerEntity componentForClass:[MoveComponent class]];
    if (component != nil) {
        component.moving = NO;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    CFTimeInterval lastUpdate = self.lastUpdateTime;
    self.lastUpdateTime = currentTime;

    CFTimeInterval deltaTime = currentTime - lastUpdate;
    if (deltaTime > 0) {
        [self.playerEntity updateWithDeltaTime:deltaTime];
    }
}

- (JLFGKEntity *)makePlayerEntity
{
    SKSpriteNode *sprite = [[SKSpriteNode alloc] initWithImageNamed:@"woman-stand-down"];
    CGSize sizeBeforeScale = sprite.size;
    sprite.scale = 2.5;

    sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(sprite.size.width, sprite.size.height / 2.0f) center:CGPointMake(0.0f, -sizeBeforeScale.height * 0.75f)];
    sprite.physicsBody.dynamic = YES;
    sprite.physicsBody.affectedByGravity = NO;
    sprite.physicsBody.allowsRotation = NO;

    SpriteComponent *spriteComponent = [[SpriteComponent alloc] init];
    spriteComponent.sprite = sprite;

    MoveComponent *moveComponent = [[MoveComponent alloc] init];
    CharacterAnimationComponent *animComponent = [[CharacterAnimationComponent alloc] initWithBaseTextureName:@"woman" characterAtlas:self.characterAtlas];

    JLFGKEntity *entity = [JLFGKEntity entity];
    [entity addComponent:spriteComponent];
    [entity addComponent:moveComponent];
    [entity addComponent:animComponent];

    return entity;
}
@end
