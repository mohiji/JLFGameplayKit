//
//  SpriteComponent.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/24/15.
//  Copyright © 2015 Jonathan Fischer. All rights reserved.
//

#import "SpriteComponent.h"

@implementation SpriteComponent

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    // This is a silly fudge to get things drawing in the order I want.
    // Doing it properly means I'd need to let this component know the full height of the scene.
    self.sprite.zPosition = 10000 - self.sprite.position.y;
}

@end
