//
//  GLESView8.m
//  OpenGL ES Learning
//
//  Created by 李超群 on 2019/2/14.
//  Copyright © 2019 李超群. All rights reserved.
//

#import "GLESView8.h"
#import "GLESUtils.h"
#import "GLESMath.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import "skull.h"
#import "Orange.h"
#import "Lamborghini_Aventador.h"

typedef struct {
    GLuint position;
    GLuint textCoordinate;
    GLuint projectionMat;
    GLuint modelViewMat;
}ShaderV;

#define skull 1

@implementation GLESView8{
    CAEAGLLayer *_glLayer;
    EAGLContext *_glContext;
    GLuint _programHandle;
    ShaderV _lint;
    
    GLuint _VAO;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupContext];
        [self setupLayer];
        
        [self setupBuffer];
        [self setupShader];
        [self setupTextur];
        
        [self render];
        
    }
    return self;
}

+(Class)layerClass{
    return [CAEAGLLayer class];
}

-(void)setupContext{
    _glContext = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_glContext];
}

-(void)setupLayer{
    _glLayer = (CAEAGLLayer *)self.layer;
    _glLayer.opaque = YES;
    _glLayer.drawableProperties = @{
                                    kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8,
                                    kEAGLDrawablePropertyRetainedBacking : @(NO)
                                    };
}

-(void)setupBuffer{
    GLuint depthRenderBufferID;
    glGenRenderbuffers(1, &depthRenderBufferID);
    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderBufferID);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
    
    GLuint colorRenderBufferID;
    glGenRenderbuffers(1, &colorRenderBufferID);
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBufferID);
    [_glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_glLayer];
    
    GLuint frameBufferID;
    glGenFramebuffers(1, &frameBufferID);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBufferID);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderBufferID);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderBufferID);
    
    glEnable(GL_DEPTH_TEST);
}

-(void)setupShader{
    NSString * vertextShaderPath = [[NSBundle mainBundle] pathForResource:@"VertextShader8" ofType:@"glsl"];
    NSString * fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"FragmentShader8" ofType:@"glsl"];
    GLuint vertextShader = [GLESUtils loadShader:GL_VERTEX_SHADER withFilepath:vertextShaderPath];
    GLuint framegmentShader = [GLESUtils loadShader:GL_FRAGMENT_SHADER withFilepath:fragmentShaderPath];
    _programHandle = glCreateProgram();
    glAttachShader(_programHandle, vertextShader);
    glAttachShader(_programHandle, framegmentShader);
    glLinkProgram(_programHandle);
    glUseProgram(_programHandle);
    
    [self setupShaderData];
}
-(void)setupShaderData{
    _lint.position = glGetAttribLocation(_programHandle, "position");
    _lint.textCoordinate = glGetAttribLocation(_programHandle, "textCoordinate");
    _lint.projectionMat = glGetUniformLocation(_programHandle, "projectionMat");
    _lint.modelViewMat = glGetUniformLocation(_programHandle, "modelViewMat");
    
    glEnableVertexAttribArray(_lint.position);
    glEnableVertexAttribArray(_lint.textCoordinate);
    glEnableVertexAttribArray(_lint.projectionMat);
    glEnableVertexAttribArray(_lint.modelViewMat);
}

-(void)setupTextur{
#if (skull == 1)
    CGImageRef imgRef = [UIImage imageNamed:@"jinshu.jpg"].CGImage;
#elif (skull == 2)
    CGImageRef imgRef = [UIImage imageNamed:@"Lamborginhi Aventador_diffuse.jpeg"].CGImage;
#elif (skull == 3)
    CGImageRef imgRef = [UIImage imageNamed:@"Orange_Color.jpg"].CGImage;
#endif
    size_t width = CGImageGetWidth(imgRef);
    size_t height = CGImageGetHeight(imgRef);
    GLubyte *imgData = (GLubyte *)calloc(width * height * 4, sizeof(GLbyte));
    
    CGContextRef contextRef = CGBitmapContextCreate(imgData, width, height, 8, width * 4, CGImageGetColorSpace(imgRef), kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imgRef);
    CGContextRelease(contextRef);
    
    GLuint textureID;
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_2D, textureID);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imgData);
    
    free(imgData);
}

