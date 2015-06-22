//
//  JLFGKComponentSystem.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/21/15.
//

#import "JLFGKComponentSystem.h"
@import ObjectiveC;

@interface JLFGKComponentSystem ()

@property (nonatomic, readwrite, assign) Class componentClass;
@property (nonatomic, strong) NSMutableArray *componentArray;

@end

@implementation JLFGKComponentSystem

- (instancetype)init
{
    NSAssert(false, @"JLFGKComponentSystem must be initialized via the designated initializer -initWithComponentClass:");
    return nil;
}

- (instancetype)initWithComponentClass:(Class)componentClass
{
    NSAssert(componentClass != nil, @"The component class passed to -initWithComponentClass may not be nil.");

    self = [super init];
    if (self != nil) {
        _componentClass = componentClass;
        _componentArray = [NSMutableArray array];
    }

    return self;
}

- (NSArray *)components
{
    return self.componentArray;
}

- (void)addComponent:(JLFGKComponent *)component
{
    NSAssert([component isMemberOfClass:self.componentClass], @"This JLFGKComponentSystem instance only accepts components of type %s", class_getName(self.componentClass));

    // TODO: Should I be checking to make sure a component doesn't exist twice in the array?
    [self.componentArray addObject:component];
}

- (void)addComponentWithEntity:(JLFGKEntity *)entity
{
    JLFGKComponent *component = [entity componentForClass:self.componentClass];
    if (component != nil) {
        [self addComponent:component];
    }
}

- (void)removeComponent:(JLFGKComponent *)component
{
    [self.componentArray removeObject:component];
}

- (void)removeComponentWithEntity:(JLFGKEntity *)entity
{
    JLFGKComponent *component = [entity componentForClass:self.componentClass];
    if (component != nil) {
        [self.componentArray removeObject:component];
    }
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    // Making a copy of the components before iterating over it just in case some component decides
    // to add or remove components during the updateWithDeltaTime call.
    NSArray *components = [self.componentArray copy];
    for (JLFGKComponent *component in components) {
        [component updateWithDeltaTime:seconds];
    }
}

- (JLFGKComponentSystem *)objectAtIndexedSubscript:(NSUInteger)idx
{
    return self.componentArray[idx];
}

@end
