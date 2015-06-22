//
//  JLFGKEntity.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/21/15.
//

#import <Foundation/Foundation.h>
#import "JLFGKComponent.h"

@interface JLFGKEntity : NSObject

+ (instancetype)entity;
- (instancetype)init;

@property (nonatomic, readonly, retain) NSArray *components;

- (JLFGKComponent *)componentForClass:(Class)componentClass;
- (void)addComponent:(JLFGKComponent *)component;
- (void)removeComponentForClass:(Class)componentClass;

- (void)updateWithDeltaTime:(NSTimeInterval)seconds;

@end
