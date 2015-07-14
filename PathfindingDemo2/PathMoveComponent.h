//
//  PathMoveComponent.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/14/15.
//
//  I've written too many of these move components now, huh?

#import "JLFGKComponent.h"
#import "JLFGKGridGraphNode.h"

extern const float kPathMoveComponentDefaultDistanceBetweenWaypoints;
extern const float kPathMoveComponentDefaultMoveSpeed;

typedef void (^WaypointReached)(JLFGKGridGraphNode *waypoint);

@interface PathMoveComponent : JLFGKComponent

@property (copy, nonatomic) WaypointReached waypointCallback;
@property (assign, nonatomic) float distanceBetweenWaypoints;
@property (assign, nonatomic) float moveSpeed;
@property (readonly, nonatomic, getter=isMoving) BOOL moving;

- (void)followPath:(NSArray *)path;

@end
