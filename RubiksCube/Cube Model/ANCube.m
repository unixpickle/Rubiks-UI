//
//  ANCube.m
//  RubiksCube
//
//  Created by Alex Nichol on 4/3/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANCube.h"

@interface ANCube ()

- (void)generateCenterData;

@end

@implementation ANCube

@synthesize edgePieces;

+ (ANCube *)cubeIdentity {
    return [[ANCube alloc] initIdentity];
}

- (id)initIdentity {
    const unsigned char EdgePieces[12][3] = {
        {0,3,1},
        {5,0,1},
        {0,4,1},
        {6,0,1},
        {6,3,0},
        {5,3,0},
        {0,3,2},
        {5,0,2},
        {0,4,2},
        {6,0,2},
        {6,4,0},
        {5,4,0}
    };
    if ((self = [super initIdentity])) {
        // generate the edges
        NSMutableArray * mEdges = [[NSMutableArray alloc] init];
        for (int i = 0; i < 12; i++) {
            ANCubeColor colors[3];
            colors[0] = (ANCubeColor)EdgePieces[i][0];
            colors[1] = (ANCubeColor)EdgePieces[i][1];
            colors[2] = (ANCubeColor)EdgePieces[i][2];
            ANCubePiece * piece = [[ANCubePiece alloc] initWithColors:colors];
            [mEdges addObject:piece];
        }
        edgePieces = [mEdges copy];
    }
    return self;
}

- (id)initWithCorners:(NSArray *)corners edges:(NSArray *)edges {
    if ((self = [super init])) {
        cornerPieces = corners;
        edgePieces = edges;
    }
    return self;
}

- (void)dealloc {
    if (hasGenerated) {
        glDeleteBuffers(1, &edgeBuffer);
        glDeleteVertexArraysOES(1, &edgeVertexArray);
        glDeleteBuffers(1, &centerBuffer);
        glDeleteVertexArraysOES(1, &centerVertexArray);
        free(edgeData);
    }
}

#pragma mark - Drawing -

- (void)drawCube:(GLKBaseEffect *)effect {
    [super drawCube:effect];
    
    // first draw regular corners
    glBindVertexArrayOES(edgeVertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, edgeBuffer);
    
    for (int i = 0; i < 12; i++) {
        if (animation) {
            if (isEdgePieceOnFace(i, animation.face)) continue;
        }
        glDrawArrays(GL_TRIANGLES, kCubeEdgeVertexCount * i, kCubeEdgeVertexCount);
    }
    if (animation) {
        GLKMatrix4 oldModel = effect.transform.modelviewMatrix;
        GLKVector4 rotation = [animation rotationInformation];
        effect.transform.modelviewMatrix = GLKMatrix4Rotate(oldModel,
                                                            rotation.v[0], rotation.v[1],
                                                            rotation.v[2], rotation.v[3]);
        [effect prepareToDraw];
        for (int i = 0; i < 12; i++) {
            if (!isEdgePieceOnFace(i, animation.face)) continue;
            glDrawArrays(GL_TRIANGLES, kCubeEdgeVertexCount * i, kCubeEdgeVertexCount);
        }

        glBindVertexArrayOES(centerVertexArray);
        glBindBuffer(GL_ARRAY_BUFFER, centerBuffer);
        for (int i = 0; i < 6; i++) {
            if (!isCenterPieceOnFace(i, animation.face)) continue;
            glDrawArrays(GL_TRIANGLES, kCubeCenterVertexCount * i, kCubeCenterVertexCount);
        }
        
        effect.transform.modelviewMatrix = oldModel;
        [effect prepareToDraw];
    } else {
        glBindVertexArrayOES(centerVertexArray);
        glBindBuffer(GL_ARRAY_BUFFER, centerBuffer);
    }
    
    // draw regular centers
    
    for (int i = 0; i < 6; i++) {
        if (animation) {
            if (isCenterPieceOnFace(i, animation.face)) continue;
        }
        glDrawArrays(GL_TRIANGLES, kCubeCenterVertexCount * i, kCubeCenterVertexCount);
    }
}

