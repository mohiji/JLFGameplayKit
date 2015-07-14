//
//  CGPointMath.c
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/25/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

#import <math.h>
#import "CGPointMath.h"

CGPoint CGPointAdd(CGPoint a, CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

CGPoint CGPointSubtract(CGPoint a, CGPoint b)
{
    return CGPointMake(a.x - b.x, a.y - b.y);
}

CGPoint CGPointScale(CGPoint point, CGFloat scalar)
{
    return CGPointMake(point.x * scalar, point.y * scalar);
}

CGFloat CGPointMagnitude(CGPoint a)
{
    CGFloat magnitudeSquared = a.x * a.x + a.y * a.y;
    if (magnitudeSquared != 0)
    {
        return sqrt(magnitudeSquared);
    } else
    {
        return 0;
    }
}

CGPoint CGPointNormalize(CGPoint a)
{
    CGFloat magnitude = CGPointMagnitude(a);
    if (magnitude != 0)
    {
        return CGPointScale(a, 1.0f / magnitude);
    } else
    {
        return a;
    }
}