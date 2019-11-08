//
//  GLESView4.m
//  OpenGL ES Learning
//
//  Created by 李超群 on 2019/2/9.
//  Copyright © 2019 李超群. All rights reserved.
//

#import "GLESView4.h"
#import "GLESUtils.h"
#import "GLESMath.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import <GLKit/GLKit.h>

#define PI 3.1415926535898
#define ANGLE_TO_RADIAN(angle) angle * (PI / 180.0f)

typedef struct {
    GLuint position;
    GLuint textCoordinate;
    GLuint projectionMat;
    GLuint modelMat;
    GLuint viewMat;
}ShaderV;

@implementation GLESView4{
    CAEAGLLayer *_glLayer;
    EAGLContext *_glContext;
    GLuint _programHandle;
    ShaderV _lint;
    
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
    // - 深度渲染缓冲区对象
    GLuint depthRenderBuffer;
    glGenRenderbuffers(1, &depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderBuffer);
    
    // - 可以创建一个深度和模板渲染缓冲对象
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);

    // - 颜色渲染缓冲区对象
    GLuint colorRenderBuffer;
    glGenRenderbuffers(1, &colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
    [_glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_glLayer];
    
    // - frameBuffer
    // - 来创建一个帧缓冲对象
    GLuint frameBuffer;
    glGenFramebuffers(1, &frameBuffer);
    
    /**
     把它绑定到当前帧缓冲(绑定到GL_FRAMEBUFFER目标后，接下来所有的读、写帧缓冲的操作都会影响到当前绑定的帧缓冲)
     */
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    
    // - 将 renderbuffer 附加到帧缓冲区上
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderBuffer);
    
    // - 将深度 buffer 附加到帧缓冲区上
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderBuffer);
    
    // - 将纹理附加到缓冲区上
//    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,GL_TEXTURE_2D, texture, 0);

    glEnable(GL_DEPTH_TEST);
}

-(void)setupShader{
    NSString * vertextShaderPath = [[NSBundle mainBundle] pathForResource:@"VertextShader4" ofType:@"glsl"];
    NSString * fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"FragmentShader4" ofType:@"glsl"];
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
    _lint.modelMat = glGetUniformLocation(_programHandle, "modelMat");
    _lint.viewMat = glGetUniformLocation(_programHandle, "viewMat");
    
    glEnableVertexAttribArray(_lint.position);
    glEnableVertexAttribArray(_lint.textCoordinate);
}

-(void)setupTextur{
    CGImageRef imgRef = [UIImage imageNamed:@"wall.jpg"].CGImage;
    size_t width = CGImageGetWidth(imgRef);
    size_t height = CGImageGetHeight(imgRef);
    GLubyte *imgData = (GLubyte *)calloc(width * height * 4, sizeof(GLbyte));
    
    CGContextRef contextRef = CGBitmapContextCreate(imgData, width, height, 8, width * 4, CGImageGetColorSpace(imgRef), kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imgRef);
    CGContextRelease(contextRef);
    
    GLuint texture;
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imgData);
    free(imgData);

}

