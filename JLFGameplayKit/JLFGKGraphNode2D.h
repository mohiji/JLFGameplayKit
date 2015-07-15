//
//  JLFGKGraphNode2D.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/15/15.
//

#import "JLFGKGraphNode.h"
#import <simd/vector.h>

@interface JLFGKGraphNode2D : JLFGKGraphNode

+ (instancetype)nodeWithPoint:(vector_float2)point;
- (instancetype)initWithPoint:(vector_float2)point;

@property (assign, nonatomic) vector_float2 position;

@end
