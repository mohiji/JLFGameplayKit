//
//  GameScene.m
//  PathfindingDemo1
//
//  Created by Jonathan Fischer on 7/2/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "GameScene.h"
#import "JLFGKEntity.h"
#import "JLFGKComponent.h"
#import "JLFGKGraph.h"

#import "BouncyComponent.h"
#import "PathFollowingComponent.h"
#import "SpriteComponent.h"

@interface GameScene ()

@property (strong, nonatomic) JLFGKGraph *navigationGraph;
@property (strong, nonatomic) NSMutableDictionary *namesToGraphNodes;
@property (strong, nonatomic) NSMapTable *graphNodesToSceneNodes;

@property (strong, nonatomic) JLFGKGraphNode *currentGraphNode;
@property (strong, nonatomic) SKNode *selectedNode;

@property (strong, nonatomic) JLFGKEntity *playerEntity;

@property (assign, nonatomic) CFTimeInterval lastUpdate;

@end

@implementation GameScene

- (void)setUpPlayerEntity
{
    BouncyComponent *bouncy = [[BouncyComponent alloc] init];
    PathFollowingComponent *pathFollower = [[PathFollowingComponent alloc] init];
    SpriteComponent *sprite = [[SpriteComponent alloc] init];

    sprite.sprite = (SKSpriteNode *)[self childNodeWithName:@"player"];
    bouncy.baseAnchorPoint = sprite.sprite.anchorPoint;

    SKNode *startNode = (SKNode *)[self.graphNodesToSceneNodes objectForKey:self.currentGraphNode];
    sprite.sprite.position = startNode.position;

    self.playerEntity = [JLFGKEntity entity];
    [self.playerEntity addComponent:bouncy];
    [self.playerEntity addComponent:sprite];
    [self.playerEntity addComponent:pathFollower];
}

- (void)mapGraphNode:(JLFGKGraphNode *)node toNodeName:(NSString *)name
{
    self.namesToGraphNodes[name] = node;
    [self.graphNodesToSceneNodes setObject:[self childNodeWithName:name] forKey:node];
}

- (void)setUpNavigationStuff {
    // There's probably a better way to do this, like somehow linking nodes
    // in the scene file? I'm not all that knowledgable with SpriteKit.
    JLFGKGraphNode *n1 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n2 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n3 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n4 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n5 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n6 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n7 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n8 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n9 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n10 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n11 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n12 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n13 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n14 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n15 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n16 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n17 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n18 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n19 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n20 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n21 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n22 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n23 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n24 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n25 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n26 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n27 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n28 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n29 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n30 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n31 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n32 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n33 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n34 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n35 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n36 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n37 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n38 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n39 = [[JLFGKGraphNode alloc] init];
    JLFGKGraphNode *n40 = [[JLFGKGraphNode alloc] init];

    // I started out with bidirectional:YES on these, but it was confusing me keeping track of things.
    // Easier for my head to just lay out each connection specifically.
    [n1 addConnectionsToNodes:@[n2] bidirectional:NO];
    [n2 addConnectionsToNodes:@[n1, n3] bidirectional:NO];
    [n3 addConnectionsToNodes:@[n2, n4, n11] bidirectional:NO];
    [n4 addConnectionsToNodes:@[n3, n5] bidirectional:NO];
    [n5 addConnectionsToNodes:@[n4, n6] bidirectional:NO];
    [n6 addConnectionsToNodes:@[n5, n7, n8] bidirectional:NO];
    [n7 addConnectionsToNodes:@[n6] bidirectional:NO];
    [n8 addConnectionsToNodes:@[n6, n9, n10] bidirectional:NO];
    [n9 addConnectionsToNodes:@[n8] bidirectional:NO];
    [n10 addConnectionsToNodes:@[n8] bidirectional:NO];
    [n11 addConnectionsToNodes:@[n3, n12, n14] bidirectional:NO];
    [n12 addConnectionsToNodes:@[n11, n13] bidirectional:NO];
    [n13 addConnectionsToNodes:@[n12] bidirectional:NO];
    [n14 addConnectionsToNodes:@[n11, n15] bidirectional:NO];
    [n15 addConnectionsToNodes:@[n14, n16] bidirectional:NO];
    [n16 addConnectionsToNodes:@[n15, n17] bidirectional:NO];
    [n17 addConnectionsToNodes:@[n16, n18, n20] bidirectional:NO];
    [n18 addConnectionsToNodes:@[n17, n19] bidirectional:NO];
    [n19 addConnectionsToNodes:@[n18] bidirectional:NO];
    [n20 addConnectionsToNodes:@[n17, n21, n22] bidirectional:NO];
    [n21 addConnectionsToNodes:@[n20] bidirectional:NO];
    [n22 addConnectionsToNodes:@[n20, n23] bidirectional:NO];
    [n23 addConnectionsToNodes:@[n22, n24] bidirectional:NO];
    [n24 addConnectionsToNodes:@[n23, n25] bidirectional:NO];
    [n25 addConnectionsToNodes:@[n24, n26] bidirectional:NO];
    [n26 addConnectionsToNodes:@[n25, n27] bidirectional:NO];
    [n27 addConnectionsToNodes:@[n26, n28, n29] bidirectional:NO];
    [n28 addConnectionsToNodes:@[n27] bidirectional:NO];
    [n29 addConnectionsToNodes:@[n27, n30] bidirectional:NO];
    [n30 addConnectionsToNodes:@[n29, n31] bidirectional:NO];
    [n31 addConnectionsToNodes:@[n30, n32] bidirectional:NO];
    [n32 addConnectionsToNodes:@[n31, n33, n34] bidirectional:NO];
    [n33 addConnectionsToNodes:@[n32] bidirectional:NO];
    [n34 addConnectionsToNodes:@[n32, n35] bidirectional:NO];
    [n35 addConnectionsToNodes:@[n34, n36] bidirectional:NO];
    [n36 addConnectionsToNodes:@[n35, n37] bidirectional:NO];
    [n37 addConnectionsToNodes:@[n36, n38] bidirectional:NO];
    [n38 addConnectionsToNodes:@[n37, n39] bidirectional:NO];
    [n39 addConnectionsToNodes:@[n38, n40] bidirectional:NO];
    [n40 addConnectionsToNodes:@[n39] bidirectional:NO];

    NSArray *nodes = @[n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13,
                       n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24,
                       n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35,
                       n36, n37, n38, n39, n40];

    self.navigationGraph = [JLFGKGraph graphWithNodes:nodes];

    int nameIndex = 1;
    for (JLFGKGraphNode *node in nodes) {
        [self mapGraphNode:node toNodeName:[NSString stringWithFormat:@"node%d", nameIndex]];
        nameIndex++;
    }
}

