//
//  ANTouchHandler.h
//  RubiksCube
//
//  Created by Alex Nichol on 4/9/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANCube.h"

@interface ANTouchHandler : NSObject {
    ANPocketCube * cube;
    ANTouchRecognizer * recognizer;
}

- (id)initWithCube:(ANPocketCube *)theCube recognizer:(ANTouchRecognizer *)theRecognizer;

- (ANTouchPlane *)planeAtPoint:(CGPoint)point
                  viewportSize:(CGSize)size
                        effect:(GLKBaseEffect *)effect;

- (void)toggleColorAtPoint:(CGPoint)point
              viewportSize:(CGSize)size
                    effect:(GLKBaseEffect *)effect;

@end
