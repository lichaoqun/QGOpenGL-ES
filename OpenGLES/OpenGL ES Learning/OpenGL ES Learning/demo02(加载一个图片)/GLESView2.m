//
//  GLESView2.m
//  OpenGL ES Learning
//
//  Created by 李超群 on 2019/1/26.
//  Copyright © 2019 李超群. All rights reserved.
//

#import "GLESView2.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "GLESUtils.h"
#import "FilterBar.h"

typedef struct {
    GLuint position;
    GLuint textCoor;
    GLuint sample1;
    GLuint sample2;
    float timestamp;
}CustomLint;

typedef struct {
    float position0[3];
    float position1[2];
}CustomVertex;

@interface GLESView2 () <FilterBarDelegate>
@property (nonatomic, weak) FilterBar *filerBar;
@property(nonatomic, strong)FilterModel *model;
/** frameBuffer 的尺寸 */
@property (nonatomic, assign) CGSize frameBufferSize;
@property(nonatomic, strong)NSArray *watermarks;
@property(nonatomic, weak)FilterModel *lastFilterModel;

@end

int count_;
float timestamp_;
@implementation GLESView2{
    CAEAGLLayer *_glLayer;
    EAGLContext *_glContext;
    
    GLuint _colorRenderBuffer;
    GLuint _frameBuffer;
    GLint _programHandle;
    
    CustomLint _lint;
    GLuint *_texture;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setuplayer];
        [self setupContext];
        [self destoryRenderAndFrameBuffer];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self initFliterBar];
    }
    return self;
}

-(void)initFliterBar{
    count_ = 2;
    _texture = malloc(sizeof(GLuint) * count_);
    [self setupTexture];
    [self setupFilterBar];
}

+(Class)layerClass{
    return [CAEAGLLayer class];
}

- (void)setuplayer{
    _glLayer =  (CAEAGLLayer *)self.layer;
    _glLayer.opaque = YES;
    [_glLayer setDrawableProperties:@{
                                      kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8,
                                      kEAGLDrawablePropertyRetainedBacking : @(NO)
                                      }];
}

-(void)setupContext{
    _glContext = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_glContext];
}

-(void)setupRenderBuffer{
    // - 当绘制的图片需要展示在layer 上时候, 则调用 layer 的 renderbufferStorage 方法
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_glLayer];
}

-(void)setupFrameBuffer{
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
}

- (void)setupTexture{

    CGImageRef imgRef = [UIImage imageNamed:@"gyy.jpg"].CGImage;
    size_t width = CGImageGetWidth(imgRef);
    size_t height = CGImageGetHeight(imgRef);
    GLubyte *imgData = (GLubyte *)calloc(width * height * 4, sizeof(GLbyte));
    self.frameBufferSize = CGSizeMake(width, height);

    CGContextRef contextRef = CGBitmapContextCreate(imgData, width, height, 8, width * 4, CGImageGetColorSpace(imgRef), kCGImageAlphaPremultipliedLast);
    
    // - 翻转纹理坐标
    CGRect rect = CGRectMake(0, 0, width, height);
    CGContextTranslateCTM(contextRef, 0, rect.size.height);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    
    // - 绘制图片
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imgRef);
    CGContextRelease(contextRef);
    
    int index = 0;
    GLuint *textures = (GLuint *)((GLuint *)_texture + index);
    glGenTextures(1, textures);
    glBindTexture(GL_TEXTURE_2D, (GLuint)(*textures));
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    // - 生成一个纹理对象
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imgData);
    free(imgData);
}


-(void)destoryRenderAndFrameBuffer{
    glDeleteBuffers(1, &_frameBuffer);
    _frameBuffer = 0;
    
    glDeleteBuffers(1, &_colorRenderBuffer);
    _colorRenderBuffer = 0;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.filerBar.hidden = !self.filerBar.hidden;
}

// - MARK: <-- 普通特效 -->
-(void)setupProgramHandle{
    
    NSString * vertextShaderPath = [[NSBundle mainBundle] pathForResource:@"VertextShader2" ofType:@"glsl"];
    NSString * fragmentShaderPath = [[NSBundle mainBundle] pathForResource:self.model.filterShader ofType:@"glsl"];
    
    GLuint vertextShader = [GLESUtils loadShader:GL_VERTEX_SHADER withFilepath:vertextShaderPath];
    GLuint framegmentShader = [GLESUtils loadShader:GL_FRAGMENT_SHADER withFilepath:fragmentShaderPath];
    
    _programHandle = glCreateProgram();
    glAttachShader(_programHandle, vertextShader);
    glAttachShader(_programHandle, framegmentShader);
    glLinkProgram(_programHandle);
    glUseProgram(_programHandle);
    
    // - 这里是 获取顶点着色器的属性索引, 然后使用 也可以直接绑定顶点着色器属性索引到某个数字上 如下:
    _lint.position = glGetAttribLocation(_programHandle, "position");
    _lint.textCoor = glGetAttribLocation(_programHandle, "textCoordinate");
    
    // - 直接绑定的写法
//    _lint.position = 10;
//    _lint.position = 11;
//    glBindAttribLocation(_programHandle, 10, "position");
//    glBindAttribLocation(_programHandle, 10, "textCoordinate");

    glEnableVertexAttribArray(_lint.position);
    glEnableVertexAttribArray(_lint.textCoor);
}

