//
//  QGEAGLContext.h
//  OpenGL ES Learning
//
//  Created by QG on 2020/5/4.
//  Copyright © 2020 李超群. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>

@interface QGEAGLContext : NSObject

/** gles 上下文 */
@property(nonatomic, strong, readonly)EAGLContext * glContext;

/** 发送到渲染缓冲区, 开始渲染 */
-(void)present;

@end