- (void)updateNewColors {
    // loop through edge pieces
    for (int i = 0; i < 12; i++) {
        ANCubeColor colors[2];
        GLfloat * edgePiece = &edgeData[kCubeEdgeVertexCount * kDataComponentCount * i];
        // color the piece
        if (EdgePieceInfo[i].pieceOrientation == 0) {
            colors[0] = [[self.edgePieces objectAtIndex:i] edgeColors][1];
            colors[1] = [[self.edgePieces objectAtIndex:i] edgeColors][2];
        } else if (EdgePieceInfo[i].pieceOrientation == 1) {
            colors[0] = [[self.edgePieces objectAtIndex:i] edgeColors][0];
            colors[1] = [[self.edgePieces objectAtIndex:i] edgeColors][2];
        } else if (EdgePieceInfo[i].pieceOrientation == 2) {
            colors[1] = [[self.edgePieces objectAtIndex:i] edgeColors][0];
            colors[0] = [[self.edgePieces objectAtIndex:i] edgeColors][1];
        }
        for (int i = 0; i < 2; i++) {
            GLfloat * face = &edgePiece[i * 6 * kDataComponentCount];
            for (int j = 0; j < 6; j++) {
                GLfloat * vertexColor = &face[j * kDataComponentCount + 3];
                copyColorToBuffer(colors[i], vertexColor);
            }
        }
    }
    
    glBindVertexArrayOES(edgeVertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, edgeBuffer);
    
    int dataSize = kCubeEdgeVertexCount * kDataComponentCount * sizeof(GLfloat) * 12;
    glBufferData(GL_ARRAY_BUFFER, dataSize, edgeData, GL_STREAM_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 7 * sizeof(GLfloat), 0);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT,
                          GL_FALSE, 7 * sizeof(GLfloat),
                          (void *)(sizeof(GLfloat) * 3));
    
    glBindVertexArrayOES(0);
    
    [super updateNewColors];
}

- (void)generateGLData {    
    if (!edgeData) {
        edgeData = (GLfloat *)malloc(sizeof(GLfloat) * kCubeEdgeVertexCount * kDataComponentCount * 12);
    }
    if (!hasGenerated) {
        glGenVertexArraysOES(1, &edgeVertexArray);
        glBindVertexArrayOES(edgeVertexArray);
        glGenBuffers(1, &edgeBuffer);
        [self generateCenterData];
    }
    for (int i = 0; i < 12; i++) {
        generateDefaultEdge(i, &edgeData[kCubeEdgeVertexCount * kDataComponentCount * i]);
    }
    [super generateGLData];
}

- (void)generateCornerAtIndex:(int)index {
    int offset = kCubeCornerVertexCount * kDataComponentCount * index;
    generateDefaultCorner(index, &data[offset], YES);
}

#pragma mark Private

- (void)generateCenterData {
    GLfloat * centerData = (GLfloat *)malloc(sizeof(GLfloat) * kCubeCenterVertexCount * kDataComponentCount * 6);
    for (int i = 0; i < 6; i++) {
        // copy the default center data
        generateDefaultCenter(i, &centerData[kCubeCenterVertexCount * kDataComponentCount * i]);
    }
    
    glGenVertexArraysOES(1, &centerVertexArray);
    glBindVertexArrayOES(centerVertexArray);
    glGenBuffers(1, &centerBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, centerBuffer);
    
    int dataSize = kCubeCenterVertexCount * kDataComponentCount * sizeof(GLfloat) * 6;
    glBufferData(GL_ARRAY_BUFFER, dataSize, centerData, GL_STATIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 7 * sizeof(GLfloat), 0);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT,
                          GL_FALSE, 7 * sizeof(GLfloat),
                          (void *)(sizeof(GLfloat) * 3));
    
    glBindVertexArrayOES(0);
}

@end
