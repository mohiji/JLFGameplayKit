//
//  JLFGKObstacleGraphConnection.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/19/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLFGKGraphNode2D.h"
#import "JLFGKPolygonObstacle.h"

@interface JLFGKObstacleGraphConnection : NSObject

+ (instancetype)connectionFromNode:(JLFGKGraphNode2D *)from
                            toNode:(JLFGKGraphNode2D *)to;

- (instancetype)initWithFromNode:(JLFGKGraphNode2D *)from
                          toNode:(JLFGKGraphNode2D *)to;

@property (readonly, nonatomic) JLFGKGraphNode2D *from;
@property (readonly, nonatomic) JLFGKGraphNode2D *to;

@end
