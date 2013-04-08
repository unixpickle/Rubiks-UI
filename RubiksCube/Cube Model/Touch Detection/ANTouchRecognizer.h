//
//  ANTouchRecognizer.h
//  RubiksCube
//
//  Created by Alex Nichol on 4/7/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANTouchPlane.h"
#import "ANCubeVertexData.h"

@interface ANTouchRecognizer : NSObject {
    NSArray * touchEdges;
    NSArray * touchCorners;
    BOOL isPocketCube;
    
    GLuint cornerVertexAray;
    GLuint cornerVertexBuffer;
    
    GLuint edgeVertexArray;
    GLuint edgeVertexBuffer;
}

@property (readonly) NSArray * touchEdges;
@property (readonly) NSArray * touchCorners;

@property (readonly) GLuint cornerVertexArray, cornerVertexBuffer;
@property (readonly) GLuint edgeVertexArray, edgeVertexBuffer;

- (id)initPocketCubeRecognizer;
- (id)initRubiksCubeRecognizer;

- (void)generateGLData;
- (void)destroyGLData;

- (ANTouchPlane *)touchPlaneForCorner:(int)corner axis:(int)axis;
- (ANTouchPlane *)touchPlaneForEdge:(int)edge axis:(int)axis;

@end
