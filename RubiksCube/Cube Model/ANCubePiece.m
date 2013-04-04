//
//  ANCubeEdgePiece.m
//  RubiksCube
//
//  Created by Alex Nichol on 4/3/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANCubePiece.h"

@implementation ANCubePiece

- (id)initWithColors:(ANCubeColor *)theColors {
    if ((self = [super init])) {
        memcpy((void *)colors, theColors, sizeof(ANCubeColor) * 3);
    }
    return self;
}

- (ANCubeColor *)edgeColors {
    return colors;
}

@end
