//
//  JLFGKObstacleGraphConnection.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/19/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "JLFGKObstacleGraphConnection.h"
#import "JLFGKGeometry.h"

@interface JLFGKObstacleGraphConnection ()

@property (strong, nonatomic) JLFGKGraphNode2D *from;
@property (strong, nonatomic) JLFGKGraphNode2D *to;

@end

@implementation JLFGKObstacleGraphConnection

+ (instancetype)connectionFromNode:(JLFGKGraphNode2D *)from
                            toNode:(JLFGKGraphNode2D *)to
{
    return [[[self class] alloc] initWithFromNode:from
                                           toNode:to];
}

- (instancetype)initWithFromNode:(JLFGKGraphNode2D *)from
                          toNode:(JLFGKGraphNode2D *)to
{
    self = [super init];
    if (self != nil) {
        self.from = from;
        self.to = to;
    }
    return self;
}


@end
