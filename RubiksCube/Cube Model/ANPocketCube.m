//
//  ANPocketCube.m
//  RubiksCube
//
//  Created by Alex Nichol on 4/3/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANPocketCube.h"

@interface ANPocketCube (Private)

- (void)drawCorners:(GLKBaseEffect *)effect;

@end

@implementation ANPocketCube

@synthesize cornerPieces;
@synthesize animation;

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
    if (hasGenerated) {
        glDeleteBuffers(1, &cornerBuffer);
        glDeleteVertexArraysOES(1, &cornerVertexArray);
        free(data);
    }
}

#pragma mark - Drawing -

- (void)drawCube:(GLKBaseEffect *)effect {
    if (!hasGenerated) {
        [self generateGLData];
    }
        
    // first draw regular corners
    glBindVertexArrayOES(cornerVertexArray);
    [self drawCorners:effect];
}

- (void)drawTouchRecognition:(ANTouchRecognizer *)recog effect:(GLKBaseEffect *)effect {
    glBindVertexArrayOES(recog.cornerVertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, recog.cornerVertexBuffer);
    
    [self drawCorners:effect];
}

#pragma mark Generation

- (void)updateNewColors {
    for (int i = 0; i < 8; i++) {
        ANCubePiece * piece = [[self cornerPieces] objectAtIndex:i];
        GLfloat * pieceColors = &data[i * kCubeCornerVertexCount * kDataComponentCount];
        ANCubeColor * colors = [piece edgeColors];
        // loop through all three colored planes
        for (int colorIndex = 0; colorIndex < 3; colorIndex++) {
            GLfloat * planeData = &pieceColors[colorIndex * 6 * kDataComponentCount];
            // color the vertices individually
            for (int i = 0; i < 6; i++) {
                copyColorToBuffer(colors[colorIndex],
                                  &planeData[i * kDataComponentCount + 3]);
            }
        }
    }
    
    // update the framebuffer
    glBindVertexArrayOES(cornerVertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, cornerBuffer);
    
    int dataSize = kCubeCornerVertexCount * kDataComponentCount * sizeof(GLfloat) * 8;
    glBufferData(GL_ARRAY_BUFFER, dataSize, data, GL_STREAM_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 7 * sizeof(GLfloat), 0);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT,
                          GL_FALSE, 7 * sizeof(GLfloat),
                          (void *)(sizeof(GLfloat) * 3));
    
    glBindVertexArrayOES(0);

}

// only to be called if you really know what you're doing (you don't)
- (void)generateGLData {
    int cornerComponents = kCubeCornerVertexCount * kDataComponentCount;
    if (!data) {
        data = (GLfloat *)malloc(sizeof(GLfloat) * cornerComponents * 8);
    }
    for (int i = 0; i < 8; i++) {
        [self generateCornerAtIndex:i];
    }
    
    if (!hasGenerated) {
        glGenVertexArraysOES(1, &cornerVertexArray);
        glBindVertexArrayOES(cornerVertexArray);
        glGenBuffers(1, &cornerBuffer);
        hasGenerated = YES;
    }
    
    [self updateNewColors];
}

- (void)generateCornerAtIndex:(int)index {
    int offset = kCubeCornerVertexCount * kDataComponentCount * index;
    generateDefaultCorner(index, &data[offset], NO);
}

#pragma mark - Private -

- (void)drawCorners:(GLKBaseEffect *)effect {
    for (int i = 0; i < 8; i++) {
        if (animation) {
            if (isCornerPieceOnFace(i, animation.face)) continue;
        }
        glDrawArrays(GL_TRIANGLES, kCubeCornerVertexCount * i, kCubeCornerVertexCount);
    }
    if (animation) {
        GLKMatrix4 oldModel = effect.transform.modelviewMatrix;
        GLKVector4 rotation = [animation rotationInformation];
        effect.transform.modelviewMatrix = GLKMatrix4Rotate(oldModel,
                                                            rotation.v[0], rotation.v[1],
                                                            rotation.v[2], rotation.v[3]);
        [effect prepareToDraw];
        for (int i = 0; i < 8; i++) {
            if (!isCornerPieceOnFace(i, animation.face)) continue;
            glDrawArrays(GL_TRIANGLES, kCubeCornerVertexCount * i, kCubeCornerVertexCount);
        }
        effect.transform.modelviewMatrix = oldModel;
        [effect prepareToDraw];
    }
}

@end
