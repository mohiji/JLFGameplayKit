//
//  JLFGKGridGraph.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/11/15.
//

#import "JLFGKGridGraph.h"

static void addToArrayIfNotNil(NSMutableArray *array, id obj)
{
    if (obj != nil) {
        [array addObject:obj];
    }
}

@interface JLFGKGridGraph ()

@property (strong, nonatomic) NSMutableArray *gridNodes;

@end

@implementation JLFGKGridGraph

@synthesize gridOrigin = _gridOrigin;
@synthesize gridWidth = _gridWidth;
@synthesize gridHeight = _gridHeight;
@synthesize diagonalsAllowed = _diagonalsAllowed;

+ (instancetype)graphFromGridStartingAt:(vector_int2)position
                                  width:(int)width
                                 height:(int)height
                       diagonalsAllowed:(BOOL)diagonalsAllowed
{
    return [[[self class] alloc] initFromGridStartingAt:position
                                                  width:width
                                                 height:height
                                       diagonalsAllowed:diagonalsAllowed];
}

- (instancetype)initFromGridStartingAt:(vector_int2)position
                                 width:(int)width
                                height:(int)height
                      diagonalsAllowed:(BOOL)diagonalsAllowed
{
    NSAssert(width > 0, @"JLFGKGridGraph -initFromGridStartingAt:width:height:diagonalsAllowed: Cannot create a grid graph with width < 1.");
    NSAssert(height > 0, @"JLFGKGridGraph -initFromGridStartingAt:width:height:diagonalsAllowed: Cannot create a grid graph with height < 1.");

    // Before we get to initializing the object, we're going to build up the graph nodes so that we can call [super initWithNodes:]
    NSUInteger numNodes = width * height;
    NSMutableArray *gridNodes = [NSMutableArray arrayWithCapacity:numNodes];

    int minX = position.x;
    int minY = position.y;
    int maxX = minX + width;
    int maxY = minY + height;
    for (int y = minY; y < maxY; y++) {
        for (int x = minX; x < maxX; x++) {
            [gridNodes addObject:[JLFGKGridGraphNode nodeWithGridPosition:(vector_int2){x, y}]];
        }
    }

    self = [super initWithNodes:gridNodes];
    if (self != nil) {
        _gridOrigin = position;
        _gridWidth = width;
        _gridHeight = height;
        _diagonalsAllowed = diagonalsAllowed;
        self.gridNodes = gridNodes;

        // A freshly created grid graph starts out fully connected.
        for (JLFGKGridGraphNode *node in gridNodes) {
            [self connectNodeToAdjacentNodes:node];
        }
    }

    return self;
}

- (JLFGKGridGraphNode *)nodeAtGridPosition:(vector_int2)position
{
    // Make sure the given position is in the proper range.
    if (position.x < self.gridOrigin.x) return nil;
    if (position.y < self.gridOrigin.y) return nil;
    if (position.x >= self.gridOrigin.x + self.gridWidth) return nil;
    if (position.y >= self.gridOrigin.y + self.gridHeight) return nil;

    int idx = (position.y - self.gridOrigin.y) * (int)self.gridWidth + (position.x - self.gridOrigin.x);
    return self.gridNodes[idx];
}

- (void)connectNodeToAdjacentNodes:(JLFGKGridGraphNode *)node
{
    vector_int2 pos = node.position;

    NSMutableArray *newConnections = [NSMutableArray arrayWithCapacity:8];
    addToArrayIfNotNil(newConnections, [self nodeAtGridPosition:(vector_int2){pos.x - 1, pos.y}]);
    addToArrayIfNotNil(newConnections, [self nodeAtGridPosition:(vector_int2){pos.x + 1, pos.y}]);
    addToArrayIfNotNil(newConnections, [self nodeAtGridPosition:(vector_int2){pos.x, pos.y - 1}]);
    addToArrayIfNotNil(newConnections, [self nodeAtGridPosition:(vector_int2){pos.x, pos.y + 1}]);

    if (self.diagonalsAllowed) {
        addToArrayIfNotNil(newConnections, [self nodeAtGridPosition:(vector_int2){pos.x - 1, pos.y - 1}]);
        addToArrayIfNotNil(newConnections, [self nodeAtGridPosition:(vector_int2){pos.x + 1, pos.y - 1}]);
        addToArrayIfNotNil(newConnections, [self nodeAtGridPosition:(vector_int2){pos.x - 1, pos.y + 1}]);
        addToArrayIfNotNil(newConnections, [self nodeAtGridPosition:(vector_int2){pos.x + 1, pos.y + 1}]);
    }

    [node addConnectionsToNodes:newConnections bidirectional:YES];
}

@end
