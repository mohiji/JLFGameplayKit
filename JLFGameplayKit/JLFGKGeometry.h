//
//  JLFGKGeometry.h
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/16/15.
//
//  Helper functions for working with vector_float2.

#pragma once

#include <simd/vector.h>

extern float vector_float2_magnitude(vector_float2 v);
extern vector_float2 vector_float2_normalized(vector_float2 v);
extern vector_float2 vector_float2_add(vector_float2 v1, vector_float2 v2);
extern vector_float2 vector_float2_subtract(vector_float2 v1, vector_float2 v2);
extern vector_float2 vector_float2_scale(vector_float2 v, float scalar);
