//
//  JLFGKGeometry.c
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/16/15.
//

#include "JLFGKGeometry.h"
#include <math.h>

float vector_float2_magnitude(vector_float2 v)
{
    float magnitudeSquared = v.x * v.x + v.y * v.y;
    if (magnitudeSquared != 0) {
        return sqrtf(magnitudeSquared);
    } else {
        return 0.0f;
    }
}

vector_float2 vector_float2_normalized(vector_float2 v)
{
    float magnitude = vector_float2_magnitude(v);
    if (magnitude != 0.0f) {
        return vector_float2_scale(v, 1.0f / magnitude);
    } else {
        return v;
    }
}

vector_float2 vector_float2_add(vector_float2 v1, vector_float2 v2)
{
    return (vector_float2){v1.x + v2.x, v1.y + v2.y};
}

vector_float2 vector_float2_subtract(vector_float2 v1, vector_float2 v2)
{
    return (vector_float2){v1.x - v2.x, v1.y - v2.y};
}

vector_float2 vector_float2_scale(vector_float2 v, float scalar)
{
    return (vector_float2){v.x * scalar, v.y * scalar};
}
