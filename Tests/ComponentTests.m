//
//  ComponentTests.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/21/15.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "JLFGKEntity.h"
#import "JLFGKComponent.h"
#import "JLFGKComponentSystem.h"

@interface TestComponent : JLFGKComponent

@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) BOOL updateCalled;

@end

@implementation TestComponent

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    self.updateCalled = YES;
}

@end

@interface SecondTestComponent : JLFGKComponent

@end

@implementation SecondTestComponent

@end

@interface ComponentTests : XCTestCase

@end

@implementation ComponentTests

- (void)testAddComponentsToEntity
{
    JLFGKEntity *entity = [JLFGKEntity entity];
    JLFGKComponent *component = [JLFGKComponent new];

    XCTAssertNil(component.entity);
    [entity addComponent:component];
    XCTAssertEqual(entity, component.entity);
}

- (void)testEntityCallsUpdate
{
    JLFGKEntity *entity = [JLFGKEntity entity];
    TestComponent *component = [TestComponent new];
    [entity addComponent:component];

    XCTAssertFalse(component.updateCalled);
    [entity updateWithDeltaTime:1];
    XCTAssertTrue(component.updateCalled);
}

- (void)testComponentsAreReplacedInEntity
{
    JLFGKEntity *entity = [JLFGKEntity entity];

    TestComponent *componentOne = [TestComponent new];
    componentOne.value = 1;

    TestComponent *componentTwo = [TestComponent new];
    componentTwo.value = 2;

    [entity addComponent:componentOne];
    [entity addComponent:componentTwo];
    XCTAssertEqual(1, entity.components.count);

    TestComponent *component = (TestComponent *)[entity componentForClass:[TestComponent class]];
    XCTAssertEqual(componentTwo.value, component.value);
}

- (void)testEntityRemovesComponents
{
    JLFGKEntity *entity = [JLFGKEntity entity];
    TestComponent *component = [TestComponent new];

    XCTAssertEqual(0, entity.components.count);
    [entity addComponent:component];
    XCTAssertEqual(1, entity.components.count);
    [entity removeComponentForClass:[TestComponent class]];
    XCTAssertEqual(0, entity.components.count);
    XCTAssertNil(component.entity);
}

- (void)testComponentSystemMustUseDesignatedInitializer
{
    XCTAssertThrows([[JLFGKComponentSystem alloc] init]);
}

- (void)testComponentSystemOnlyAllowsOneTypeOfComponent
{
    JLFGKComponentSystem *system = [[JLFGKComponentSystem alloc] initWithComponentClass:[TestComponent class]];
    XCTAssertNoThrow([system addComponent:[TestComponent new]]);
    XCTAssertThrows([system addComponent:[SecondTestComponent new]]);
}

- (void)testComponentSystemClassIsCorrect
{
    JLFGKComponentSystem *system = [[JLFGKComponentSystem alloc] initWithComponentClass:[TestComponent class]];
    TestComponent *component = [TestComponent new];

    XCTAssertEqual([TestComponent class], system.componentClass);
    XCTAssertEqual([component class], system.componentClass);
}

- (void)testComponentSystemAddComponents
{
    JLFGKComponentSystem *system = [[JLFGKComponentSystem alloc] initWithComponentClass:[TestComponent class]];
    for (int i = 0; i < 12; i++) {
        [system addComponent:[TestComponent new]];
    }

    XCTAssertEqual(12, system.components.count);
}

- (void)testComponentSystemRemoveComponents
{
    JLFGKComponentSystem *system = [[JLFGKComponentSystem alloc] initWithComponentClass:[TestComponent class]];

    TestComponent *oneComponent = [TestComponent new];
    TestComponent *twoComponent = [TestComponent new];
    TestComponent *redComponent = [TestComponent new];
    TestComponent *blueComponent = [TestComponent new];

    for (JLFGKComponent *c in @[oneComponent, twoComponent, redComponent, blueComponent]) {
        [system addComponent:c];
    }

    XCTAssertEqual(4, system.components.count);
    XCTAssertTrue([system.components containsObject:oneComponent]);
    XCTAssertTrue([system.components containsObject:twoComponent]);
    XCTAssertTrue([system.components containsObject:redComponent]);
    XCTAssertTrue([system.components containsObject:blueComponent]);

    [system removeComponent:redComponent];
    XCTAssertEqual(3, system.components.count);
    XCTAssertFalse([system.components containsObject:redComponent]);
}

- (void)testComponentSystemAddRemoveWithEntity
{
    JLFGKComponentSystem *system = [[JLFGKComponentSystem alloc] initWithComponentClass:[TestComponent class]];
    JLFGKEntity *entity = [JLFGKEntity entity];
    TestComponent *component = [TestComponent new];

    [entity addComponent:component];
    [system addComponentWithEntity:entity];

    XCTAssertEqual(1, system.components.count);
    XCTAssertTrue([system.components containsObject:component]);

    [system removeComponentWithEntity:entity];
    XCTAssertEqual(0, system.components.count);
    XCTAssertFalse([system.components containsObject:component]);
}

@end