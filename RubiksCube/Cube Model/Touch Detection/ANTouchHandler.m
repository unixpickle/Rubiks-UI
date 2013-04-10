//
//  ANTouchHandler.m
//  RubiksCube
//
//  Created by Alex Nichol on 4/9/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANTouchHandler.h"

@implementation ANTouchHandler

- (id)initWithCube:(ANPocketCube *)theCube recognizer:(ANTouchRecognizer *)theRecognizer {
    if ((self = [super init])) {
        cube = theCube;
        recognizer = theRecognizer;
    }
    return self;
}

- (ANTouchPlane *)planeAtPoint:(CGPoint)point
                  viewportSize:(CGSize)size
                        effect:(GLKBaseEffect *)effect {
    GLint oldBuffer = 0;
    GLint oldViewport[4];
    glGetIntegerv(GL_FRAMEBUFFER_BINDING_OES, &oldBuffer);
    glGetIntegerv(GL_VIEWPORT, oldViewport);
    
    NSInteger height = (NSUInteger)size.height;
    NSInteger width = (NSUInteger)size.width;
    Byte pixelColor[4] = {0,};
    GLuint colorRenderbuffer;
    GLuint depthRenderbuffer;
    GLuint framebuffer;
    
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glGenRenderbuffers(1, &colorRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    
    glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8_OES, width, height);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER, colorRenderbuffer);
    
    glGenRenderbuffers(1, &depthRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
    
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);
    
    glBindRenderbuffer(GL_RENDERBUFFER, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Framebuffer status: %x", (int)status);
        return 0;
    }
    
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [effect prepareToDraw];
    [cube drawTouchRecognition:recognizer effect:effect];
    
    CGFloat scale = UIScreen.mainScreen.scale;
    glReadPixels(point.x * scale, (height - (point.y * scale)), 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, pixelColor);
    
    glDeleteRenderbuffers(1, &colorRenderbuffer);
    glDeleteRenderbuffers(1, &depthRenderbuffer);
    glDeleteFramebuffers(1, &framebuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, oldBuffer);
    glViewport(oldViewport[0], oldViewport[1], oldViewport[2], oldViewport[3]);
    
    GLKVector3 colorVec = GLKVector3Make((float)pixelColor[0],
                                         (float)pixelColor[1],
                                         (float)pixelColor[2]);
    
    return [recognizer touchPlaneForColor:colorVec];
}

- (void)toggleColorAtPoint:(CGPoint)point
              viewportSize:(CGSize)size
                    effect:(GLKBaseEffect *)effect {
    ANTouchPlane * plane = [self planeAtPoint:point viewportSize:size effect:effect];
    if (!plane) return;
    ANCubePiece * piece = nil;
    if (plane.pieceType == ANTouchPieceTypeCorner) {
        piece = [cube.cornerPieces objectAtIndex:plane.pieceIndex];
    } else if (plane.pieceType == ANTouchPieceTypeEdge) {
        if (![cube isKindOfClass:[ANCube class]]) return;
        ANCube * theCube = (ANCube *)cube;
        piece = [theCube.edgePieces objectAtIndex:plane.pieceIndex];
    }
    ANCubeColor * colors = [piece edgeColors];
    colors[plane.axis] ++;
    if (colors[plane.axis] > 6) {
        colors[plane.axis] = 1;
    }
}

@end
