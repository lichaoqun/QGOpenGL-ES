//
//  QGGrayscaleFilter.h
//  OpenGL ES Learning
//
//  Created by QG on 2020/5/6.
//  Copyright © 2020 李超群. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QGOutputBase.h"
#import "QGFilterInputProtocol.h"
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface QGGrayscaleFilter : QGOutputBase <QGFilterInputProtocol>
- (instancetype)initWithSize:(CGSize)renderSize;
- (instancetype)initWithSize:(CGSize)renderSize filterName:(NSString *)filterName;
@end

NS_ASSUME_NONNULL_END
