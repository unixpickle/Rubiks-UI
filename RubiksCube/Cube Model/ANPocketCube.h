//
//  ANPocketCube.h
//  RubiksCube
//
//  Created by Alex Nichol on 4/3/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "ANCubePiece.h"
#import "ANCubeAnimation.h"
#import "ANCubeVertexData.h"
#import "ANTouchRecognizer.h"

@interface ANPocketCube : NSObject {
    NSArray * cornerPieces;
    
    GLfloat * data; // vertex and color data
    
    BOOL hasGenerated;
    GLuint cornerVertexArray;
    GLuint cornerBuffer;
    
    ANCubeAnimation * animation;
}

@property (readonly) NSArray * cornerPieces;
@property (nonatomic, retain) ANCubeAnimation * animation;

+ (ANPocketCube *)pocketCubeIdentity;
- (id)initIdentity;

- (void)drawCube:(GLKBaseEffect *)effect;
- (void)drawTouchRecognition:(ANTouchRecognizer *)recog effect:(GLKBaseEffect *)effect;
- (void)updateNewColors;

// only to be called if you really know what you're doing (you don't)
- (void)generateGLData;
- (void)generateCornerAtIndex:(int)index;

@end