-(void)render{
    glClearColor(0, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    CustomVertex lint1 = {.position0 = {1,  1, 0}, .position1 = {1.0, 1.0}};
    CustomVertex lint2 = {.position0 = {1,  -1, 0}, .position1 = {1.0, 0.0}};
    CustomVertex lint3 = {.position0 = {-1,  1, 0}, .position1 = {0.0, 1.0}};

    CustomVertex lint4 = {.position0 = {1,  -1, 0}, .position1 = {1.0, 0.0}};
    CustomVertex lint5 = {.position0 = {-1,  -1, 0}, .position1 = {0.0, 0.0}};
    CustomVertex lint6 = {.position0 = {-1,  1, 0}, .position1 = {0.0, 1.0}};
    CustomVertex vertices[] ={lint1, lint2, lint3, lint4, lint5, lint6};

    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    glViewport(0, 0, self.frame.size.width, self.frame.size.height);

    glVertexAttribPointer(_lint.position, 3, GL_FLOAT, GL_FALSE,  sizeof(GLfloat) * 5, NULL);
    glVertexAttribPointer(_lint.textCoor, 2, GL_FLOAT, GL_FALSE,  sizeof(GLfloat) * 5, (float *)NULL + 3);
    glDrawArrays(GL_TRIANGLES, 0, 6);
    [_glContext presentRenderbuffer:GL_RENDERBUFFER];
    
    // - 从当前的 framebuffer 中取到 image
    [self newCGImageFromFramebufferContents];
}

// - MARK: <-- 滤镜特效 -->
- (void)setupTexture1WithName:(NSString *)filterImageName{

    CGImageRef imgRef = [UIImage imageNamed:filterImageName].CGImage;
    size_t width = CGImageGetWidth(imgRef);
    size_t height = CGImageGetHeight(imgRef);
    GLubyte *imgData = (GLubyte *)calloc(width * height * 4, sizeof(GLbyte));
    self.frameBufferSize = CGSizeMake(width, height);

    CGContextRef contextRef = CGBitmapContextCreate(imgData, width, height, 8, width * 4, CGImageGetColorSpace(imgRef), kCGImageAlphaPremultipliedLast);
    
    // - 翻转纹理坐标
    CGRect rect = CGRectMake(0, 0, width, height);
    CGContextTranslateCTM(contextRef, 0, rect.size.height);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    
    // - 绘制图片
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imgRef);
    CGContextRelease(contextRef);
    int index = 1;
    GLuint *textures = (GLuint *)((GLuint *)_texture + index);
    glGenTextures(1, textures);
    glBindTexture(GL_TEXTURE_2D, (GLuint)(*textures));
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    // - 生成一个纹理对象
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imgData);
    free(imgData);
}

-(void)setupProgramHandle1{
    
    NSString * vertextShaderPath = [[NSBundle mainBundle] pathForResource:@"VertextShader2" ofType:@"glsl"];
    NSString * fragmentShaderPath = [[NSBundle mainBundle] pathForResource:self.model.filterShader ofType:@"glsl"];
    
    GLuint vertextShader = [GLESUtils loadShader:GL_VERTEX_SHADER withFilepath:vertextShaderPath];
    GLuint framegmentShader = [GLESUtils loadShader:GL_FRAGMENT_SHADER withFilepath:fragmentShaderPath];
    
    _programHandle = glCreateProgram();
    glAttachShader(_programHandle, vertextShader);
    glAttachShader(_programHandle, framegmentShader);
    glLinkProgram(_programHandle);
    glUseProgram(_programHandle);
    
    // - 这里是 获取顶点着色器的属性索引, 然后使用 也可以直接绑定顶点着色器属性索引到某个数字上 如下:
    _lint.position = glGetAttribLocation(_programHandle, "position");
    _lint.textCoor = glGetAttribLocation(_programHandle, "textCoordinate");
    _lint.sample1 = glGetUniformLocation(_programHandle, "colorMap1");
    _lint.sample2 = glGetUniformLocation(_programHandle, "colorMap2");
    
    // - 直接绑定的写法
//    _lint.position = 10;
//    _lint.position = 11;
//    glBindAttribLocation(_programHandle, 10, "position");
//    glBindAttribLocation(_programHandle, 10, "textCoordinate");
    
    glUniform1i(_lint.sample1, 0);
    glUniform1i(_lint.sample2, 1);
    glEnableVertexAttribArray(_lint.position);
    glEnableVertexAttribArray(_lint.textCoor);
}

