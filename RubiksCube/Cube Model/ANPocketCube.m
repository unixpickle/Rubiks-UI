//
//  ANPocketCube.m
//  RubiksCube
//
//  Created by Alex Nichol on 4/3/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANPocketCube.h"
#import "ANCubeVertexData.h"

@interface ANPocketCube (Private)

- (void)generateGLData:(ANCubeAnimation *)animation;
- (void)generateDefaultCorner:(int)i;
- (BOOL)isCornerPiece:(int)index onFace:(ANCubeAnimationFace)face;
- (void)copyColor:(ANCubeColor)color toBuffer:(GLfloat *)buffer;

@end

@implementation ANPocketCube

@synthesize cornerPieces;

+ (ANPocketCube *)pocketCubeIdentity {
    return [[ANPocketCube alloc] initIdentity];
}

- (id)initIdentity {
    const unsigned char CornerPieces[8][3] = {
        {6,4,2}, // 000
        {6,4,1}, // 001
        {6,3,2}, // 010
        {6,3,1}, // 011
        {5,4,2}, // 100
        {5,4,1}, // 101
        {5,3,2}, // 110
        {5,3,1}  // 111
    };
    if ((self = [super init])) {
        NSMutableArray * mCorners = [[NSMutableArray alloc] init];
        for (int i = 0; i < 8; i++) {
            ANCubeColor colors[3];
            colors[0] = (ANCubeColor)CornerPieces[i][0];
            colors[1] = (ANCubeColor)CornerPieces[i][1];
            colors[2] = (ANCubeColor)CornerPieces[i][2];
            ANCubePiece * piece = [[ANCubePiece alloc] initWithColors:colors];
            [mCorners addObject:piece];
        }
        cornerPieces = [mCorners copy];
    }
    return self;
}

- (void)dealloc {
    if (vertexData) {
        free(vertexData);
        free(colorData);
    }
}

#pragma mark Drawing

- (void)drawCube {
    if (!vertexData) {
        [self generateGLData:nil];
    }
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, vertexData);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, colorData);
    glDrawArrays(GL_TRIANGLES, 0, 18 * 8);
}

- (void)updateWithAnimation:(ANCubeAnimation *)animation {
    int cornerSize = kCubeCornerVertexCount * 3;
    if (!vertexData) {
        [self generateGLData:animation];
        return;
    }
    for (int i = 0; i < 8; i++) {
        [self generateDefaultCorner:i];
        if (![self isCornerPiece:i onFace:animation.face] || !animation) {
            continue;
        }
        for (int j = 0; j < 18; j++) {
            GLKVector3 point = GLKVector3Make(vertexData[cornerSize * i + j * 3],
                                              vertexData[cornerSize * i + j * 3 + 1],
                                              vertexData[cornerSize * i + j * 3 + 2]);
            point = [animation rotatePoint:point];
            vertexData[cornerSize * i + j * 3] = point.x;
            vertexData[cornerSize * i + j * 3 + 1] = point.y;
            vertexData[cornerSize * i + j * 3 + 2] = point.z;
        }
    }
}

#pragma mark - Private -

- (void)generateGLData:(ANCubeAnimation *)animation {
    // generate the vertex data for all 8 unrotated corner pieces
    int cornerSize = kCubeCornerVertexCount * 3;
    vertexData = (GLfloat *)malloc(sizeof(GLfloat) * kCubeCornerVertexCount * 3 * 8);
    GLfloat * corners = vertexData;
    for (int i = 0; i < 8; i++) {
        [self generateDefaultCorner:i];
    }
    if (animation) {
        // perform rotations
        for (int i = 0; i < 8; i++) {
            if (![self isCornerPiece:i onFace:animation.face]) continue;
            for (int j = 0; j < 18; j++) {
                GLKVector3 point = GLKVector3Make(corners[cornerSize * i + j * 3],
                                                  corners[cornerSize * i + j * 3 + 1],
                                                  corners[cornerSize * i + j * 3 + 2]);
                point = [animation rotatePoint:point];
                corners[cornerSize * i + j * 3] = point.x;
                corners[cornerSize * i + j * 3 + 1] = point.y;
                corners[cornerSize * i + j * 3 + 2] = point.z;
            }
        }
    }
    
    // create the color data
    colorData = (GLfloat *)malloc(sizeof(GLfloat) * 18 * 4 * 8);
    for (int i = 0; i < 8; i++) {
        ANCubePiece * piece = [[self cornerPieces] objectAtIndex:i];
        GLfloat * pieceColors = &colorData[i * (18 * 4)];
        ANCubeColor * colors = [piece edgeColors];
        for (int colorIndex = 0; colorIndex < 3; colorIndex++) {
            for (int i = 0; i < 6; i++) {
                [self copyColor:colors[colorIndex] toBuffer:&pieceColors[i * 4 + colorIndex * 6 * 4]];
            }
        }
    }
}

- (void)generateDefaultCorner:(int)i {
    int cornerSize = kCubeCornerVertexCount * 3;
    memcpy((void *)&vertexData[cornerSize * i], PositiveCorner, sizeof(GLfloat) * cornerSize);
    int x = (i >> 2) & 1;
    int y = (i >> 1) & 1;
    int z = i & 1; // my specification has Z going *towards* the user
    GLfloat scalar[3] = {x ? 1 : -1, y ? 1 : -1, z ? 1 : -1};
    for (int j = 0; j < kCubeCornerVertexCount; j++) {
        vertexData[cornerSize * i + j * 3] *= scalar[0];
        vertexData[cornerSize * i + j * 3 + 1] *= scalar[1];
        vertexData[cornerSize * i + j * 3 + 2] *= scalar[2];
    }
}

- (BOOL)isCornerPiece:(int)index onFace:(ANCubeAnimationFace)face {
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

- (void)copyColor:(ANCubeColor)color toBuffer:(GLfloat *)buffer {
    struct {
        GLfloat red, green, blue;
    } colors[] = {
        {1, 1, 1}, // white
        {1, 1, 0}, // yellow
        {0, 0, 1}, // blue
        {0, 1, 0}, // green
        {1, 0, 0}, // red
        {0.59, 0.59, 0.2} // orange
    };
    memcpy((void *)buffer, &colors[color - 1], sizeof(GLfloat) * 3);
    buffer[4] = 1;
}

@end
