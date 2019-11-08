//
//  GLESView4.m
//  OpenGL ES Learning
//
//  Created by 李超群 on 2019/2/9.
//  Copyright © 2019 李超群. All rights reserved.
//

#import "GLESView10.h"
#import "GLESUtils.h"
#import "GLESMath.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import <GLKit/GLKit.h>
#import <GLKit/GLKit.h>
#import "cube.h"
#define PI 3.1415926535898
#define ANGLE_TO_RADIAN(angle) angle * (PI / 180.0f)

typedef struct {
    GLuint position;
    GLuint normal;
    GLuint textCoordinate;
    GLuint projectionMat;
    GLuint modelMat;
    GLuint viewMat;
    GLuint normalMat;
}ShaderV;

typedef struct {
    GLuint viewPos;
    GLuint material_smoothness;
    GLuint light_position;
    GLuint light_diffuseColor;
    GLuint light_ambientColor;
    GLuint light_specularColor;
}ShaderF;

static int count = 2;

@implementation GLESView10{
    CAEAGLLayer *_glLayer;
    EAGLContext *_glContext;
    GLuint _programHandle;
    ShaderV _shaderV;
    ShaderF _shaderF;
    
    GLuint *_texture;
    GLuint _VAO;
}

- (instancetype)initWithFrame:(CGRect)frame
{
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
                                    kEAGLDrawablePropertyRetainedBacking : @(NO),
                                    };
}

-(void)setupBuffer{
    // - depthBuffer
    GLuint depthRenderBuffer;
    glGenRenderbuffers(1, &depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);

    // - renderBuffer
    GLuint colorRenderBuffer;
    glGenRenderbuffers(1, &colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
    [_glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_glLayer];
    
    // - frameBuffer
    GLuint frameBuffer;
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderBuffer);
    
    glEnable(GL_DEPTH_TEST);
}

-(void)setupShader{
    NSString * vertextShaderPath = [[NSBundle mainBundle] pathForResource:@"VertextShader10" ofType:@"glsl"];
    NSString * fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"FragmentShader10" ofType:@"glsl"];
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
    _shaderV.position = glGetAttribLocation(_programHandle, "position");
    _shaderV.normal = glGetAttribLocation(_programHandle, "normal");
    _shaderV.textCoordinate = glGetAttribLocation(_programHandle, "textCoord");
    _shaderV.projectionMat = glGetUniformLocation(_programHandle, "projectionMat");
    _shaderV.modelMat = glGetUniformLocation(_programHandle, "modelMat");
    _shaderV.viewMat = glGetUniformLocation(_programHandle, "viewMat");
    _shaderV.normalMat = glGetUniformLocation(_programHandle, "normalMat");

    _shaderF.light_position = glGetUniformLocation(_programHandle, "light.position");
    _shaderF.light_diffuseColor = glGetUniformLocation(_programHandle, "light.diffuse");
    _shaderF.light_ambientColor = glGetUniformLocation(_programHandle, "light.ambient");
    _shaderF.light_specularColor = glGetUniformLocation(_programHandle, "light.specular");
    _shaderF.material_smoothness = glGetUniformLocation(_programHandle, "material.shininess");
    _shaderF.viewPos = glGetUniformLocation(_programHandle, "viewPos");

    glUniform3f(_shaderF.light_position, 1.2, 1.0, 2.0);
    glUniform3f(_shaderF.light_ambientColor, 0.2, 0.2, 0.2);
    glUniform3f(_shaderF.light_diffuseColor, 1.0f, 1.0f, 1.0f);
    glUniform3f(_shaderF.light_specularColor,1.0f, 1.0f, 1.0f);
    glUniform1f(_shaderF.material_smoothness, 2);
    glUniform3f(_shaderF.viewPos, 0.0, 0.0, 3.0);
    
    glEnableVertexAttribArray(_shaderV.position);
    glEnableVertexAttribArray(_shaderV.normal);
    glEnableVertexAttribArray(_shaderV.textCoordinate);
}

