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
#import "WanderComponent.h"
#import "CharacterAnimationComponent.h"
#import "BouncyAnimationComponent.h"

@interface GameScene ()

@property (strong, nonatomic) JLFGKEntity *playerEntity;
@property (strong, nonatomic) NSMutableArray *otherCharacters;

@property (assign, nonatomic) BOOL clickActive;
@property (assign, nonatomic) CGPoint clickLocation;

@property (assign, nonatomic) CFTimeInterval lastUpdateTime;
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    self.playerEntity = [self makeCharacterEntityWithBaseTextureName:@"woman"];
    SKSpriteNode *playerSprite = [(SpriteComponent *)[self.playerEntity componentForClass:[SpriteComponent class]] sprite];

    SKNode *playerStart = [self childNodeWithName:@"player_start"];
    playerSprite.position = playerStart.position;
    [self addChild:playerSprite];
    [playerStart removeFromParent];

    // Create the other characters
    self.otherCharacters = [NSMutableArray array];
    [self enumerateChildNodesWithName:@"character*" usingBlock:^(SKNode *node, BOOL *stop) {
        NSString *baseTexture = [node.name stringByReplacingOccurrencesOfString:@"character_" withString:@""];
        JLFGKEntity *entity = [self makeCharacterEntityWithBaseTextureName:baseTexture];
        [entity addComponent:[[WanderComponent alloc] init]];
        [self.otherCharacters addObject:entity];

        SKSpriteNode *sprite = [(SpriteComponent *)[entity componentForClass:[SpriteComponent class]] sprite];
        sprite.position = node.position;
        [self addChild:sprite];
        [node removeFromParent];
    }];

    [self enumerateChildNodesWithName:@"bouncer" usingBlock:^(SKNode *node, BOOL *stop) {
        JLFGKEntity *entity = [self makeBouncer];
        [self.otherCharacters addObject:entity];

        SKSpriteNode *sprite = [(SpriteComponent *)[entity componentForClass:[SpriteComponent class]] sprite];
        sprite.position = node.position;
        [self addChild:sprite];
        [node removeFromParent];

    }];
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
    if (deltaTime < 1.0f) {
        [self.playerEntity updateWithDeltaTime:deltaTime];
        for (JLFGKEntity *entity in self.otherCharacters) {
            [entity updateWithDeltaTime:deltaTime];
        }
    }
}

- (JLFGKEntity *)makeCharacterEntityWithBaseTextureName:(NSString *)baseTextureName
{
    SKSpriteNode *sprite = [[SKSpriteNode alloc] initWithImageNamed:[NSString stringWithFormat:@"%@-stand-down", baseTextureName]];
    CGSize sizeBeforeScale = sprite.size;
    sprite.scale = 2.5;

    sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(sprite.size.width, sprite.size.height / 2.0f) center:CGPointMake(0.0f, -sizeBeforeScale.height * 0.75f)];
    sprite.physicsBody.dynamic = YES;
    sprite.physicsBody.affectedByGravity = NO;
    sprite.physicsBody.allowsRotation = NO;

    SpriteComponent *spriteComponent = [[SpriteComponent alloc] init];
    spriteComponent.sprite = sprite;

    MoveComponent *moveComponent = [[MoveComponent alloc] init];
    CharacterAnimationComponent *animComponent = [[CharacterAnimationComponent alloc] initWithBaseTextureName:baseTextureName characterAtlas:self.characterAtlas];

    JLFGKEntity *entity = [JLFGKEntity entity];
    [entity addComponent:spriteComponent];
    [entity addComponent:moveComponent];
    [entity addComponent:animComponent];
    
    return entity;
}

- (JLFGKEntity *)makeBouncer
{
    SKSpriteNode *sprite = [[SKSpriteNode alloc] initWithImageNamed:@"ranger-right"];
    CGSize sizeBeforeScale = sprite.size;
    sprite.scale = 2.5;

    sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(sprite.size.width, sprite.size.height / 2.0f) center:CGPointMake(0.0f, -sizeBeforeScale.height * 0.75f)];
    sprite.physicsBody.dynamic = YES;
    sprite.physicsBody.affectedByGravity = NO;
    sprite.physicsBody.allowsRotation = NO;

    SpriteComponent *spriteComponent = [[SpriteComponent alloc] init];
    spriteComponent.sprite = sprite;

    BouncyAnimationComponent *animComponent = [[BouncyAnimationComponent alloc] initWithBaseTextureName:@"ranger" characterAtlas:self.characterAtlas];

    JLFGKEntity *entity = [JLFGKEntity entity];
    [entity addComponent:spriteComponent];
    [entity addComponent:[[MoveComponent alloc] init]];
    [entity addComponent:animComponent];
    [entity addComponent:[[WanderComponent alloc] init]];

    return entity;
}

@end
