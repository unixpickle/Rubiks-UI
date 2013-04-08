//
//  ANCubeVertexData.m
//  RubiksCube
//
//  Created by Alex Nichol on 4/5/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANCubeVertexData.h"

BOOL isCornerPieceOnFace(int index, ANCubeAnimationFace face) {
    int pieces[6][4] = {
        {0x2, 0x3, 0x6, 0x7}, // top
        {0x000, 0x1, 0x4, 0x5}, // bottom
        {0x4, 0x5, 0x6, 0x7}, // right
        {0x000, 0x1, 0x2, 0x3}, // left
        {0x1, 0x3, 0x5, 0x7}, // front
        {0x000, 0x2, 0x4, 0x6} // back
    };
    for (int i = 0; i < 4; i++) {
        if (pieces[face][i] == index) return YES;
    }
    return NO;
}

BOOL isEdgePieceOnFace(int index, ANCubeAnimationFace face) {
    int edges[6][4] = {
        {0, 4, 5, 6},
        {2, 8, 10, 11},
        {1, 5, 7, 11},
        {3, 4, 9, 10},
        {0, 1, 2, 3},
        {6, 7, 8, 9}
    };
    for (int i = 0; i < 4; i++) {
        if (edges[face][i] == index) return YES;
    }
    return NO;
}

BOOL isCenterPieceOnFace(int index, ANCubeAnimationFace face) {
    ANCubeAnimationFace faces[] = {ANCubeAnimationFaceFront, ANCubeAnimationFaceBack,
        ANCubeAnimationFaceTop, ANCubeAnimationFaceBottom,
        ANCubeAnimationFaceRight, ANCubeAnimationFaceLeft};
    return faces[index] == face;
}

void copyColorToBuffer(ANCubeColor color, GLfloat * componentsOut) {
    GLfloat colors[6][3] = {
        {1, 1, 1}, // white
        {1, 1, 0}, // yellow
        {0, 0, 1}, // blue
        {0, 1, 0}, // green
        {1, 0, 0}, // red
        {1, 0.5, 0.2} // orange
    };
    memcpy((void *)componentsOut, &colors[color - 1], sizeof(GLfloat) * 3);
    componentsOut[3] = 1;
}

void generateDefaultCorner(int index, GLfloat * vertexData, BOOL hasEdges) {
    GLfloat offsets[3] = {0, 0, 0};
    
    int x = (index >> 2) & 1;
    int y = (index >> 1) & 1;
    int z = index & 1; // my specification has Z going *towards* the user
    GLfloat scalar[3] = {x ? 1 : -1, y ? 1 : -1, z ? 1 : -1};
    
    if (hasEdges) {
        for (int i = 0; i < 3; i++) {
            offsets[i] = scalar[i] * 0.5;
        }
    }
    
    for (int j = 0; j < kCubeCornerVertexCount; j++) {
        const GLfloat * copyFrom = &PositiveCorner[j * 3];
        GLfloat * vertex = &vertexData[j * 7];
        for (int i = 0; i < 3; i++) {
            vertex[i] = scalar[i] * copyFrom[i];
            vertex[i] += offsets[i];
        }
        bzero(&vertex[3], sizeof(GLfloat) * 3);
        vertex[6] = 1;
    }
}

void generateDefaultEdge(int index, GLfloat * data) {
    GLfloat xOff = 0, yOff = 1, zOff = 1;
    yOff *= EdgePieceInfo[index].yScale;
    zOff *= EdgePieceInfo[index].zScale;
    if (EdgePieceInfo[index].pieceOrientation == 1) {
        GLfloat oldX = xOff;
        xOff = yOff;
        yOff = oldX;
    } else if (EdgePieceInfo[index].pieceOrientation == 2) {
        GLfloat oldX = xOff;
        xOff = zOff;
        zOff = oldX;
    }
    
    GLfloat * edgePointer = data;
    memcpy(edgePointer, PositiveEdge, kCubeEdgeVertexCount * 3 * sizeof(GLfloat));
    for (int i = 0; i < kCubeEdgeVertexCount; i++) {
        GLfloat * vertex = &edgePointer[7 * i];
        const GLfloat * original = &PositiveEdge[i * 3];
        // scale the point
        vertex[0] = original[0];
        vertex[1] = original[1] * EdgePieceInfo[index].yScale;
        vertex[2] = original[2] * EdgePieceInfo[index].zScale;
        // rotate the point
        if (EdgePieceInfo[index].pieceOrientation == 1) {
            // flip x and y coordinates
            GLfloat x = vertex[0];
            vertex[0] = vertex[1];
            vertex[1] = x;
        } else if (EdgePieceInfo[index].pieceOrientation == 2) {
            GLfloat x = vertex[0];
            vertex[0] = vertex[2];
            vertex[2] = x;
        }
        vertex[0] += xOff;
        vertex[1] += yOff;
        vertex[2] += zOff;
        bzero(&vertex[3], sizeof(GLfloat) * 3);
        vertex[6] = 1;
    }
}

void generateDefaultCenter(int index, GLfloat * data) {
    const struct {
        int axis; // x = 0, y = 1, z = 2
        GLfloat scale;
    } centerPieces[] = {
        {2, 1},
        {2, -1},
        {1, 1},
        {1, -1},
        {0, 1},
        {0, -1}
    };
    for (int i = 0; i < kCubeCenterVertexCount; i++) {
        const GLfloat * source = &PositiveCenter[i * 3];
        GLfloat * dest = &data[i * 7];
        memcpy(dest, source, sizeof(GLfloat) * 3);
        if (i < 6) {
            copyColorToBuffer(index + 1, &dest[3]);
        } else {
            bzero(&dest[3], sizeof(GLfloat) * 3);
            dest[6] = 1;
        }
        dest[2] *= centerPieces[index].scale;
        dest[2] += centerPieces[index].scale;
        // rotate the piece
        if (centerPieces[index].axis == 0) {
            // swap the z and x
            GLfloat xTemp = dest[0];
            dest[0] = dest[2];
            dest[2] = xTemp;
        } else if (centerPieces[index].axis == 1) {
            GLfloat yTemp = dest[1];
            dest[1] = dest[2];
            dest[2] = yTemp;
        }
    }
}
