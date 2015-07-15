//
//  GameViewController.m
//  PathfindingDemo2
//
//  Created by Jonathan Fischer on 7/13/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.

    // On iOS 7 and earlier, bounds will always be the portrait size on a phone, so we need
    // to account for that.
    CGSize screenSize = self.view.bounds.size;
    if (screenSize.height > screenSize.width) {
        float temp = screenSize.width;
        screenSize.width = screenSize.height;
        screenSize.height = temp;
    }

    GameScene *scene = [[GameScene alloc] initWithSize:screenSize];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
