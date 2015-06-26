//
//  WanderComponent.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/25/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "WanderComponent.h"
#import "JLFGKEntity.h"
#import "MoveComponent.h"
#import "CGPointMath.h"

static CGFloat waitTime()
{
    // Minimum 1 second, maximum 4 seconds
    return 1.0f + (arc4random_uniform(3000) / 1000.0f);
}

@interface WanderComponent ()

@property (assign, nonatomic) CGFloat waitingTimeLeft;
@property (assign, nonatomic) CGFloat walkingTimeLeft;
@property (assign, nonatomic) CGPoint direction;

@end

@implementation WanderComponent

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.waitingTimeLeft = waitTime();
    }
    return self;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    if (self.waitingTimeLeft > 0) {
        self.waitingTimeLeft -= seconds;

        if (self.waitingTimeLeft < 0) {
            self.waitingTimeLeft = 0.0f;
            self.walkingTimeLeft = waitTime();

            int degrees = arc4random_uniform(360);
            self.direction = CGPointMake(cosf(degrees * M_PI / 180.0f), sinf(degrees * M_PI / 180.0f));
        }
    }

    if (self.walkingTimeLeft > 0) {
        MoveComponent *move = (MoveComponent *)[self.entity componentForClass:[MoveComponent class]];
        self.walkingTimeLeft -= seconds;
        if (self.walkingTimeLeft > 0) {
            CGPoint offset = CGPointScale(self.direction, 50.0f);
            move.moveTarget = CGPointAdd(offset, move.lastLocation);
            move.moving = YES;
        } else {
            move.moving = NO;
            self.walkingTimeLeft = 0.0f;
            self.waitingTimeLeft = waitTime();
        }
    }
}

@end
