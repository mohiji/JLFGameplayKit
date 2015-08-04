//
//  JLFKGRandomSource.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 8/2/15.
//

#import <Foundation/Foundation.h>
#import "JLFGKRandom.h"

@interface JLFGKRandomSource : NSObject<JLFGKRandom, NSCopying, NSSecureCoding>

+ (JLFGKRandomSource *)sharedRandom;
- (NSArray *)arrayByShufflingObjectsInArrays:(NSArray *)array;

@end
