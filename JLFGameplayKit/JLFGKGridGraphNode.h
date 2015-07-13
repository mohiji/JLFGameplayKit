//
//  JLFGKGridGraphNode.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/11/15.
//

#import "JLFGKGraphNode.h"
#import <simd/vector.h>

@interface JLFGKGridGraphNode : JLFGKGraphNode

+ (instancetype)nodeWithGridPosition:(vector_int2)position;
- (instancetype)initWithGridPosition:(vector_int2)position;

@property (assign, nonatomic) vector_int2 position;

@end
