//
//  ANCubeAnimation.m
//  RubiksCube
//
//  Created by Alex Nichol on 4/3/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANCubeAnimation.h"

@implementation ANCubeAnimation

@synthesize face;

- (double)angle {
    return angle;
}

- (void)setAngle:(double)value {
    // create the rotation matrix
    angle = value;
    double xValue = face == ANCubeAnimationFaceLeft || face == ANCubeAnimationFaceRight ? 1 : 0;
    double yValue = face == ANCubeAnimationFaceBottom || face == ANCubeAnimationFaceTop ? 1 : 0;
    double zValue = face == ANCubeAnimationFaceFront || face == ANCubeAnimationFaceBack ? 1 : 0;
    rotationMatrix = GLKMatrix3MakeRotation(angle, xValue, yValue, zValue);
}

- (id)initWithFace:(ANCubeAnimationFace)theFace {
    if ((self = [super init])) {
        face = theFace;
    }
    return self;
}

- (GLKVector4)rotationInformation {
    double xValue = face == ANCubeAnimationFaceLeft || face == ANCubeAnimationFaceRight ? 1 : 0;
    double yValue = face == ANCubeAnimationFaceBottom || face == ANCubeAnimationFaceTop ? 1 : 0;
    double zValue = face == ANCubeAnimationFaceFront || face == ANCubeAnimationFaceBack ? 1 : 0;
    return GLKVector4Make(angle, xValue, yValue, zValue);
}

- (GLKVector3)rotatePoint:(GLKVector3)vector {
    return GLKMatrix3MultiplyVector3(rotationMatrix, vector);
}

@end
