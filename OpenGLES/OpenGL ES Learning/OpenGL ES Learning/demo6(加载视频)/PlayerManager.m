//
//  PlayerManager.m
//  OpenGL ES Learning
//
//  Created by 李超群 on 2019/2/13.
//  Copyright © 2019 李超群. All rights reserved.
//

#import "PlayerManager.h"

@implementation PlayerManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadAVPlayer];
    }
    return self;
}

-(void)loadAVPlayer{
    self.playerView.backgroundColor = [UIColor clearColor];
    
    //    NSURL *url = [[NSBundle mainBundle]URLForResource:@"rocket" withExtension:@"mp4"];
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"guanjun" withExtension:@"mp4"];
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:url];
    AVPlayer *player = [[AVPlayer alloc]initWithPlayerItem:item];
    _player = player;
    [player play];
    
    AVPlayerItemVideoOutput *videoOutput = [[AVPlayerItemVideoOutput alloc]init];
    [item addOutput:videoOutput];
    self.videoOutput = videoOutput;
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkDidrefresh:)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)displayLinkDidrefresh:(CADisplayLink*)link{
    CMTime itemTime = _player.currentItem.currentTime;
    CVPixelBufferRef pixelBuffer = [_videoOutput copyPixelBufferForItemTime:itemTime itemTimeForDisplay:nil];
    [self.playerView displayPixelBuffer:pixelBuffer];
    CVPixelBufferRelease(pixelBuffer);
    
}


@end
