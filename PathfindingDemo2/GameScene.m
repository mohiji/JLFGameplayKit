//
//  GameScene.m
//  PathfindingDemo2
//
//  Created by Jonathan Fischer on 7/13/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "GameScene.h"
#import "CellularAutomata.h"
#import "JLFGKGridGraph.h"
#import "JLFGKGridGraphNode.h"
#import "JLFGKEntity.h"
#import "SpriteComponent.h"
#import "BouncyComponent.h"
#import "PathMoveComponent.h"

// The tiles are square and 32 points on a side.
static const CGFloat kTileSize = 32.0f;

@interface GameScene ()

@property (strong, nonatomic) SKSpriteNode *sceneRoot;

@property (strong, nonatomic) NSMutableArray *tiles;
@property (strong, nonatomic) NSMapTable *tilesInPath;
@property (assign, nonatomic) NSUInteger tilesWide;
@property (assign, nonatomic) NSUInteger tilesHigh;

@property (strong, nonatomic) JLFGKGridGraph *graph;

@property (strong, nonatomic) UIGestureRecognizer *panRecognizer;
@property (strong, nonatomic) UIGestureRecognizer *tapRecognizer;

@property (assign, nonatomic) CGPoint sceneOffsetAtPanStart;

@property (strong, nonatomic) JLFGKEntity *playerEntity;
@property (strong, nonatomic) SpriteComponent *playerSprite;
@property (strong, nonatomic) PathMoveComponent *playerMoveComponent;

@property (assign, nonatomic) BOOL firstUpdate;
@property (assign, nonatomic) CFTimeInterval lastUpdateTime;

- (void)handlePan:(id)sender;
- (void)handleTap:(id)sender;

@end

@implementation GameScene

- (void)generateMap
{
    // The map is generated using a cellular automata. Basically just the algorithm here:
    // http://www.roguebasin.com/index.php?title=Cellular_Automata_Method_for_Generating_Random_Cave-Like_Levels
    //
    // I run through two automata: one of them just gives me a nicer looking mix of normal and dry grass
    // tiles, and the second one gives me the forest on top of it. The forest one is the one that's
    // used for pathfinding.
    CellularAutomata *baseAutomata = [CellularAutomata randomlyFilledCellularAutomataWithWidth:self.tilesWide
                                                                                        height:self.tilesHigh
                                                                                 percentFilled:0.4f];

    for (int i = 0; i < 3; i++) {
        baseAutomata = [baseAutomata nextGenerationWithRule:^BOOL(int numNeighbors) {
            return numNeighbors > 4 || numNeighbors == 2;
        }];
    }

    for (int i = 0; i < 2; i++) {
        baseAutomata = [baseAutomata nextGenerationWithRule:^BOOL(int numNeighbors) {
            return numNeighbors > 4;
        }];
    }

    for (NSUInteger y = 0; y < self.tilesHigh; y++) {
        for (NSUInteger x = 0; x < self.tilesWide; x++) {
            BOOL useDirt = baseAutomata.cells[x + y * self.tilesWide] == YES;

            NSString *textureName = useDirt == YES ? @"dirt" : @"grass";
            SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:textureName];
            CGPoint position = CGPointMake(x * 32.0f, y * 32.0f);
            node.position = position;
            node.anchorPoint = CGPointZero;
            [self.tiles addObject:node];
            [self.sceneRoot addChild:node];
        }
    }

    // Now figure out where we want trees.
    CellularAutomata *treeAutomata = [CellularAutomata randomlyFilledCellularAutomataWithWidth:self.tilesWide
                                                                                        height:self.tilesHigh
                                                                                 percentFilled:0.45f];

    for (int i = 0; i < 5; i++) {
        treeAutomata = [treeAutomata nextGenerationWithRule:^BOOL(int numNeighbors) {
            return numNeighbors > 4 || numNeighbors == 0;
        }];
    }

    for (NSUInteger y = 0; y < self.tilesHigh; y++) {
        for (NSUInteger x = 0; x < self.tilesWide; x++) {
            if (treeAutomata.cells[x + y * self.tilesWide] == YES) {
                SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"tree"];
                CGPoint position = CGPointMake(x * 32.0f, y * 32.0f);
                node.position = position;
                node.anchorPoint = CGPointZero;

                [self.sceneRoot addChild:node];
            }
       }
    }

    self.graph = [JLFGKGridGraph graphFromGridStartingAt:(vector_int2){0, 0}
                                                   width:(int)self.tilesWide
                                                  height:(int)self.tilesHigh
                                        diagonalsAllowed:NO];
    NSMutableArray *walls = [NSMutableArray array];
    for (int y = 0; y < self.tilesHigh; y++) {
        for (int x = 0; x < self.tilesWide; x++) {
            if (treeAutomata.cells[x + y * self.tilesWide] == YES) {
                [walls addObject:[self.graph nodeAtGridPosition:(vector_int2){x, y}]];
            }
        }
    }

    [self.graph removeNodes:walls];
}

