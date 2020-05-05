//
//  QGFilterInputProtoco.h
//  OpenGL ES Learning
//
//  Created by QG on 2020/5/6.
//  Copyright © 2020 李超群. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QGFilterInputProtocol <NSObject>

/**  记录上一个纹理id */
-(void)lastTextureID:(GLuint)textureId;

@end

NS_ASSUME_NONNULL_END
