//
//  JLFGKObstacleGraphUserNode.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/20/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "JLFGKObstacleGraphUserNode.h"

@interface JLFGKObstacleGraphUserNode ()

@property (strong, nonatomic) JLFGKGraphNode2D *node;
@property (strong, nonatomic) NSArray *ignoredObstacles;

@end

@implementation JLFGKObstacleGraphUserNode

- (instancetype)initWithNode:(JLFGKGraphNode2D *)node ignoredObstacles:(NSArray *)obstacles
{
    self = [super init];
    if (self != nil) {
        self.node = node;
        self.ignoredObstacles = [obstacles copy];
    }
    return self;
}

@end
