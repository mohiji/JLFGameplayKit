//
//  PathMoveComponent.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/14/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "PathMoveComponent.h"
#import "SpriteComponent.h"
#import "BouncyComponent.h"
#import "JLFGKEntity.h"
#import "CGPointMath.h"

const float kPathMoveComponentDefaultDistanceBetweenWaypoints = 32.0f;
const float kPathMoveComponentDefaultMoveSpeed = 140.0f;
static const CGFloat kMoveStopThreshold = 8.0f;

@interface PathMoveComponent ()

@property (strong, nonatomic) NSMutableArray *remainingWaypoints;
@property (assign, nonatomic) BOOL moving;
@property (assign, nonatomic) CGPoint destination;

@property (weak, nonatomic) SpriteComponent *sprite;
@property (weak, nonatomic) BouncyComponent *bouncy;

@end

@implementation PathMoveComponent

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.distanceBetweenWaypoints = kPathMoveComponentDefaultDistanceBetweenWaypoints;
        self.moveSpeed = kPathMoveComponentDefaultMoveSpeed;
    }
    return self;
}

- (void)setNextDestination
{
    JLFGKGridGraphNode *nextWaypoint = self.remainingWaypoints[0];
    self.destination = CGPointMake(nextWaypoint.position.x * self.distanceBetweenWaypoints,
                                   nextWaypoint.position.y * self.distanceBetweenWaypoints);
}

- (void)followPath:(NSArray *)path
{
    BouncyComponent *bouncy = (BouncyComponent *)[self.entity componentForClass:BouncyComponent.class];

    if (path == nil || path.count == 0) {
        [bouncy stopBouncing];
        self.moving = NO;
        self.remainingWaypoints = nil;
    } else {
        self.remainingWaypoints = [path mutableCopy];
        self.moving = YES;
        [self setNextDestination];
        [bouncy startBouncing];
    }
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    if (!self.moving)
    {
        return;
    }

    if (self.sprite != nil) {
        CGPoint deltaV = CGPointSubtract(self.destination, self.sprite.sprite.position);
        if (CGPointMagnitude(deltaV) < kMoveStopThreshold) {
            JLFGKGridGraphNode *nodeReached = self.remainingWaypoints[0];
            [self.remainingWaypoints removeObjectAtIndex:0];

            if (self.waypointCallback != nil) {
                self.waypointCallback(nodeReached);
            }

            if (self.remainingWaypoints.count == 0) {
                // Done, stop moving, make sure the sprite is in exactly the
                // right place, etc.
                self.sprite.sprite.position = self.destination;
                [self.bouncy stopBouncing];
                self.moving = NO;
                self.remainingWaypoints = nil;
                return;
            }

            [self setNextDestination];
        }

        deltaV = CGPointNormalize(deltaV);
        deltaV = CGPointScale(deltaV, self.moveSpeed * seconds);
        self.sprite.sprite.position = CGPointAdd(self.sprite.sprite.position, deltaV);
    }
}

- (SpriteComponent *)sprite
{
    if (_sprite == nil) {
        _sprite = (SpriteComponent *)[self.entity componentForClass:SpriteComponent.class];
    }
    return _sprite;
}

- (BouncyComponent *)bouncy
{
    if (_bouncy == nil) {
        _bouncy = (BouncyComponent *)[self.entity componentForClass:BouncyComponent.class];
    }
    return _bouncy;
}

@end