- (void)createPlayerEntity
{
    self.playerMoveComponent = [[PathMoveComponent alloc] init];
    self.playerMoveComponent.distanceBetweenWaypoints = kTileSize;

    GameScene * __weak weakSelf = self;
    self.playerMoveComponent.waypointCallback = ^void (JLFGKGridGraphNode *waypoint) {
        SKSpriteNode *tile = [weakSelf.tilesInPath objectForKey:waypoint];
        [tile removeAllActions];
        tile.colorBlendFactor = 0.0f;
    };

    self.playerSprite = [[SpriteComponent alloc] init];
    self.playerSprite.sprite = [[SKSpriteNode alloc] initWithImageNamed:@"ranger-left"];
    self.playerSprite.sprite.anchorPoint = CGPointZero;

    BouncyComponent *bouncy = [[BouncyComponent alloc] init];
    bouncy.baseAnchorPoint = CGPointZero;

    self.playerEntity = [JLFGKEntity entity];
    [self.playerEntity addComponent:self.playerSprite];
    [self.playerEntity addComponent:bouncy];
    [self.playerEntity addComponent:self.playerMoveComponent];

    [self.sceneRoot addChild:self.playerSprite.sprite];

    // Find an open tile to stick him on.
    BOOL tileOpen = NO;
    int x = 0, y = 0;
    while (!tileOpen)
    {
        x = arc4random_uniform((int)self.tilesWide / 3);
        y = arc4random_uniform((int)self.tilesHigh / 3);

        tileOpen = [self.graph.nodes containsObject:[self.graph nodeAtGridPosition:(vector_int2){x, y}]];
    }

    self.playerSprite.sprite.position = CGPointMake(x * kTileSize, y * kTileSize);
}

-(void)didMoveToView:(SKView *)view
{
    [self removeAllChildren];

    self.sceneRoot = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(128.0f, 128.0f)];
    self.sceneRoot.position = CGPointZero;
    self.sceneRoot.anchorPoint = CGPointZero;
    [self addChild:self.sceneRoot];

    self.tilesWide = 30;
    self.tilesHigh = 30;
    self.tiles = [NSMutableArray arrayWithCapacity:self.tilesWide * self.tilesHigh];
    self.tilesInPath = [NSMapTable mapTableWithKeyOptions:NSMapTableObjectPointerPersonality
                                             valueOptions:NSMapTableWeakMemory];

    [self generateMap];
    [self createPlayerEntity];

    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];

    [view addGestureRecognizer:self.panRecognizer];
    [view addGestureRecognizer:self.tapRecognizer];
    self.firstUpdate = YES;
}

- (void)willMoveFromView:(SKView *)view
{
    [view removeGestureRecognizer:self.panRecognizer];
    [view removeGestureRecognizer:self.tapRecognizer];
}

-(void)update:(CFTimeInterval)currentTime
{
    if (self.firstUpdate)
    {
        self.lastUpdateTime = currentTime;
        self.firstUpdate = NO;
        return;
    }

    CFTimeInterval deltaTime = currentTime - self.lastUpdateTime;
    // Clamp those delta values if they get too big: otherwise the simulator can get
    // some weird behavior if it can't keep up.
    if (deltaTime > 1.0f / 15.0f) {
        deltaTime = 1.0f / 15.0f;
    }
    self.lastUpdateTime = currentTime;
    [self.playerEntity updateWithDeltaTime:deltaTime];
}

- (void)handlePan:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.sceneOffsetAtPanStart = self.sceneRoot.position;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self.view];
        CGPoint newOffset = self.sceneOffsetAtPanStart;
        newOffset.x += translation.x;
        newOffset.y -= translation.y;

        int minX = -(self.tilesWide * kTileSize) + self.view.bounds.size.width;
        int minY = -(self.tilesHigh * kTileSize) + self.view.bounds.size.height;

        if (newOffset.x <= minX) newOffset.x = minX;
        if (newOffset.x > 0) newOffset.x = 0;
        if (newOffset.y <= minY) newOffset.y = minY;
        if (newOffset.y > 0) newOffset.y = 0;

        self.sceneRoot.position = newOffset;
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state != UIGestureRecognizerStateEnded) {
        return;
    }

    CGPoint location = [sender locationInView:self.view];
    location.y = self.view.bounds.size.height - location.y;
    location.x -= self.sceneRoot.position.x;
    location.y -= self.sceneRoot.position.y;

    int goalX = (int)floor(location.x / kTileSize);
    int goalY = (int)floor(location.y / kTileSize);

    int startX = (int)floor(self.playerSprite.sprite.position.x / kTileSize);
    int startY = (int)floor(self.playerSprite.sprite.position.y / kTileSize);

    NSArray *path = [self.graph findPathFromNode:[self.graph nodeAtGridPosition:(vector_int2){startX, startY}]
                                          toNode:[self.graph nodeAtGridPosition:(vector_int2){goalX, goalY}]];
    if (path == nil) {
        NSLog(@"Failed to find a path from {%d, %d} to {%d, %d}!", startX, startY, goalX, goalY);
    } else {
        // Clear any tiles that are already marked
        for (SKSpriteNode *tile in [self.tilesInPath objectEnumerator]) {
            [tile removeAllActions];
            tile.color = [UIColor whiteColor];
            tile.colorBlendFactor = 0.0f;
        }
        [self.tilesInPath removeAllObjects];

        // Mark the new path
        for (JLFGKGridGraphNode *node in path) {
            float centerX = node.position.x * kTileSize + (kTileSize / 2.0f);
            float centerY = node.position.y * kTileSize + (kTileSize / 2.0f);

            SKAction *colorRampUp = [SKAction colorizeWithColorBlendFactor:0.6f duration:0.4f];
            SKAction *colorRampDown = [colorRampUp reversedAction];
            SKAction *colorRamp = [SKAction repeatActionForever:[SKAction sequence:@[colorRampUp, colorRampDown]]];

            NSArray *sprites = [self.sceneRoot nodesAtPoint:CGPointMake(centerX, centerY)];
            for (SKSpriteNode *sprite in sprites) {
                if ([self.tiles containsObject:sprite]) {
                    sprite.color = [UIColor redColor];
                    [sprite runAction:colorRamp];
                    [self.tilesInPath setObject:sprite forKey:node];
                }
            }
        }

        [self.playerMoveComponent followPath:path];
    }
}

@end
