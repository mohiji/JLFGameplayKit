//
//  JLFGKComponent.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/21/15.
//

#import "JLFGKComponent.h"
#import "JLFGKComponent+Private.h"

@interface JLFGKComponent ()

@property (nonatomic, readwrite, weak) JLFGKEntity *entity;

@end

@implementation JLFGKComponent

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    // default implementation does nothing
}

@end
