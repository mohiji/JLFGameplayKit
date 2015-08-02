//
//  JLFGKRandom.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 8/2/15.
//

@import Foundation;

@protocol JLFGKRandom <NSObject>

- (NSInteger)nextInt;
- (NSUInteger)nextIntWithUpperBound:(NSUInteger)upperBound;
- (float)nextUniform;
- (BOOL)nextBool;

@end