-(void)setupTextur{
    _texture = malloc(sizeof(GLuint) * count);
    glGenTextures(count, _texture);
    NSArray *imgTitles = @[@"box_1", @"box_2"];
    for (int idx = 0; idx < count; idx++) {
        NSString *obj = imgTitles[idx];
        CGImageRef imgRef = [UIImage imageNamed:obj].CGImage;
        size_t width = CGImageGetWidth(imgRef);
        size_t height = CGImageGetHeight(imgRef);
        GLubyte *imgData = (GLubyte *)calloc(width * height * 4, sizeof(GLbyte));
        
        CGContextRef contextRef = CGBitmapContextCreate(imgData, width, height, 8, width * 4, CGImageGetColorSpace(imgRef), kCGImageAlphaPremultipliedLast);
        CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imgRef);
        CGContextRelease(contextRef);
        
        glBindTexture(GL_TEXTURE_2D, _texture[idx]);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imgData);
        free(imgData);
    }
}

-(void)render{
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);

    // - VAO (顶点数组对象)
    glGenVertexArrays(1, &_VAO);
    glBindVertexArray(_VAO);
    
    // - VBO (顶点缓冲对象)
    GLuint VBO, VBO1, VBO2;
    glGenBuffers(1, &VBO);
    glGenBuffers(1, &VBO1);
    glGenBuffers(1, &VBO2);

    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(cubeVerts), cubeVerts, GL_STATIC_DRAW);
    glVertexAttribPointer(_shaderV.position, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GL_FLOAT), NULL);
    
    glBindBuffer(GL_ARRAY_BUFFER, VBO1);
    glBufferData(GL_ARRAY_BUFFER, sizeof(cubeNormals), cubeNormals, GL_STATIC_DRAW);
    glVertexAttribPointer(_shaderV.normal, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GL_FLOAT), NULL);

    glBindBuffer(GL_ARRAY_BUFFER, VBO2);
    glBufferData(GL_ARRAY_BUFFER, sizeof(cubeTexCoords), cubeTexCoords, GL_STATIC_DRAW);
    glVertexAttribPointer(_shaderV.textCoordinate, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(GL_FLOAT), NULL);

    // - 设置显示区域
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    [self updateRender];
}

-(void)updateRender{
    if (_texture == NULL)  return;
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    [self setupShaderData];
    glBindVertexArray(_VAO);

    float width = self.frame.size.width;
    float height = self.frame.size.height;
    float aspect = width / height; //长宽比
    
    // - 模型矩阵 (世界空间)
    GLKMatrix4 modelMat = GLKMatrix4Rotate(GLKMatrix4Identity, ANGLE_TO_RADIAN(self.rote.roteY), 1.0, 0.0, 0.0);
    modelMat = GLKMatrix4Rotate(modelMat, ANGLE_TO_RADIAN(self.rote.roteX), 0.0, 1.0, 0.0);
    modelMat = GLKMatrix4Scale(modelMat, self.scale, self.scale, self.scale);
    glUniformMatrix4fv(_shaderV.modelMat, 1, GL_FALSE, modelMat.m);
    
    // - 法线矩阵
    bool canInvert;
    GLKMatrix4 normalMat = GLKMatrix4InvertAndTranspose(modelMat, &canInvert);
    normalMat = canInvert ? normalMat : GLKMatrix4Identity;
    glUniformMatrix4fv(_shaderV.normalMat, 1, GL_FALSE, normalMat.m);
    
    // - 观察矩阵 (观察空间)
    GLKMatrix4 viewMat = GLKMatrix4Translate(GLKMatrix4Identity,  0.0, 0.0, -5.0);
    glUniformMatrix4fv(_shaderV.viewMat, 1, GL_FALSE, viewMat.m);
    
    //投影矩阵 (裁剪空间)
    GLKMatrix4 projectionMat = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45),  aspect, 0.1, 1000.0);
    glUniformMatrix4fv(_shaderV.projectionMat, 1, GL_FALSE, projectionMat.m);

    for (int idx = 0; idx < count; idx++) {
        glActiveTexture(GL_TEXTURE0 + idx);
        glBindTexture(GL_TEXTURE_2D, _texture[idx]);
    }
    
    glDrawArrays(GL_TRIANGLES, 0, cubeNumVerts);
    [_glContext presentRenderbuffer:GL_RENDERBUFFER];
}
@end
