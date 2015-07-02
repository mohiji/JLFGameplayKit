//
//  JLFGKSimplePriorityQueue.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/2/15.
//
//  Like the class name says, this is a really simple priority queue to use in the pathfinder.
//  It's just implemented on top of an NSMutableArray that keeps things sorted on insert, nothing
//  special about it.

#import <Foundation/Foundation.h>

@interface JLFGKSimplePriorityQueue : NSObject

@property (readonly, nonatomic) NSUInteger count;

// Add an object to the queue with the given priority. If the object is already present, this will
// update it's priority in the queue.
- (void)insertObject:(id)obj withPriority:(float)priority;

// Look up the priority for an object in the queue. If the object isn't present, returns FLT_MAX.
- (float)priorityForObject:(id)obj;

// Returns the object with the lowest priority in the queue without modifying the queue.
- (id)peek;

// Returns the object with the lowest priority in the queue and removes it from the queue.
- (id)get;

@end
