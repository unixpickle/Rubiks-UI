//
//  ANViewController.m
//  RubiksCube
//
//  Created by Alex Nichol on 4/3/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANViewController.h"

@interface ANViewController ()
- (void)setupGL;
- (void)tearDownGL;
@end

@implementation ANViewController

@synthesize context, effect;

- (void)viewDidLoad
{
    GLKView * glkView = (GLKView *)self.view;
    glkView.drawableMultisample = GLKViewDrawableMultisample4X;
    
    cube = [[ANCube alloc] initIdentity];
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
}

- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.colorMaterialEnabled = GL_TRUE;
    
    glEnable(GL_DEPTH_TEST);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    
    self.effect = nil;
    
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update {
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0, 0, -7.0f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, M_PI / 4, 1, 1, 0);
    self.effect.transform.modelviewMatrix = modelViewMatrix;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.5, 0.5, 0.5, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    static NSDate * lastDate = nil;
    static double angle = M_PI / 4;
    
    NSDate * now = [NSDate date];
    if (lastDate) {
        angle += [now timeIntervalSinceDate:lastDate];
    }
    lastDate = now;
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0, 0, -8.0f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, angle / 4, 1, 1, 0);
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    
    // Render the object with GLKit
    [self.effect prepareToDraw];
    
    ANCubeAnimation * anim = [[ANCubeAnimation alloc] initWithFace:ANCubeAnimationFaceLeft];
    anim.angle = angle;
    [cube setAnimation:anim];
    [cube drawCube:self.effect];
}
@end
