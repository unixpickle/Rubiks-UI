//
//  ANCube.h
//  RubiksCube
//
//  Created by Alex Nichol on 4/3/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANPocketCube.h"

@interface ANCube : ANPocketCube {
    NSArray * edgePieces;
}

@property (readonly) NSArray * edgePieces;

+ (ANCube *)cubeIdentity;
- (id)initIdentity;
- (id)initWithCorners:(NSArray *)corners edges:(NSArray *)edges;

@end
