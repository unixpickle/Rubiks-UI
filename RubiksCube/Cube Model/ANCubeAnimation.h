//
//  ANCubeAnimation.h
//  RubiksCube
//
//  Created by Alex Nichol on 4/3/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

typedef enum {
    ANCubeAnimationFaceTop,
    ANCubeAnimationFaceBottom,
    ANCubeAnimationFaceRight,
    ANCubeAnimationFaceLeft,
    ANCubeAnimationFaceFront,
    ANCubeAnimationFaceBack
} ANCubeAnimationFace;

@interface ANCubeAnimation : NSObject {
    double angle;
    ANCubeAnimationFace animatingFace;
    GLKMatrix3 rotationMatrix;
}

@property (readwrite) double angle;
@property (readonly) ANCubeAnimationFace face;

- (id)initWithFace:(ANCubeAnimationFace)theFace;
- (GLKVector3)rotatePoint:(GLKVector3)vector;
- (GLKVector4)rotationInformation;

@end