-(void)render1{
    glClearColor(0, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    CustomVertex lint1 = {.position0 = {1,  1, 0}, .position1 = {1.0, 1.0}};
    CustomVertex lint2 = {.position0 = {1,  -1, 0}, .position1 = {1.0, 0.0}};
    CustomVertex lint3 = {.position0 = {-1,  1, 0}, .position1 = {0.0, 1.0}};

    CustomVertex lint4 = {.position0 = {1,  -1, 0}, .position1 = {1.0, 0.0}};
    CustomVertex lint5 = {.position0 = {-1,  -1, 0}, .position1 = {0.0, 0.0}};
    CustomVertex lint6 = {.position0 = {-1,  1, 0}, .position1 = {0.0, 1.0}};
    CustomVertex vertices[] ={lint1, lint2, lint3, lint4, lint5, lint6};
    
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    glViewport(0, 0, self.frame.size.width, self.frame.size.height);

    glVertexAttribPointer(_lint.position, 3, GL_FLOAT, GL_FALSE,  sizeof(GLfloat) * 5, NULL);
    glVertexAttribPointer(_lint.textCoor, 2, GL_FLOAT, GL_FALSE,  sizeof(GLfloat) * 5, (float *)NULL + 3);
    for (int i = 0 ; i < count_; i++) {
        glActiveTexture(GL_TEXTURE0 + i);
        glBindTexture(GL_TEXTURE_2D, _texture[i]);
    }
    glDrawArrays(GL_TRIANGLES, 0, 6);
    [_glContext presentRenderbuffer:GL_RENDERBUFFER];
    
    // - 从当前的 framebuffer 中取到 image
    [self newCGImageFromFramebufferContents];
}

-(void)setupProgramHandle2{
    NSString * vertextShaderPath = [[NSBundle mainBundle] pathForResource:@"VertextShader2" ofType:@"glsl"];
    NSString * fragmentShaderPath = [[NSBundle mainBundle] pathForResource:self.model.filterShader ofType:@"glsl"];
    
    GLuint vertextShader = [GLESUtils loadShader:GL_VERTEX_SHADER withFilepath:vertextShaderPath];
    GLuint framegmentShader = [GLESUtils loadShader:GL_FRAGMENT_SHADER withFilepath:fragmentShaderPath];
    
    _programHandle = glCreateProgram();
    glAttachShader(_programHandle, vertextShader);
    glAttachShader(_programHandle, framegmentShader);
    glLinkProgram(_programHandle);
    glUseProgram(_programHandle);
    
    // - 这里是 获取顶点着色器的属性索引, 然后使用 也可以直接绑定顶点着色器属性索引到某个数字上 如下:
    _lint.position = glGetAttribLocation(_programHandle, "position");
    _lint.textCoor = glGetAttribLocation(_programHandle, "textCoordinate");
    _lint.sample1 = glGetUniformLocation(_programHandle, "colorMap1");
    _lint.sample2 = glGetUniformLocation(_programHandle, "colorMap2");
    _lint.timestamp = glGetUniformLocation(_programHandle, "timestamp");
    
    // - 直接绑定的写法
//    _lint.position = 10;
//    _lint.position = 11;
//    glBindAttribLocation(_programHandle, 10, "position");
//    glBindAttribLocation(_programHandle, 10, "textCoordinate");
    
    glUniform1i(_lint.sample1, 0);
    glUniform1i(_lint.sample2, 1);
    glEnableVertexAttribArray(_lint.position);
    glEnableVertexAttribArray(_lint.textCoor);
    glEnableVertexAttribArray(_lint.timestamp);
}



-(void)render2{
    glEnable(GL_BLEND);
    glClearColor(1, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    CustomVertex lint1 = {.position0 = {1,  1, 0}, .position1 = {1.0, 1.0}};
    CustomVertex lint2 = {.position0 = {1,  -1, 0}, .position1 = {1.0, 0.0}};
    CustomVertex lint3 = {.position0 = {-1,  1, 0}, .position1 = {0.0, 1.0}};

    CustomVertex lint4 = {.position0 = {1,  -1, 0}, .position1 = {1.0, 0.0}};
    CustomVertex lint5 = {.position0 = {-1,  -1, 0}, .position1 = {0.0, 0.0}};
    CustomVertex lint6 = {.position0 = {-1,  1, 0}, .position1 = {0.0, 1.0}};
    CustomVertex vertices[] ={lint1, lint2, lint3, lint4, lint5, lint6};

    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    glViewport(0, 0, self.frame.size.width, self.frame.size.height);

    glVertexAttribPointer(_lint.position, 3, GL_FLOAT, GL_FALSE,  sizeof(GLfloat) * 5, NULL);
    glVertexAttribPointer(_lint.textCoor, 2, GL_FLOAT, GL_FALSE,  sizeof(GLfloat) * 5, (float *)NULL + 3);
    glUniform1f(_lint.timestamp, timestamp_);
    for (int i = 0 ; i < count_; i++) {
        glActiveTexture(GL_TEXTURE0 + i);
        glBindTexture(GL_TEXTURE_2D, _texture[i]);
    }
    glDrawArrays(GL_TRIANGLES, 0, 6);
    [_glContext presentRenderbuffer:GL_RENDERBUFFER];
    
    // - 从当前的 framebuffer 中取到 image
    [self newCGImageFromFramebufferContents];
}

// - MARK: <-- 设置工具条 -->
-(void)setupFilterBar{
    CGFloat filterBarWidth = self.bounds.size.width;
    CGFloat filterBarHeight = 60;
    CGFloat filterBarY = self.bounds.size.height - filterBarHeight;
    FilterBar *filerBar = [[FilterBar alloc] initWithFrame:CGRectMake(0, filterBarY - 80, filterBarWidth, filterBarHeight)];
    filerBar.delegate = self;
    [self addSubview:filerBar];
    self.filerBar = filerBar;
    
    NSArray <FilterModel *> *arrayList = [FilterModel filterModels];
    filerBar.itemList = arrayList;
    [self filterBar:filerBar didSelectModel:[arrayList firstObject] indexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
}

- (void)filterBar:(FilterBar *)filterBar didSelectModel:(FilterModel *)model indexPath:(NSIndexPath *)indexPath{
    [self.lastFilterModel stopLastFilter];
    self.model = model;
    if ([model isKindOfClass:[FilterNormalModel class]]) {
        [self setupProgramHandle];
        [self render];
    }else if([model isKindOfClass:[FilterImageModel class]]){
        [self setupTexture1WithName:((FilterImageModel *)model).filterImageName];
        [self setupProgramHandle1];
        [self render1];
    }else if ([model isKindOfClass:[FilterAnimationModel class]]){
        [((FilterAnimationModel *)model) callbackImageName:^(NSString *imgName) {
            timestamp_ = timestamp_ + 5.0;
            [self setupTexture1WithName:imgName];
            [self setupProgramHandle2];
            [self render2];
        }];
    }
    self.lastFilterModel = model;
}

// - MARK: <-- 从GPU中读取纹理数据到内存中 -->
/** 从当前的 framebuffer 中取到 image */
- (CGImageRef)newCGImageFromFramebufferContents{
    CGImageRef cgImageFromBytes;
    NSUInteger totalBytesForImage = (int)self.frameBufferSize.width * (int)self.frameBufferSize.height * 4;
    GLubyte *rawImagePixels;
    CGDataProviderRef dataProvider = NULL;
    rawImagePixels = (GLubyte *)malloc(totalBytesForImage);

    // - glReadPixels：读取一些像素。当前可以简单理解为“把已经绘制好的像素（它可能已经被保存到显卡的显存中）读取到内存”。
    glReadPixels(0, 0, (int)self.frameBufferSize.width, (int)self.frameBufferSize.height, GL_RGBA, GL_UNSIGNED_BYTE, rawImagePixels);
    dataProvider = CGDataProviderCreateWithData(NULL, rawImagePixels, totalBytesForImage, dataProviderReleaseCallback);
    CGColorSpaceRef defaultRGBColorSpace = CGColorSpaceCreateDeviceRGB();
    
    cgImageFromBytes = CGImageCreate((int)self.frameBufferSize.width, (int)self.frameBufferSize.height, 8, 32, 4 * (int)self.frameBufferSize.width, defaultRGBColorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaLast, dataProvider, NULL, NO, kCGRenderingIntentDefault);
    
    // Capture image with current device orientation
    CGDataProviderRelease(dataProvider);
    CGColorSpaceRelease(defaultRGBColorSpace);
    
    return cgImageFromBytes;
}


void dataProviderReleaseCallback (void *info, const void *data, size_t size)
{
    free((void *)data);
}

- (BOOL)supportsFastTextureUpload;
{
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wtautological-pointer-compare"
    return (CVOpenGLESTextureCacheCreate != NULL);
#pragma clang diagnostic pop

#endif
}

@end
