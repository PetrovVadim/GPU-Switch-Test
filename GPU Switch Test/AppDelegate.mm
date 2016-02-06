//
//  AppDelegate.m
//  GPU Switch Test
//
//  Created by Vadim Petrov on 07/02/16.
//  Copyright (c) 2016 Vadim Petrov. All rights reserved.
//

#import "AppDelegate.h"
#include <OpenGL/OpenGL.h>
#include <OpenGL/gl3.h>
#include <vector>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    CGLPixelFormatObj pix;
    GLint npix;
    // Use discrete GPU
    CGLPixelFormatAttribute attribs = { (CGLPixelFormatAttribute)0 };
    
    // Switch to discrete GPU
    CGLChoosePixelFormat(&attribs, &pix, &npix);
    // Release discrete GPU
    CGLReleasePixelFormat(pix);
    
    // wait 1 second for the graphics card switch
    [self performSelector:@selector(printCurrentCardName)
               withObject:self
               afterDelay:1.0f];
}

- (void)printCurrentCardName {
    CGLContextObj ctx;
    CGLPixelFormatObj pix;
    GLint npix;
    std::vector<CGLPixelFormatAttribute> attribs;
    
    // Use current GPU
    attribs.push_back(kCGLPFAAllowOfflineRenderers);
    attribs.push_back((CGLPixelFormatAttribute) 0);
    
    CGLError err = CGLChoosePixelFormat(&attribs.front(), &pix, &npix);
    CGLCreateContext(pix, NULL, &ctx);
    CGLSetCurrentContext(ctx);
    
    printf("%s %s\n", glGetString(GL_RENDERER), glGetString(GL_VERSION));
    
    CGLSetCurrentContext(nullptr);
    CGLDestroyContext(ctx);
    CGLReleasePixelFormat(pix);
    
    // [NSApp terminate:nil];
}

@end
