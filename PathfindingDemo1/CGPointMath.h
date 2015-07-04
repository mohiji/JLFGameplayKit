//
//  CGPointMath.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 6/25/15.
//  Copyright (c) 2015 Jonathan Fischer. All rights reserved.
//

@import CoreGraphics;

CGPoint CGPointAdd(CGPoint a, CGPoint b);
CGPoint CGPointSubtract(CGPoint a, CGPoint b);
CGPoint CGPointScale(CGPoint point, CGFloat scalar);

CGFloat CGPointMagnitude(CGPoint a);
CGPoint CGPointNormalize(CGPoint a);