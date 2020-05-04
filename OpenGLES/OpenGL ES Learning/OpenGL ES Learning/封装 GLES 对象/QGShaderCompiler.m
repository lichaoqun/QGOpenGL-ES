//
//  QGShaderCompiler.m
//  OpenGL ES Learning
//
//  Created by QG on 2020/5/4.
//  Copyright © 2020 李超群. All rights reserved.
//

#import "QGShaderCompiler.h"

@implementation QGShaderCompiler{
    NSMutableArray *_attributes;
}

- (instancetype)initWithvshader:(NSString *)vshader fshader:(NSString *)fshader{
    self = [super init];
    if (self) {
        [self compiltVshader:vshader fshader:fshader];
    }
    return self;
}

- (instancetype)initWithvshaderPath:(NSString *)vshaderPath fshaderPath:(NSString *)fshaderPath{
    NSString *vshaderString = [NSString stringWithContentsOfFile:vshaderPath encoding:NSUTF8StringEncoding error:nil];
    NSString *fshaderString = [NSString stringWithContentsOfFile:fshaderPath encoding:NSUTF8StringEncoding error:nil];
    return [self initWithvshaderPath:vshaderString fshaderPath:fshaderString];
}

-(void)compiltVshader:(NSString *)vshader fshader:(NSString *)fshader{
    GLuint vertextShader = [GLESUtils loadShader:GL_VERTEX_SHADER withString:vshader];
    GLuint framegmentShader = [GLESUtils loadShader:GL_FRAGMENT_SHADER withString:fshader];
    
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertextShader);
    glAttachShader(programHandle, framegmentShader);
    glLinkProgram(programHandle);
}

-(void)glUseProgram:(GLuint)program{
    glUseProgram(program);
}
@end
