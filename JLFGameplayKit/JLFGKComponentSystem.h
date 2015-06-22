//
//  JLFGKComponentSystem.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/21/15.
//

#import <Foundation/Foundation.h>
#import "JLFGKComponent.h"
#import "JLFGKEntity.h"

@interface JLFGKComponentSystem : NSObject

- (instancetype)initWithComponentClass:(Class)componentClass;

@property (nonatomic, readonly) Class componentClass;
@property (nonatomic, readonly, retain) NSArray *components;

- (void)addComponent:(JLFGKComponent *)component;
- (void)addComponentWithEntity:(JLFGKEntity *)entity;
- (void)removeComponent:(JLFGKComponent *)component;
- (void)removeComponentWithEntity:(JLFGKEntity *)entity;

- (void)updateWithDeltaTime:(NSTimeInterval)seconds;

- (JLFGKComponent *)objectAtIndexedSubscript:(NSUInteger)idx;

@end
