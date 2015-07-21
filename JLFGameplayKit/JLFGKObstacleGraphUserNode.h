//
//  JLFGKObstacleGraphUserNode.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/20/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLFGKGraphNode2D.h"

@interface JLFGKObstacleGraphUserNode : NSObject

- (instancetype)initWithNode:(JLFGKGraphNode2D *)node ignoredObstacles:(NSArray *)obstacles;

@property (readonly, nonatomic) JLFGKGraphNode2D *node;
@property (readonly, nonatomic) NSArray *ignoredObstacles;

@end
