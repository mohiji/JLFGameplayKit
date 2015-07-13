//
//  JLFGKGridGraph.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/11/15.
//

#import "JLFGKGraph.h"
#import "JLFGKGridGraphNode.h"

@interface JLFGKGridGraph : JLFGKGraph

+ (instancetype)graphFromGridStartingAt:(vector_int2)position
                                  width:(int)width
                                 height:(int)height
                       diagonalsAllowed:(BOOL)diagonalsAllowed;

- (instancetype)initFromGridStartingAt:(vector_int2)position
                                 width:(int)width
                                height:(int)height
                      diagonalsAllowed:(BOOL)diagonalsAllowed;

@property (readonly, nonatomic) BOOL diagonalsAllowed;
@property (readonly, nonatomic) vector_int2 gridOrigin;
@property (readonly, nonatomic) NSUInteger gridWidth;
@property (readonly, nonatomic) NSUInteger gridHeight;

- (JLFGKGridGraphNode *)nodeAtGridPosition:(vector_int2)position;
- (void)connectNodeToAdjacentNodes:(JLFGKGridGraphNode *)node;

@end
