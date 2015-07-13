//
//  JLFGKGridGraphNode.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/11/15.
//

#import "JLFGKGridGraphNode.h"

@implementation JLFGKGridGraphNode

+ (instancetype)nodeWithGridPosition:(vector_int2)position
{
    return [[[self class] alloc] initWithGridPosition:position];
}

- (instancetype)initWithGridPosition:(vector_int2)position
{
    self = [super init];
    if (self != nil) {
        self.position = position;
    }
    return self;
}

- (float)estimatedCostToNode:(JLFGKGraphNode *)node
{
    NSAssert([node isKindOfClass:[JLFGKGridGraphNode class]], @"JLFGKGridGraphNode -estimatedCostToNode: Only works with grid graph nodes, not general graph nodes.");
    JLFGKGridGraphNode *goal = (JLFGKGridGraphNode *)node;

    // Using Chebyshev distance at the moment. See:
    // http://theory.stanford.edu/~amitp/GameProgramming/Heuristics.html#heuristics-for-grid-maps
    //
    // for details.
    float dx = abs(self.position.x - goal.position.x);
    float dy = abs(self.position.y - goal.position.y);
    return (dx + dy) - 1 * MIN(dx, dy);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"JLFGKGridGraphNode {%d, %d}", self.position.x, self.position.y];
}

@end
                                                                                                                                                                                                                                       