-(void)render{
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);

    float vertices[] = {
         // - 后面
        -0.5f, -0.5f, -0.5f,  0.0f, 0.0f,
        0.5f, -0.5f, -0.5f,  1.0f, 0.0f,
        0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        -0.5f,  0.5f, -0.5f,  0.0f, 1.0f,
        
         // - 前面
        -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
        0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 1.0f,
        -0.5f,  0.5f,  0.5f,  0.0f, 1.0f,
        
         // - 左面
        -0.5f,  0.5f,  0.5f,  1.0f, 1.0f,
        -0.5f,  0.5f, -0.5f,  0.0f, 1.0f,
        -0.5f, -0.5f, -0.5f,  0.0f, 0.0f,
        -0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
        
         // - 右面
        0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
        0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
        
         // - 下面
        -0.5f, -0.5f, -0.5f, 0.0f, 1.0f,
        0.5f, -0.5f, -0.5f,  1.0f, 1.0f,
        0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
        -0.5f, -0.5f,  0.5f, 0.0f, 0.0f,
        
        // - 上面
        -0.5f,  0.5f, -0.5f, 0.0f, 1.0f,
        0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        -0.5f,  0.5f,  0.5f, 0.0f, 0.0f,
    };

    GLuint indices[] = {
        // - 后面
        0, 1, 2,
        2, 3, 0,
        
        // - 前面
        4, 5, 6,
        6, 7, 4,
        
        // - 左面
        8, 9, 10,
        10, 11, 8,
        
        // - 右面
        12, 13, 14,
        14, 15, 12,
        
        // - 下面
        16, 17, 18,
        18, 19, 16,
        
        // - 上面
        20, 21, 22,
        22, 23, 20,
        
    };

    // - VAO (顶点数组对象)
    /**
     VAO的全名是Vertex ArrayObject。它不用作存储数据，但它与顶点绘制相关。
     它的定位是状态对象，记录存储状态信息。VAO记录的是一次绘制中做需要的信息，这包括数据在哪里、数据格式是什么等信息。VAO其实可以看成一个容器，可以包括多个VBO。 由于它进一步将VBO容于其中，所以绘制效率将在VBO的基础上更进一步。目前OpenGL ES3.0及以上才支持顶点数组对象。
     */
    glGenVertexArrays(1, &_VAO);
    glBindVertexArray(_VAO);
    
    // - VBO (顶点缓冲对象)
    /**
    普通的顶点数组的传输，需要在绘制的时候频繁地从CPU到GPU传输顶点数据，这种做法效率低下，为了加快显示速度，显卡增加了一个扩展 VBO (Vertex Buffer object)，即顶点缓存。它直接在 GPU 中开辟一个缓存区域来存储顶点数据，因为它是用来缓存储顶点数据，因此被称之为顶点缓存。使用顶点缓存能够大大较少了CPU到GPU 之间的数据拷贝开销，因此显著地提升了程序运行的效率。
     */
    GLuint VBO;
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    // - EBO (索引缓冲对象)
    GLuint EVO;
    glGenBuffers(1, &EVO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EVO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    // - 链接顶点属性
    glVertexAttribPointer(_lint.position, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(GL_FLOAT), NULL);
    glVertexAttribPointer(_lint.textCoordinate, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(GL_FLOAT), (float *)NULL + 3);
    
    // - 设置显示区域
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    [self updateRender];
}