-(void)render{
    
    glGenVertexArrays(1, &_VAO);
    glBindVertexArray(_VAO);
    
    GLuint VBO, VBO1;
    glGenBuffers(1, &VBO);
    glGenBuffers(1, &VBO1);
    
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
#if (skull == 1)
    glBufferData(GL_ARRAY_BUFFER, sizeof(skullVerts), skullVerts, GL_STATIC_DRAW);
#elif (skull == 2)
    glBufferData(GL_ARRAY_BUFFER, sizeof(Lamborghini_AventadorVerts), Lamborghini_AventadorVerts, GL_STATIC_DRAW);
#elif (skull == 3)
    glBufferData(GL_ARRAY_BUFFER, sizeof(OrangeVerts), OrangeVerts, GL_STATIC_DRAW);
#endif
    glVertexAttribPointer(_lint.position, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GL_FLOAT), NULL);
    
    glBindBuffer(GL_ARRAY_BUFFER, VBO1);
#if (skull == 1)
    glBufferData(GL_ARRAY_BUFFER, sizeof(skullTexCoords), skullTexCoords, GL_STATIC_DRAW);
#elif (skull == 2)
    glBufferData(GL_ARRAY_BUFFER, sizeof(Lamborghini_AventadorTexCoords), Lamborghini_AventadorTexCoords, GL_STATIC_DRAW);
#elif (skull == 3)
    glBufferData(GL_ARRAY_BUFFER, sizeof(OrangeTexCoords), OrangeTexCoords, GL_STATIC_DRAW);
#endif
    glVertexAttribPointer(_lint.textCoordinate, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(GL_FLOAT), NULL);

    // - 设置显示区域
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    [self updateRender];
    
}

-(void)updateRender{
    [self setupShaderData];
    glBindVertexArray(_VAO);
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    float aspect = width / height; //长宽比
    
    // - 模型矩阵 (世界空间)
    KSMatrix4 modelMat;
    ksMatrixLoadIdentity(&modelMat);
    ksRotate(&modelMat, self.rote.roteY, 1.0, 0.0, 0.0); //绕X轴
    ksRotate(&modelMat, self.rote.roteX, 0.0, 1.0, 0.0); //绕Y轴
    ksScale(&modelMat, self.scale, self.scale, self.scale);

    // - 观察矩阵 (观察空间)
    KSMatrix4 viewMat;
    ksMatrixLoadIdentity(&viewMat);
    ksTranslate(&viewMat, 0.0, 0.0, -5);
    
    //投影矩阵 (裁剪空间)
    KSMatrix4 projectionMat;
    ksMatrixLoadIdentity(&projectionMat);
    ksPerspective(&projectionMat, 45.0, aspect, 0.1f, 100.0f); //透视变换，视角30°
    glUniformMatrix4fv(_lint.projectionMat, 1, GL_FALSE, (GLfloat*)&projectionMat.m[0][0]);
    
    //把变换矩阵相乘，注意先后顺序
    ksMatrixMultiply(&viewMat, &modelMat, &viewMat);
    glUniformMatrix4fv(_lint.modelViewMat, 1, GL_FALSE, (GLfloat*)&viewMat.m[0][0]);
    
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
#if (skull == 1)
    glDrawArrays(GL_TRIANGLES, 0, skullNumVerts);
#elif (skull == 2)
    glDrawArrays(GL_TRIANGLES, 0, Lamborghini_AventadorNumVerts);
#elif (skull == 3)
    glDrawArrays(GL_TRIANGLES, 0, OrangeNumVerts);
#endif
    [_glContext presentRenderbuffer:GL_RENDERBUFFER];
}

@end
