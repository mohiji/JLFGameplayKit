//
//  JLFGKGeometry.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/16/15.
//
//  Helper functions for working with vector_float2.

#pragma once

#include <simd/vector.h>
#include <stdbool.h>

// Returns true if there's an intersection between the two lines defined by the
// endpoints {p1, p2} and {q1, q2}. Note that those are endpoints, not point + direction.
extern bool line_segments_intersect(vector_float2 p1, vector_float2 p2, vector_float2 q1, vector_float2 q2);