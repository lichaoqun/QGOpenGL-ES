//
//  GLESView8.m
//  OpenGL ES Learning
//
//  Created by 李超群 on 2019/2/14.
//  Copyright © 2019 李超群. All rights reserved.
//

#import "GLESView9.h"
#import "GLESUtils.h"
#import "GLESMath.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import <GLKit/GLKit.h>
#import "smoothMonkey.h"
#define PI 3.1415926535898
#define ANGLE_TO_RADIAN(angle) angle * (PI / 180.0f)

typedef struct {
    GLuint position;
    GLuint normal;
    GLuint projectionMat;
    GLuint modelMat;
    GLuint viewMat;
    GLuint inverseTransposeModelMat;
}ShaderV;

typedef struct {
    GLuint light_position;
    GLuint light_diffuseColor;
    GLuint light_ambientColor;
    GLuint light_specularColor;

    GLuint material_diffuseColor;
    GLuint material_ambientColor;
    GLuint material_specularColor;
    GLuint material_smoothness;
    
    GLuint viewPos;
}ShaderF;

@implementation GLESView9{
    CAEAGLLayer *_glLayer;
    EAGLContext *_glContext;
    GLuint _programHandle;
    ShaderV _shaderV;
    ShaderF _shaderF;
    
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
    NSString * vertextShaderPath = [[NSBundle mainBundle] pathForResource:@"VertextShader9" ofType:@"glsl"];
    NSString * fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"FragmentShader9" ofType:@"glsl"];
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
    _shaderV.projectionMat = glGetUniformLocation(_programHandle, "projectionMat");
    _shaderV.modelMat = glGetUniformLocation(_programHandle, "modelMat");
    _shaderV.viewMat = glGetUniformLocation(_programHandle, "viewMat");
    _shaderV.inverseTransposeModelMat = glGetUniformLocation(_programHandle, "inverseTransposeModelMat");

    _shaderF.light_position = glGetUniformLocation(_programHandle, "light.position");
    _shaderF.light_diffuseColor = glGetUniformLocation(_programHandle, "light.diffuse");
    _shaderF.light_ambientColor = glGetUniformLocation(_programHandle, "light.ambient");
    _shaderF.light_specularColor = glGetUniformLocation(_programHandle, "light.specular");
    
    _shaderF.material_diffuseColor = glGetUniformLocation(_programHandle, "material.diffuse");
    _shaderF.material_ambientColor = glGetUniformLocation(_programHandle, "material.ambient");
    _shaderF.material_specularColor = glGetUniformLocation(_programHandle, "material.specular");
    _shaderF.material_smoothness = glGetUniformLocation(_programHandle, "material.shininess");
    _shaderF.viewPos = glGetUniformLocation(_programHandle, "viewPos");
 
    
    glUniform3f(_shaderF.light_position, 1.2, 1.0, 2.0);
    glUniform3f(_shaderF.light_ambientColor, 0.2, 0.2, 0.2);
    glUniform3f(_shaderF.light_diffuseColor, 0.5, 0.5, 0.5);
    glUniform3f(_shaderF.light_specularColor, 1.0, 1.0, 1.0);
    
     // -  材质 金
//     glUniform3f(_shaderF.material_diffuseColor, 0.75164, 0.60648, 0.22648);
//     glUniform3f(_shaderF.material_ambientColor, 0.24725, 0.1995, 0.0745);
//     glUniform3f(_shaderF.material_specularColor, 0.628281, 0.555802, 0.366065);
//     glUniform1f(_shaderF.material_smoothness, 0.4);
    
    // -  材质 玉
    glUniform3f(_shaderF.material_diffuseColor, 0.54, 0.89, 0.63);
    glUniform3f(_shaderF.material_ambientColor, 0.135, 0.2225, 0.1575);
    glUniform3f(_shaderF.material_specularColor, 0.316228, 0.316228, 0.316228);
    glUniform1f(_shaderF.material_smoothness, 0.1);

    glUniform3f(_shaderF.viewPos, 0.0, 0.0, 3.0);
    
    glEnableVertexAttribArray(_shaderV.position);
    glEnableVertexAttribArray(_shaderV.normal);
    
}

