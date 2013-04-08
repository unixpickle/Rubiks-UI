//
//  ANCubeVertexData.h
//  RubiksCube
//
//  Created by Alex Nichol on 4/3/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#ifndef RubiksCube_ANCubeVertexData_h
#define RubiksCube_ANCubeVertexData_h

#import "ANCubePiece.h"
#import "ANCubeAnimation.h"

#define kCubeCornerVertexCount 36
#define kCubeEdgeVertexCount 36
#define kCubeCenterVertexCount 36
#define kDataComponentCount 7
#define kCubeSpace 0.02

BOOL isCornerPieceOnFace(int index, ANCubeAnimationFace face);
BOOL isEdgePieceOnFace(int index, ANCubeAnimationFace face);
BOOL isCenterPieceOnFace(int index, ANCubeAnimationFace face);
void copyColorToBuffer(ANCubeColor color, GLfloat * componentsOut);
void generateDefaultCorner(int index, GLfloat * data, BOOL hasEdges);
void generateDefaultEdge(int index, GLfloat * data);
void generateDefaultCenter(int index, GLfloat * data);

static const GLfloat PositiveCorner[] = {
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
    // actual black bottom inner face
    kCubeSpace, kCubeSpace, kCubeSpace,
    1, kCubeSpace, kCubeSpace,
    1, kCubeSpace, 1,
    1, kCubeSpace, 1,
    kCubeSpace, kCubeSpace, 1,
    kCubeSpace, kCubeSpace, kCubeSpace,
    // black back inner face
    kCubeSpace, kCubeSpace, kCubeSpace,
    kCubeSpace, 1, kCubeSpace,
    1, 1, kCubeSpace,
    1, 1, kCubeSpace,
    1, kCubeSpace, kCubeSpace,
    kCubeSpace, kCubeSpace, kCubeSpace,
    // black left inner face
    kCubeSpace, kCubeSpace, kCubeSpace,
    kCubeSpace, kCubeSpace, 1,
    kCubeSpace, 1, 1,
    kCubeSpace, 1, 1,
    kCubeSpace, 1, kCubeSpace,
    kCubeSpace, kCubeSpace, kCubeSpace
};

static const GLfloat PositiveEdge[] = {
    // top face
    -0.5 + kCubeSpace, 0.5, 0.5,
    0.5 - kCubeSpace, 0.5, 0.5,
    0.5 - kCubeSpace, 0.5, -0.5 + kCubeSpace,
    0.5 - kCubeSpace, 0.5, -0.5 + kCubeSpace,
    -0.5 + kCubeSpace, 0.5, -0.5 + kCubeSpace,
    -0.5 + kCubeSpace, 0.5, 0.5,
    // front face
    -0.5 + kCubeSpace, -0.5 + kCubeSpace, 0.5,
    -0.5 + kCubeSpace, 0.5, 0.5,
    0.5 - kCubeSpace, 0.5, 0.5,
    0.5 - kCubeSpace, 0.5, 0.5,
    0.5 - kCubeSpace, -0.5 + kCubeSpace, 0.5,
    -0.5 + kCubeSpace, -0.5 + kCubeSpace, 0.5,
    // left face
    -0.5 + kCubeSpace, 0.5, 0.5,
    -0.5 + kCubeSpace, 0.5, -0.5 + kCubeSpace,
    -0.5 + kCubeSpace, -0.5 + kCubeSpace, -0.5 + kCubeSpace,
    -0.5 + kCubeSpace, -0.5 + kCubeSpace, -0.5 + kCubeSpace,
    -0.5 + kCubeSpace, -0.5 + kCubeSpace, 0.5,
    -0.5 + kCubeSpace, 0.5, 0.5,
    // right face
    0.5 - kCubeSpace, 0.5, 0.5,
    0.5 - kCubeSpace, 0.5, -0.5 + kCubeSpace,
    0.5 - kCubeSpace, -0.5 + kCubeSpace, -0.5 + kCubeSpace,
    0.5 - kCubeSpace, -0.5 + kCubeSpace, -0.5 + kCubeSpace,
    0.5 - kCubeSpace, -0.5 + kCubeSpace, 0.5,
    0.5 - kCubeSpace, 0.5, 0.5,
    // back face
    -0.5 + kCubeSpace, -0.5 + kCubeSpace, -0.5 + kCubeSpace,
    -0.5 + kCubeSpace, 0.5, -0.5 + kCubeSpace,
    0.5 - kCubeSpace, 0.5, -0.5 + kCubeSpace,
    0.5 - kCubeSpace, 0.5, -0.5 + kCubeSpace,
    0.5 - kCubeSpace, -0.5 + kCubeSpace, -0.5 + kCubeSpace,
    -0.5 + kCubeSpace, -0.5 + kCubeSpace, -0.5 + kCubeSpace,
    // top face
    -0.5 + kCubeSpace, -0.5 + kCubeSpace, 0.5,
    0.5 - kCubeSpace, -0.5 + kCubeSpace, 0.5,
    0.5 - kCubeSpace, -0.5 + kCubeSpace, -0.5 + kCubeSpace,
    0.5 - kCubeSpace, -0.5 + kCubeSpace, -0.5 + kCubeSpace,
    -0.5 + kCubeSpace, -0.5 + kCubeSpace, -0.5 + kCubeSpace,
    -0.5 + kCubeSpace, -0.5 + kCubeSpace, 0.5,
};

