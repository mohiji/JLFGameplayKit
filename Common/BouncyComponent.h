//
//  BouncyComponent.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/3/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "JLFGKComponent.h"
@import CoreGraphics;

extern const float kDefaultBounceSpeed;
extern const float kDefaultBaseAnchorHeight;

@interface BouncyComponent : JLFGKComponent

@property (assign, nonatomic) float bounceSpeed;
@property (assign, nonatomic) CGPoint baseAnchorPoint;

- (void)startBouncing;
- (void)stopBouncing;

@end
