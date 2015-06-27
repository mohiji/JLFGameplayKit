//
//  AnimationComponent.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/25/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "JLFGKComponent.h"
@import SpriteKit;

@interface CharacterAnimationComponent : JLFGKComponent

- (id)initWithBaseTextureName:(NSString *)baseTextureName characterAtlas:(SKTextureAtlas *)atlas;

- (BOOL)hasWavingAnimation;
- (void)startWaving;
- (void)stopWaving;

@end
