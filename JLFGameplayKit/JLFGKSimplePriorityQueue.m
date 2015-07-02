//
//  JLFGKSimplePriorityQueue.m
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/2/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import "JLFGKSimplePriorityQueue.h"

// Gosh, I don't like this having to be an object, but ARC forbids pointers to objective-c
// objects in structs. :-/
@interface PriorityQueueEntry : NSObject

+ (instancetype)entryWithObj:(id)obj priority:(float)priority;

@property (weak, nonatomic) id obj;
@property (assign, nonatomic) float priority;

@end

@implementation PriorityQueueEntry

+ (instancetype)entryWithObj:(id)obj priority:(float)priority
{
    PriorityQueueEntry *entry = [[PriorityQueueEntry alloc] init];
    entry.obj = obj;
    entry.priority = priority;
    return entry;
}

@end

@interface JLFGKSimplePriorityQueue ()

@property (strong, nonatomic) NSMutableArray *entries;

@end

@implementation JLFGKSimplePriorityQueue

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.entries = [NSMutableArray array];
    }
    return self;
}

- (NSUInteger)count
{
    return self.entries.count;
}

- (void)insertObject:(id)obj withPriority:(float)priority
{
    NSAssert(obj != nil, @"JLFGKSimplePriorityQueue -insertObject:withPriority: Cannot insert a nil object!");

    // Easy case: is the array empty? If so, just stick this in there and be done.
    NSUInteger numEntries = self.entries.count;
    if (numEntries == 0) {
        [self.entries addObject:[PriorityQueueEntry entryWithObj:obj priority:priority]];
        return;
    }

    // Does this object currently exist in the entry set? If so, remove it first.
    for (NSUInteger i = 0; i < numEntries; i++) {
        PriorityQueueEntry *entry = self.entries[i];
        if (entry.obj == obj) {
            [self.entries removeObjectAtIndex:i];
            numEntries--; // We just pulled one out.
            break;
        }
    }

    // Now find the right spot to insert the object and do it.
    NSUInteger currentIndex = 0;
    while (currentIndex < numEntries) {
        float currentPriority = [self.entries[currentIndex] priority];
        if (priority < currentPriority) {
            [self.entries insertObject:[PriorityQueueEntry entryWithObj:obj priority:priority] atIndex:currentIndex];
            break;
        }
        currentIndex++;
    }

    // If we ran all the way through the loop, this object goes at the end.
    if (currentIndex == numEntries) {
        [self.entries addObject:[PriorityQueueEntry entryWithObj:obj priority:priority]];
    }
}

- (float)priorityForObject:(id)obj
{
    for (PriorityQueueEntry *entry in self.entries) {
        if (entry.obj == obj) {
            return entry.priority;
        }
    }

    return FLT_MAX;
}

- (id)peek
{
    if (self.entries.count > 0) {
        PriorityQueueEntry *entry = self.entries[0];
        return entry.obj;
    } else {
        return nil;
    }
}

- (id)get
{
    if (self.entries.count > 0) {
        PriorityQueueEntry *entry = self.entries[0];
        [self.entries removeObjectAtIndex:0];
        return entry.obj;
    } else {
        return nil;
    }
}

@end
