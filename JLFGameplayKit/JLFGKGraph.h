//
//  JLFGKGraph.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLFGKGraphNode.h"

@interface JLFGKGraph : NSObject

+ (instancetype)graphWithNodes:(NSArray *)nodes;
- (instancetype)initWithNodes:(NSArray *)nodes;

@property (nonatomic, readonly) NSArray *nodes;

- (void)addNodes:(NSArray *)nodes;
- (void)connectNodeToLowestCostNode:(JLFGKGraphNode *)node
                      bidirectional:(BOOL)bidirectional;

- (void)removeNodes:(NSArray *)nodes;
- (NSArray *)findPathFromNode:(JLFGKGraphNode *)startNode
                       toNode:(JLFGKGraphNode *)endNode;

@end
