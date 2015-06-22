//
//  JLFGKComponent.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/21/15.
//

#import <Foundation/Foundation.h>
@class JLFGKEntity;

@interface JLFGKComponent : NSObject

@property (nonatomic, readonly, weak) JLFGKEntity *entity;

- (void)updateWithDeltaTime:(NSTimeInterval)seconds;

@end