-(void)didMoveToView:(SKView *)view {
    self.lastUpdate = -1;

    [self setUpNavigationStuff];
    self.currentGraphNode = self.namesToGraphNodes[@"node1"];

    [self setUpPlayerEntity];
}

- (SKAction *)pulseAction
{
    SKAction *grow = [SKAction scaleTo:1.3f duration:0.8f];
    grow.timingMode = SKActionTimingEaseInEaseOut;
    SKAction *shrink = [SKAction scaleTo:1.0f duration:0.8f];
    shrink.timingMode = SKActionTimingEaseInEaseOut;

    return [SKAction repeatActionForever:[SKAction sequence:@[grow, shrink]]];
}

-(void)mouseDown:(NSEvent *)theEvent {
    CGPoint location = [theEvent locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if (node != nil) {
        // Look up the navigation node for the clicked node, if there was one.
        JLFGKGraphNode *graphNode = self.namesToGraphNodes[node.name];

        // Is it the one that we're already sitting on? If so, we're done.
        if (graphNode == nil || graphNode == self.currentGraphNode) {
            return;
        }

        [self.selectedNode removeAllActions];
        self.selectedNode = node;
        [self.selectedNode runAction:[self pulseAction]];

        // If not, find a path from the current node to the one clicked on.
        NSArray *graphPath = [self.currentGraphNode findPathToNode:graphNode];
        if (graphPath != nil) {
            NSMutableArray *nodesOnTheWay = [NSMutableArray arrayWithCapacity:graphPath.count];
            for (JLFGKGraphNode *graphNode in graphPath) {
                SKNode *node = [self.graphNodesToSceneNodes objectForKey:graphNode];
                [nodesOnTheWay addObject:node];
            }

            PathFollowingComponent *pathComponent = (PathFollowingComponent *)[self.playerEntity componentForClass:PathFollowingComponent.class];
            [pathComponent followPath:nodesOnTheWay];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    if (self.lastUpdate == -1) {
        self.lastUpdate = currentTime;
    }

    CFTimeInterval deltaTime = currentTime - self.lastUpdate;
    self.lastUpdate = currentTime;

    [self.playerEntity updateWithDeltaTime:deltaTime];

    SpriteComponent *sprite = (SpriteComponent *)[self.playerEntity componentForClass:SpriteComponent.class];
    NSArray *nodes = [self nodesAtPoint:sprite.sprite.position];
    for (SKNode *node in nodes) {
        NSString *name = node.name;
        if (name != nil) {
            JLFGKGraphNode *graphNode = self.namesToGraphNodes[name];
            if (graphNode != nil) {
                self.currentGraphNode = graphNode;
            }
        }
    }
}

- (NSMutableDictionary *)namesToGraphNodes
{
    if (_namesToGraphNodes == nil) {
        _namesToGraphNodes = [NSMutableDictionary dictionary];
    }
    return _namesToGraphNodes;
}

- (NSMapTable *)graphNodesToSceneNodes
{
    if (_graphNodesToSceneNodes == nil) {
        _graphNodesToSceneNodes = [NSMapTable mapTableWithKeyOptions:NSMapTableObjectPointerPersonality
                                                        valueOptions:NSMapTableStrongMemory];
    }
    return _graphNodesToSceneNodes;
}

@end
