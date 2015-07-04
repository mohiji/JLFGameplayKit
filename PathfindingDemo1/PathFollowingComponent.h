//
//  PathFollowingComponent.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/3/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "JLFGKComponent.h"

extern const CGFloat kDefaultPlayerMoveSpeed;

@interface PathFollowingComponent : JLFGKComponent

@property (assign, nonatomic) CGFloat moveSpeed;
@property (readonly, nonatomic) NSUInteger waypointCount;

- (void)followPath:(NSArray *)path;
- (CGPoint)takeNextWaypoint;

@end
