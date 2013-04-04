//
//  ANCubeEdgePiece.h
//  RubiksCube
//
//  Created by Alex Nichol on 4/3/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ANCubeColorNone,
    ANCubeColorWhite,
    ANCubeColorYellow,
    ANCubeColorBlue,
    ANCubeColorGreen,
    ANCubeColorRed,
    ANCubeColorOrange
} ANCubeColor;

@interface ANCubePiece : NSObject {
    ANCubeColor colors[3]; // {xColor, yColor, zColor}
}

- (id)initWithColors:(ANCubeColor *)theColors;
- (ANCubeColor *)edgeColors;

@end
