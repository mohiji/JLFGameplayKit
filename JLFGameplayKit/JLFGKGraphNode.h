//
//  JLFGKGraphNode.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/1/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLFGKGraphNode : NSObject

@property (readonly, nonatomic) NSArray *connectedNodes;

- (void)addConnectionsToNodes:(NSArray *)nodes bidirectional:(BOOL)bidirectional;
- (void)removeConnectionsToNodes:(NSArray *)nodes bidirectional:(BOOL)bidirectional;

- (float)costToNode:(JLFGKGraphNode *)node;
- (float)estimatedCostToNode:(JLFGKGraphNode *)node;

- (NSArray *)findPathToNode:(JLFGKGraphNode *)goalNode;
- (NSArray *)findPathFromNode:(JLFGKGraphNode *)startNode;

@end
