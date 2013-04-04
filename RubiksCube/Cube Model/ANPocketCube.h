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

@interface ANPocketCube : NSObject {
    NSArray * cornerPieces;
    
    GLfloat * vertexData;
    GLfloat * colorData;
}

@property (readonly) NSArray * cornerPieces;

+ (ANPocketCube *)pocketCubeIdentity;
- (id)initIdentity;

- (void)drawCube;
- (void)updateWithAnimation:(ANCubeAnimation *)animation;

@end
