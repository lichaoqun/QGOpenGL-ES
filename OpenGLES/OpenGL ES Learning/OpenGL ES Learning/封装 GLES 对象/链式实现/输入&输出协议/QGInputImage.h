//
//  QGInputImage.h
//  OpenGL ES Learning
//
//  Created by 李超群 on 2020/5/7.
//  Copyright © 2020 李超群. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QGOutputBase.h"
#import "QGFilterInputProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface QGInputImage : QGOutputBase

/** 根据imageName 初始化输入源 */
- (instancetype)initWithImageName:(NSString *)imageName;

-(void)render;
@end


NS_ASSUME_NONNULL_END
