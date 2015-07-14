//
//  CellularAutomata.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/13/15.
//
//  A really basic cellular automata class used to generate the maps in the demo.

#import <Foundation/Foundation.h>

typedef BOOL (^CellularAutomataGenerationRule)(int);

@interface CellularAutomata : NSObject

+ (instancetype)cellularAutomataWithWidth:(NSUInteger)width height:(NSUInteger)height;
+ (instancetype)randomlyFilledCellularAutomataWithWidth:(NSUInteger)width
                                                 height:(NSUInteger)height
                                          percentFilled:(float)percentFilled;

- (instancetype)initWithWidth:(NSUInteger)width height:(NSUInteger)height;

@property (readonly, nonatomic) NSUInteger width;
@property (readonly, nonatomic) NSUInteger height;
@property (readonly, nonatomic) BOOL *cells;

- (CellularAutomata *)nextGenerationWithRule:(CellularAutomataGenerationRule)rule;

- (BOOL)cellIsWallAtX:(NSUInteger)x y:(NSUInteger)y;
- (int)countNeighborsOfCellAtX:(NSUInteger)x y:(NSUInteger)y;

@end
 