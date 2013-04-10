//
//  ANTouchPiece.h
//  RubiksCube
//
//  Created by Alex Nichol on 4/7/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <GLKit/GLKit.h>

typedef enum {
    ANTouchPieceTypeEdge = 1,
    ANTouchPieceTypeCorner = 2
} ANTouchPieceType;

@interface ANTouchPlane : NSObject {
    ANTouchPieceType pieceType;
    int axis; // x, y, or z
    int pieceIndex;
    __weak id userData;
}

@property (readonly) ANTouchPieceType pieceType;
@property (readonly) int axis;
@property (readonly) int pieceIndex;
@property (nonatomic, weak) id userData;

- (id)initWithPieceType:(ANTouchPieceType)type axis:(int)theAxis index:(int)theIndex;
- (GLKVector3)characteristicColor; // 255 color

@end
