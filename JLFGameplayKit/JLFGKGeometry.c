//
//  JLFGKGeometry.c
//  JLFGameplayKit
//
//  Created by Jonathan Fischer on 7/16/15.
//

#include "JLFGKGeometry.h"
#include <math.h>

// This is adapted from the wonderful StackOverflow answer here:'
// http://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect

bool line_segments_intersect(vector_float2 p1, vector_float2 p2, vector_float2 q1, vector_float2 q2)
{
    vector_float2 r = {p2.x - p1.x, p2.y - p1.y};
    vector_float2 s = {q2.x - q1.x, q2.y - q1.y};
    vector_float2 q_minus_p = {q1.x - p1.x, q1.y - p1.y};
    float r_cross_s = vector_cross(r, s).z;
    float q_minus_p_cross_r = vector_cross(q_minus_p, r).z;
    float q_minus_p_cross_s = vector_cross(q_minus_p, s).z;

    if (q_minus_p_cross_r == 0 && r_cross_s == 0) {
        // The lines are colinear
        float magnitude_r = vector_length(r);
        float s_dot_r = vector_dot(s, r);
        float t0 = vector_dot(q_minus_p, r) / magnitude_r;
        float t1 = t0 + s_dot_r / magnitude_r;

        return ((t0 >= 0 && t0 <= 1) || (t1 >= 0 && t1 <= 1));
    } else if (r_cross_s == 0 && q_minus_p_cross_r != 0) {
        // The lines are parallel and non-intersecting
        return false;
    } else if (r_cross_s != 0) {
        float t = q_minus_p_cross_s / r_cross_s;
        float u = q_minus_p_cross_r / r_cross_s;

        // Normally you'd want to test for 0 <= t <= 1 && 0 <= u <= 1, but
        // that would mean that two lines that share the same endpoint are
        // marked as intersecting, which isn't what we want for our use case.
        return t > 0 && t < 1 && u > 0 && u < 1;
    }

    return false;
}