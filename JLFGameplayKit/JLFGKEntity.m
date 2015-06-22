//
//  JLFGKEntity.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/21/15.
//

#import "JLFGKEntity.h"
#import "JLFGKComponent+Private.h"

@interface JLFGKEntity ()

@property (nonatomic, strong) NSMapTable *componentMap;

@end

@implementation JLFGKEntity

+ (instancetype)entity
{
    return [[JLFGKEntity alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        _componentMap = [NSMapTable mapTableWithKeyOptions:NSMapTableObjectPointerPersonality
                                              valueOptions:NSMapTableStrongMemory];
    }
    return self;
}

- (NSArray *)components
{
    return [[self.componentMap objectEnumerator] allObjects];
}

- (JLFGKComponent *)componentForClass:(Class)componentClass
{
    return [self.componentMap objectForKey:componentClass];
}

- (void)addComponent:(JLFGKComponent *)component
{
    NSAssert(component != nil, @"Cannot add nil as a component.");
    NSAssert([component isKindOfClass:[JLFGKComponent class]], @"An entity's components must be subclasses of JLFGKComponent.");

    component.entity = self;
    [self.componentMap setObject:component forKey:[component class]];
}

- (void)removeComponentForClass:(Class)componentClass
{
    JLFGKComponent *component = [self.componentMap objectForKey:componentClass];
    component.entity = nil;
    [self.componentMap removeObjectForKey:componentClass];
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    // Making a copy of the components before iterating over it just in case some component decides
    // to add or remove components during the updateWithDeltaTime call.
    NSArray *componentsCopy = self.components;
    for (JLFGKComponent *component in componentsCopy) {
        [component updateWithDeltaTime:seconds];
    }
}

@end
