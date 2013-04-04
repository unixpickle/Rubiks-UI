//
//  ANCubeVertexData.h
//  RubiksCube
//
//  Created by Alex Nichol on 4/3/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#ifndef RubiksCube_ANCubeVertexData_h
#define RubiksCube_ANCubeVertexData_h

#define kCubeCornerVertexCount 54
#define kCubeSpace 0.01

const GLfloat PositiveCorner[] = {
    // x pane
    1, kCubeSpace, kCubeSpace,
    1, kCubeSpace, 1,
    1, 1, 1,
    1, 1, 1,
    1, 1, kCubeSpace,
    1, kCubeSpace, kCubeSpace,
    // y pane
    kCubeSpace, 1, kCubeSpace,
    kCubeSpace, 1, 1,
    1, 1, 1,
    1, 1, 1,
    1, 1, kCubeSpace,
    kCubeSpace, 1, kCubeSpace,
    // z pane
    kCubeSpace, kCubeSpace, 1,
    kCubeSpace, 1, 1,
    1, 1, 1,
    1, 1, 1,
    1, kCubeSpace, 1,
    kCubeSpace, kCubeSpace, 1,
    // small top black spacing 1
    0, 1, 0,
    kCubeSpace, 1, 0,
    kCubeSpace, 1, 1,
    kCubeSpace, 1, 1,
    0, 1, 1,
    0, 1, 0,
    // horizontal spacing (small top 2)
    kCubeSpace, 1, 0,
    kCubeSpace, 1, kCubeSpace,
    1, 1, kCubeSpace,
    1, 1, kCubeSpace,
    1, 1, 0,
    kCubeSpace, 1, 0,
    // vertical spacing 1
    0, 0, 1,
    kCubeSpace, 0, 1,
    kCubeSpace, 1, 1,
    kCubeSpace, 1, 1,
    0, 1, 1,
    0, 0, 1,
    // vertical spacing 2
    1, 0, 0,
    1, 0, kCubeSpace,
    1, 1, kCubeSpace,
    1, 1, kCubeSpace,
    1, 1, 0,
    1, 0, 0,
    // bottom horizontal
    0, 0, 1,
    0, kCubeSpace, 1,
    1, kCubeSpace, 1,
    1, kCubeSpace, 1,
    1, 0, 1,
    0, 0, 1,
    // bottom side
    1, 0, 0,
    1, kCubeSpace, 0,
    1, kCubeSpace, 1,
    1, kCubeSpace, 1,
    1, 0, 1,
    1, 0, 0
};

#endif
