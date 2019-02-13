//
//  PlayerManager.h
//  OpenGL ES Learning
//
//  Created by 李超群 on 2019/2/13.
//  Copyright © 2019 李超群. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLESView6.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerManager : NSObject
@property (nonatomic,strong)AVPlayer *player;
@property (nonatomic,strong)AVPlayerItemVideoOutput *videoOutput;
@property (nonatomic, weak) GLESView6 *playerView;
@end

NS_ASSUME_NONNULL_END
