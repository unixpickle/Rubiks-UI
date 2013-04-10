//
//  ANTouchRecognizer.m
//  RubiksCube
//
//  Created by Alex Nichol on 4/7/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANTouchRecognizer.h"

@interface ANTouchRecognizer (Private)

- (void)generateCornerData;
- (void)generateEdgeData;

@end

@implementation ANTouchRecognizer

@synthesize touchEdges;
@synthesize touchCorners;

@synthesize cornerVertexArray, cornerVertexBuffer;
@synthesize edgeVertexArray, edgeVertexBuffer;

- (id)initPocketCubeRecognizer {
    if ((self = [super init])) {
        isPocketCube = YES;
        // add all the corners
        NSMutableArray * mCorners = [NSMutableArray array];
        for (int i = 0; i < 8; i++) {
            for (int dim = 0; dim < 3; dim++) {
                ANTouchPlane * plane = [[ANTouchPlane alloc] initWithPieceType:ANTouchPieceTypeCorner
                                                                          axis:dim index:i];
                [mCorners addObject:plane];
            }
        }
        touchCorners = [mCorners copy];
    }
    return self;
}

- (id)initRubiksCubeRecognizer {
    if ((self = [self initPocketCubeRecognizer])) {
        isPocketCube = NO;
        NSMutableArray * mEdges = [NSMutableArray array];
        for (int i = 0; i < 12; i++) {
            for (int dim = 0; dim < 3; dim++) {
                if (dim == EdgePieceInfo[i].pieceOrientation) continue;
                ANTouchPlane * plane = [[ANTouchPlane alloc] initWithPieceType:ANTouchPieceTypeEdge
                                                                          axis:dim index:i];
                [mEdges addObject:plane];
            }
        }
        touchEdges = [mEdges copy];
    }
    return self;
}

- (void)generateGLData {
    [self generateCornerData];
    if (isPocketCube) return;
    [self generateEdgeData];
}

- (void)destroyGLData {
    glDeleteBuffers(1, &cornerVertexBuffer);
    glDeleteVertexArraysOES(1, &cornerVertexArray);
    if (isPocketCube) {
        glDeleteBuffers(1, &edgeVertexBuffer);
        glDeleteVertexArraysOES(1, &edgeVertexArray);
    }
}

#pragma mark - Looking Up Planes -

- (ANTouchPlane *)touchPlaneForCorner:(int)corner axis:(int)axis {
    return [touchCorners objectAtIndex:(corner * 3 + axis)];
}

- (ANTouchPlane *)touchPlaneForEdge:(int)edge axis:(int)axis {
    int subIndex = 0;
    if (axis == 2) subIndex ++;
    if (axis == 1 && EdgePieceInfo[edge].pieceOrientation != 0) subIndex++;
    return [touchEdges objectAtIndex:(edge * 2 + subIndex)];
}

- (ANTouchPlane *)touchPlaneForColor:(GLKVector3)color {
    GLfloat distance = 10000000;
    ANTouchPlane * plane = nil;
    for (int i = 0; i < (isPocketCube ? 24 : 48); i++) {
        ANTouchPlane * guess = nil;
        if (i >= 24) {
            guess = [touchEdges objectAtIndex:(i - 24)];
        } else {
            guess = [touchCorners objectAtIndex:i];
        }
        GLKVector3 vec = GLKVector3Subtract(guess.characteristicColor, color);
        GLfloat guessDistance = GLKVector3Length(vec);
        if (guessDistance < distance) {
            distance = guessDistance;
            plane = guess;
        }
    }
    if (distance > 3) return nil;
    return plane;
}

#pragma mark - Private -

- (void)generateCornerData {
    glGenVertexArraysOES(1, &cornerVertexArray);
    glBindVertexArrayOES(cornerVertexArray);
    glGenBuffers(1, &cornerVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, cornerVertexBuffer);
    
    // generate the corners and then shade them the right colors
    GLfloat * data = (GLfloat *)malloc(sizeof(GLfloat) * kCubeCornerVertexCount * kDataComponentCount * 8);
    for (int i = 0; i < 8; i++) {
        GLfloat * piece = &data[kCubeCornerVertexCount * kDataComponentCount * i];
        generateDefaultCorner(i, piece, !isPocketCube);
        for (int j = 0; j < 3; j++) {
            ANTouchPlane * plane = [self touchPlaneForCorner:i axis:j];
            GLKVector3 color = [plane characteristicColor];
            GLfloat * face = &piece[kDataComponentCount * 6 * j];
            for (int k = 0; k < 6; k++) {
                GLfloat * colorPtr = &face[kDataComponentCount * k + 3];
                colorPtr[0] = color.x / 255.0;
                colorPtr[1] = color.y / 255.0;
                colorPtr[2] = color.z / 255.0;
                colorPtr[3] = 1;
            }
        }
    }
    
    int dataSize = kCubeCornerVertexCount * kDataComponentCount * sizeof(GLfloat) * 8;
    glBufferData(GL_ARRAY_BUFFER, dataSize, data, GL_STATIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 7 * sizeof(GLfloat), 0);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT,
                          GL_FALSE, 7 * sizeof(GLfloat),
                          (void *)(sizeof(GLfloat) * 3));
    
    free(data);
}

- (void)generateEdgeData {
    glGenVertexArraysOES(1, &edgeVertexArray);
    glBindVertexArrayOES(edgeVertexArray);
    glGenBuffers(1, &edgeVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, edgeVertexBuffer);
    
    int dataSize = kCubeEdgeVertexCount * kDataComponentCount * sizeof(GLfloat) * 12;
    GLfloat * data = (GLfloat *)malloc(dataSize);
    for (int i = 0; i < 12; i++) {
        GLfloat * piece = &data[kCubeEdgeVertexCount * kDataComponentCount * i];
        generateDefaultEdge(i, piece);
        // figure out which axis is which edge
        GLKVector3 colors[2];
        if (EdgePieceInfo[i].pieceOrientation == 0) {
            // first = top, second = front
            colors[0] = [[self touchPlaneForEdge:i axis:1] characteristicColor];
            colors[1] = [[self touchPlaneForEdge:i axis:2] characteristicColor];
        } else if (EdgePieceInfo[i].pieceOrientation == 1) {
            // first = side, second = front
            colors[0] = [[self touchPlaneForEdge:i axis:0] characteristicColor];
            colors[1] = [[self touchPlaneForEdge:i axis:2] characteristicColor];
        } else if (EdgePieceInfo[i].pieceOrientation == 2) {
            // first = top, second = side
            colors[0] = [[self touchPlaneForEdge:i axis:1] characteristicColor];
            colors[1] = [[self touchPlaneForEdge:i axis:0] characteristicColor];
        }
        // color the piece
        for (int v = 0; v < 12; v++) {
            GLKVector3 color = colors[v / 6];
            GLfloat * colorPtr = &piece[kDataComponentCount * v + 3];
            for (int j = 0; j < 3; j++) {
                colorPtr[j] = color.v[j] / 255.0;
            }
            colorPtr[3] = 1;
        }
    }
    
    glBufferData(GL_ARRAY_BUFFER, dataSize, data, GL_STATIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 7 * sizeof(GLfloat), 0);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT,
                          GL_FALSE, 7 * sizeof(GLfloat),
                          (void *)(sizeof(GLfloat) * 3));
    free(data);
}

@end
