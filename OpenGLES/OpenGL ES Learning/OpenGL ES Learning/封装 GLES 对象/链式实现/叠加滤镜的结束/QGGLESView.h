//
//  QGGLESView.h
//  OpenGL ES Learning
//
//  Created by QG on 2020/5/4.
//  Copyright © 2020 李超群. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGFilterInputProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface QGGLESView : UIView <QGFilterInputProtocol>

/** 激活帧缓冲 */
-(void)activityFrameBuffer;

@end

NS_ASSUME_NONNULL_END
