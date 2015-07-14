//
//  CellularAutomata.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/13/15.
//
//  A really basic cellular automata class used to generate the maps in the demo.

#import "CellularAutomata.h"

@implementation CellularAutomata
@synthesize width = _width;
@synthesize height = _height;
@synthesize cells = _cells;

+ (instancetype)cellularAutomataWithWidth:(NSUInteger)width height:(NSUInteger)height
{
    return [[[self class] alloc] initWithWidth:width height:height];
}

+ (instancetype)randomlyFilledCellularAutomataWithWidth:(NSUInteger)width
                                                 height:(NSUInteger)height
                                          percentFilled:(float)percentFilled
{
    CellularAutomata *automata = [[self class] cellularAutomataWithWidth:width height:height];
    if (automata == nil) {
        return nil;
    }

    const NSUInteger numCells = width * height;
    for (int i = 0; i < numCells; i++) {
        float chance = arc4random_uniform(1000) / 1000.0f;
        if (chance < percentFilled) {
            automata.cells[i] = YES;
        }
    }

    return automata;
}

- (id)initWithWidth:(NSUInteger)width height:(NSUInteger)height
{
    NSAssert(width > 0, @"CellularAutomata -initWithWidth:height: Doesn't work with width < 1.");
    NSAssert(height > 0, @"CellularAutomata -initWithWidth:height: Doesn't work with height < 1.");

    self = [super init];
    if (self != nil) {
        _width = width;
        _height = height;
        _cells = calloc(sizeof(BOOL), width * height);
    }
    return self;
}

- (BOOL)cellIsWallAtX:(NSUInteger)x y:(NSUInteger)y
{
    if (x >= self.width) {
        return true;
    }

    if (y >= self.height) {
        return true;
    }

    return self.cells[x + y * self.width] != NO;
}

- (int)countNeighborsOfCellAtX:(NSUInteger)x y:(NSUInteger)y
{
    int numNeighbors = 0;

    if ([self cellIsWallAtX:x-1 y:y-1]) numNeighbors++;
    if ([self cellIsWallAtX:x   y:y-1]) numNeighbors++;
    if ([self cellIsWallAtX:x+1 y:y-1]) numNeighbors++;
    if ([self cellIsWallAtX:x-1 y:y  ]) numNeighbors++;
    if ([self cellIsWallAtX:x+1 y:y  ]) numNeighbors++;
    if ([self cellIsWallAtX:x-1 y:y+1]) numNeighbors++;
    if ([self cellIsWallAtX:x   y:y+1]) numNeighbors++;
    if ([self cellIsWallAtX:x+1 y:y+1]) numNeighbors++;

    return numNeighbors;
}

- (CellularAutomata *)nextGenerationWithRule:(CellularAutomataGenerationRule)rule
{
    NSAssert(rule != nil, @"CellularAutomata -nextGenerationWithRule: Rule cannot be nil.");

    CellularAutomata *next = [CellularAutomata cellularAutomataWithWidth:self.width height:self.height];
    for (int y = 0; y < self.height; y++) {
        for (int x = 0; x < self.width; x++) {
            int numNeighbors = [self countNeighborsOfCellAtX:x y:y];

            if (rule(numNeighbors)) {
                next.cells[x + y * self.width] = YES;
            }
        }
    }

    return next;
}

@end
