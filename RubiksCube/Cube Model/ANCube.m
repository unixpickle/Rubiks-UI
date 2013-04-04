//
//  ANCube.m
//  RubiksCube
//
//  Created by Alex Nichol on 4/3/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANCube.h"

@implementation ANCube

@synthesize edgePieces;

+ (ANCube *)cubeIdentity {
    return [[ANCube alloc] initIdentity];
}

- (id)initIdentity {
    const unsigned char EdgePieces[12][3] = {
        {0,3,1},
        {5,0,1},
        {0,4,1},
        {6,0,1},
        {6,3,0},
        {5,3,0},
        {0,3,2},
        {5,0,2},
        {0,4,2},
        {6,0,2},
        {6,4,0},
        {5,4,0}
    };
    if ((self = [super initIdentity])) {
        // generate the edges
        NSMutableArray * mEdges = [[NSMutableArray alloc] init];
        for (int i = 0; i < 12; i++) {
            ANCubeColor colors[3];
            colors[0] = (ANCubeColor)EdgePieces[i][0];
            colors[1] = (ANCubeColor)EdgePieces[i][1];
            colors[2] = (ANCubeColor)EdgePieces[i][2];
            ANCubePiece * piece = [[ANCubePiece alloc] initWithColors:colors];
            [mEdges addObject:piece];
        }
        edgePieces = [mEdges copy];
    }
    return self;
}

- (id)initWithCorners:(NSArray *)corners edges:(NSArray *)edges {
    if ((self = [super init])) {
        cornerPieces = corners;
        edgePieces = edges;
    }
    return self;
}

@end