// - 使用两个 VBO 效果同上 是 render 方法的替换方法
-(void)render1{
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);

    float vertices[] = {
        // - 后面
        -0.5f, -0.5f, -0.5f,
        0.5f, -0.5f, -0.5f,
        0.5f,  0.5f, -0.5f,
        -0.5f,  0.5f, -0.5f,
        
        // - 前面
        -0.5f, -0.5f,  0.5f,
        0.5f, -0.5f,  0.5f,
        0.5f,  0.5f,  0.5f,
        -0.5f,  0.5f,  0.5f,
        
        // - 左面
        -0.5f,  0.5f,  0.5f,
        -0.5f,  0.5f, -0.5f,
        -0.5f, -0.5f, -0.5f,
        -0.5f, -0.5f,  0.5f,
        
        // - 右面
        0.5f,  0.5f,  0.5f,
        0.5f,  0.5f, -0.5f,
        0.5f, -0.5f, -0.5f,
        0.5f, -0.5f,  0.5f,
        
        // - 下面
        -0.5f, -0.5f, -0.5f,
        0.5f, -0.5f, -0.5f,
        0.5f, -0.5f,  0.5f,
        -0.5f, -0.5f,  0.5f,
        
        // - 上面
        -0.5f,  0.5f, -0.5f,
        0.5f,  0.5f, -0.5f,
        0.5f,  0.5f,  0.5f,
        -0.5f,  0.5f,  0.5f,
    };
    
    float vertices1[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        1.0f, 1.0f,
        0.0f, 1.0f,
        0.0f, 0.0f,
        1.0f, 0.0f,
        1.0f, 1.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f, 1.0f,
        0.0f, 0.0f,
        1.0f, 0.0f,
        1.0f, 0.0f,
        1.0f, 1.0f,
        0.0f, 1.0f,
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 0.0f,
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 0.0f,
        0.0f, 0.0f,
    };
    
    
    GLuint indices[] = {
        // - 后面
        0, 1, 2,
        2, 3, 0,
        
        // - 前面
        4, 5, 6,
        6, 7, 4,
        
        // - 左面
        8, 9, 10,
        10, 11, 8,
        
        // - 右面
        12, 13, 14,
        14, 15, 12,
        
        // - 下面
        16, 17, 18,
        18, 19, 16,
        
        // - 上面
        20, 21, 22,
        22, 23, 20,
        
    };
    
    glGenVertexArrays(1, &_VAO);
    glBindVertexArray(_VAO);
    
    GLuint VBO, VBO1;
    glGenBuffers(1, &VBO);
    glGenBuffers(1, &VBO1);
    
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    glVertexAttribPointer(_lint.position, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GL_FLOAT), NULL);
    
    glBindBuffer(GL_ARRAY_BUFFER, VBO1);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices1), vertices1, GL_STATIC_DRAW);
    glVertexAttribPointer(_lint.textCoordinate, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(GL_FLOAT), NULL);
    
    GLuint EBO;
    glGenBuffers(1, &EBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
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
//    KSMatrix4 modelMat;
//    ksMatrixLoadIdentity(&modelMat);
//    ksRotate(&modelMat, self.rote.roteY, 1.0, 0.0, 0.0); //绕X轴
//    ksRotate(&modelMat, self.rote.roteX, 0.0, 1.0, 0.0); //绕Y轴
//    ksScale(&modelMat, self.scale, self.scale, self.scale);
//    glUniformMatrix4fv(_lint.modelMat, 1, GL_FALSE, (GLfloat*)&modelMat.m[0][0]);
//
//    // - 观察矩阵 (观察空间)
//    KSMatrix4 viewMat;
//    ksMatrixLoadIdentity(&viewMat);
//    ksTranslate(&viewMat, 0.0, 0.0, -5);
//    glUniformMatrix4fv(_lint.viewMat, 1, GL_FALSE, (GLfloat*)&viewMat.m[0][0]);
//
//    //投影矩阵 (裁剪空间)
//    KSMatrix4 projectionMat;
//    ksMatrixLoadIdentity(&projectionMat);
//    ksPerspective(&projectionMat, 45.0, aspect, 0.1f, 100.0f); //透视变换，视角30°
//    glUniformMatrix4fv(_lint.projectionMat, 1, GL_FALSE, (GLfloat*)&projectionMat.m[0][0]);
    
    // - 使用系统的库
    // - 模型矩阵 (世界空间)
//    GLKMatrix4 modelMat = GLKMatrix4MakeYRotation(self.rote.roteX * (3.14159 / 180.0f));
    GLKMatrix4 modelMat = GLKMatrix4MakeRotation(ANGLE_TO_RADIAN(self.rote.roteY), 1.0, 0.0, 0.0);
    modelMat = GLKMatrix4Rotate(modelMat, ANGLE_TO_RADIAN(self.rote.roteX), 0.0, 1.0, 0.0);
    glUniformMatrix4fv(_lint.modelMat, 1, GL_FALSE, modelMat.m);

    // - 观察矩阵 (观察空间)
    GLKMatrix4 viewMat = GLKMatrix4MakeTranslation(0.0, 0.0, -5.0);
    glUniformMatrix4fv(_lint.viewMat, 1, GL_FALSE, viewMat.m);

    //投影矩阵 (裁剪空间)
    GLKMatrix4 projectionMat = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45),  aspect, 0.1, 1000.0);
    glUniformMatrix4fv(_lint.projectionMat, 1, GL_FALSE, projectionMat.m);

    
    glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_INT, 0);
    [_glContext presentRenderbuffer:GL_RENDERBUFFER];
}
@end
