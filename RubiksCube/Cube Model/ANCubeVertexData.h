//
//  ANCubeVertexData.h
//  RubiksCube
//
//  Created by Alex Nichol on 4/3/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#ifndef RubiksCube_ANCubeVertexData_h
#define RubiksCube_ANCubeVertexData_h

#define kCubeCornerVertexCount 18
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
    kCubeSpace, kCubeSpace, 1
};

#endif
