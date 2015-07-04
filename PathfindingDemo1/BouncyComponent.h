//
//  BouncyComponent.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/3/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "JLFGKComponent.h"

extern const CGFloat kDefaultBounceSpeed;
extern const CGFloat kDefaultBaseAnchorHeight;

@interface BouncyComponent : JLFGKComponent

@property (assign, nonatomic) CGFloat bounceSpeed;
@property (assign, nonatomic) CGFloat baseAnchorHeight;

- (void)startBouncing;
- (void)stopBouncing;

@end
