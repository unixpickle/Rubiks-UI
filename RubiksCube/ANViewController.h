//
//  ANViewController.h
//  RubiksCube
//
//  Created by Alex Nichol on 4/3/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "ANCube.h"

@interface ANViewController : GLKViewController {
    ANPocketCube * cube;
    EAGLContext * context;
    GLKBaseEffect * effect;
}

@property (nonatomic, retain) EAGLContext * context;
@property (nonatomic, retain) GLKBaseEffect * effect;

@end
