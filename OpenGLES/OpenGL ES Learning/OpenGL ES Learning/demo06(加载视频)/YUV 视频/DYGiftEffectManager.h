//
//  PlayerManager.h
//  OpenGL ES Learning
//
//  Created by 李超群 on 2019/2/13.
//  Copyright © 2019 李超群. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYGLESView.h"
#import <AVFoundation/AVFoundation.h>

@interface DYGiftEffectManager : NSObject

/** 根据父视图初始化 */
- (instancetype)initWithSuperView:(UIView *)supView;

/** 在后边添加播放的视频 */
-(void)pushItem:(AVPlayerItem *)item;

/** 在前边添加播放的视频 */
-(void)insertItem:(AVPlayerItem *)item;

/** 销毁 view */
-(void)deallocEffectView;
@end
