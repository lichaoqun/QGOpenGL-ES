//
//  QGInputImage.h
//  OpenGL ES Learning
//
//  Created by 李超群 on 2020/5/7.
//  Copyright © 2020 李超群. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGOutputBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface QGInputImage : QGOutputBase

/** 滤镜数组 */
@property (nonatomic, strong) NSArray <QGOutputBase <QGFilterInputProtocol> *> *filters;

/** 根据imageName 初始化输入源 */
- (instancetype)initWithImageName:(NSString *)imageName;

-(void)startRenderInView:(UIView <QGFilterInputProtocol> *)renderView;

@end


NS_ASSUME_NONNULL_END