-(void)setupTextur{
    CGImageRef imgRef = [UIImage imageNamed:@"jinshu.jpg"].CGImage;
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
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);

    glGenVertexArrays(1, &_VAO);
    glBindVertexArray(_VAO);
    
    GLuint VBO, VBO1;
    glGenBuffers(1, &VBO);
    glGenBuffers(1, &VBO1);
    
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(smoothMonkeyVerts), smoothMonkeyVerts, GL_STATIC_DRAW);
    glVertexAttribPointer(_shaderV.position, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GL_FLOAT), NULL);
    
    glBindBuffer(GL_ARRAY_BUFFER, VBO1);
    glBufferData(GL_ARRAY_BUFFER, sizeof(smoothMonkeyNormals), smoothMonkeyNormals, GL_STATIC_DRAW);
    glVertexAttribPointer(_shaderV.normal, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GL_FLOAT), NULL);
    
    // - 设置显示区域
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    [self updateRender];
}

-(void)updateRender{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    [self setupShaderData];
    glBindVertexArray(_VAO);
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    float aspect = width / height; //长宽比
    
    // - 模型矩阵 (世界空间)
    GLKMatrix4 modelMat = GLKMatrix4MakeRotation(ANGLE_TO_RADIAN(self.rote.roteY), 1.0, 0.0, 0.0);
    modelMat = GLKMatrix4Rotate(modelMat, ANGLE_TO_RADIAN(self.rote.roteX), 0.0, 1.0, 0.0);
    modelMat = GLKMatrix4Scale(modelMat, self.scale, self.scale, self.scale);
    glUniformMatrix4fv(_shaderV.modelMat, 1, GL_FALSE, modelMat.m);
    
    // - 法线矩阵
    GLKMatrix4 inverseTransposeModelMat = GLKMatrix4InvertAndTranspose(modelMat, NULL);
    glUniformMatrix4fv(_shaderV.inverseTransposeModelMat, 1, GL_FALSE, inverseTransposeModelMat.m);
    
    // - 观察矩阵 (观察空间) (观察矩阵, 可以说是相机的位置在变, 也可以是物体的位置在变, 所以以下的两种写法都可以)
//    GLKMatrix4 viewMat = GLKMatrix4Translate(GLKMatrix4Identity,  0.0, 0.0, -5.0); 设置摄像机在 arg0，arg1，arg2 坐标，看向 arg3，arg4，arg5点。(arg7, arg7, arg8)点为摄像机顶部指向的方向
    GLKMatrix4 viewMat = GLKMatrix4MakeLookAt(0, 0, -5, 0, 0, 0, 0, 1, 0);
    glUniformMatrix4fv(_shaderV.viewMat, 1, GL_FALSE, viewMat.m);
    
    
    //投影矩阵 (裁剪空间)
    GLKMatrix4 projectionMat = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45),  aspect, 0.1, 1000.0);
    glUniformMatrix4fv(_shaderV.projectionMat, 1, GL_FALSE, projectionMat.m);

    /* 自己实现矩阵变换
     
        // - 模型矩阵 (世界空间)
        KSMatrix4 modelMat;
        ksMatrixLoadIdentity(&modelMat);
        ksRotate(&modelMat, self.rote.roteY, 1.0, 0.0, 0.0); //绕X轴
        ksRotate(&modelMat, self.rote.roteX, 0.0, 1.0, 0.0); //绕Y轴
        ksScale(&modelMat, self.scale, self.scale, self.scale);
        glUniformMatrix4fv(_shaderV.modelMat, 1, GL_FALSE, (GLfloat*)&modelMat.m[0][0]);

        // - 观察矩阵 (观察空间)
        KSMatrix4 viewMat;
        ksMatrixLoadIdentity(&viewMat);
        ksTranslate(&viewMat, 0.0, 0.0, -5);
        glUniformMatrix4fv(_shaderV.viewMat, 1, GL_FALSE, (GLfloat*)&viewMat.m[0][0]);

        //投影矩阵 (裁剪空间)
        KSMatrix4 projectionMat;
        ksMatrixLoadIdentity(&projectionMat);
        ksPerspective(&projectionMat, 45.0, aspect, 0.1f, 100.0f); //透视变换，视角30°
        glUniformMatrix4fv(_shaderV.projectionMat, 1, GL_FALSE, (GLfloat*)&projectionMat.m[0][0]);
     
     */

    glDrawArrays(GL_TRIANGLES, 0, smoothMonkeyNumVerts);
    [_glContext presentRenderbuffer:GL_RENDERBUFFER];
}

@end