static const GLfloat PositiveCenter[] = {
    // front face
    -0.5 + kCubeSpace, -0.5 + kCubeSpace, 0.5,
    -0.5 + kCubeSpace, 0.5 - kCubeSpace, 0.5,
    0.5 - kCubeSpace, 0.5 - kCubeSpace, 0.5,
    0.5 - kCubeSpace, 0.5 - kCubeSpace, 0.5,
    0.5 - kCubeSpace, -0.5 + kCubeSpace, 0.5,
    -0.5 + kCubeSpace, -0.5 + kCubeSpace, 0.5,
    // back face
    -0.5 + kCubeSpace, -0.5 + kCubeSpace, -0.5 + kCubeSpace,
    -0.5 + kCubeSpace, 0.5 - kCubeSpace, -0.5 + kCubeSpace,
    0.5 - kCubeSpace, 0.5 - kCubeSpace, -0.5 + kCubeSpace,
    0.5 - kCubeSpace, 0.5 - kCubeSpace, -0.5 + kCubeSpace,
    0.5 - kCubeSpace, -0.5 + kCubeSpace, -0.5 + kCubeSpace,
    -0.5 + kCubeSpace, -0.5 + kCubeSpace, -0.5 + kCubeSpace,
    // left face
    -0.5 + kCubeSpace, -0.5 + kCubeSpace, -0.5 + kCubeSpace,
    -0.5 + kCubeSpace, -0.5 + kCubeSpace, 0.5,
    -0.5 + kCubeSpace, 0.5 - kCubeSpace, 0.5,
    -0.5 + kCubeSpace, 0.5 - kCubeSpace, 0.5,
    -0.5 + kCubeSpace, 0.5 - kCubeSpace, -0.5 + kCubeSpace,
    -0.5 + kCubeSpace, -0.5 + kCubeSpace, -0.5 + kCubeSpace,
    // right face
    0.5 - kCubeSpace, -0.5 + kCubeSpace, -0.5 + kCubeSpace,
    0.5 - kCubeSpace, -0.5 + kCubeSpace, 0.5,
    0.5 - kCubeSpace, 0.5 - kCubeSpace, 0.5,
    0.5 - kCubeSpace, 0.5 - kCubeSpace, 0.5,
    0.5 - kCubeSpace, 0.5 - kCubeSpace, -0.5 + kCubeSpace,
    0.5 - kCubeSpace, -0.5 + kCubeSpace, -0.5 + kCubeSpace,
    // top face
    -0.5 + kCubeSpace, 0.5 - kCubeSpace, -0.5 + kCubeSpace,
    -0.5 + kCubeSpace, 0.5 - kCubeSpace, 0.5,
    0.5 - kCubeSpace, 0.5 - kCubeSpace, 0.5,
    0.5 - kCubeSpace, 0.5 - kCubeSpace, 0.5,
    0.5 - kCubeSpace, 0.5 - kCubeSpace, -0.5 + kCubeSpace,
    -0.5 + kCubeSpace, 0.5 - kCubeSpace, -0.5 + kCubeSpace,
    // bottom face
    -0.5 + kCubeSpace, -0.5 + kCubeSpace, -0.5 + kCubeSpace,
    -0.5 + kCubeSpace, -0.5 + kCubeSpace, 0.5,
    0.5 - kCubeSpace, -0.5 + kCubeSpace, 0.5,
    0.5 - kCubeSpace, -0.5 + kCubeSpace, 0.5,
    0.5 - kCubeSpace, -0.5 + kCubeSpace, -0.5 + kCubeSpace,
    -0.5 + kCubeSpace, -0.5 + kCubeSpace, -0.5 + kCubeSpace
};

static const struct {
    // orientations work by scaling and then rotating
    GLfloat yScale, zScale;
    int pieceOrientation; // 0 for top/bottom
    // 1 for middle row on front & back face
    // 2 for top-bottom side
} EdgePieceInfo[] = {
    // front face going clockwise
    {1, 1, 0},
    {1, 1, 1},
    {-1, 1, 0},
    {-1, 1, 1},
    // middle top ring
    {1, -1, 2},
    {1, 1, 2},
    // back face going counterclockwise
    {1, -1, 0},
    {1, -1, 1},
    {-1, -1, 0},
    {-1, -1, 1},
    // middle bottom ring
    {-1, -1, 2},
    {-1, 1, 2}
};

#endif
