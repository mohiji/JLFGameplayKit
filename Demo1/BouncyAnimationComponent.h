//
//  BouncyAnimationComponent.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/25/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "JLFGKComponent.h"
@import SpriteKit;

extern const CGFloat kDefaultBounceSpeed;

@interface BouncyAnimationComponent : JLFGKComponent

- (id)initWithBaseTextureName:(NSString *)baseTextureName characterAtlas:(SKTextureAtlas *)atlas;

@property (assign, nonatomic) CGFloat bounceSpeed;

@end
