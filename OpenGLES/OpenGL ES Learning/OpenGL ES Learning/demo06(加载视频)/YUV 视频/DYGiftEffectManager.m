//
//  PlayerManager.m
//  OpenGL ES Learning
//
//  Created by 李超群 on 2019/2/13.
//  Copyright © 2019 李超群. All rights reserved.
//

#import "DYGiftEffectManager.h"

@interface DYGiftEffectManager ()

// - 播放器
@property (nonatomic,strong)AVPlayer *player;
@property (nonatomic,strong)AVPlayerItemVideoOutput *videoOutput;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) AVPlayerItem *currentPlayItem;


// - 放视频 item 的数组
@property (nonatomic, strong) NSMutableArray *playItemsArray;

// - 渲染视频的 view
@property (nonatomic, weak) DYGLESView *glView;

/** 渲染视频的 view 的父视图 */
@property (nonatomic, weak) UIView *supView;

@end

@implementation DYGiftEffectManager

/** 初始化方法 */
- (instancetype)initWithSuperView:(UIView *)supView{
    self = [super init];
    if (self) {
         self.supView = supView;
    }
    return self;
}

#pragma mark -/** *** 懒加载 *** */
// - 渲染视频的 view
-(DYGLESView *)glView{
    if(!_glView){
        DYGLESView *glView = [[DYGLESView alloc] initWithFrame:CGRectMake(0, 0, self.supView.frame.size.width, self.supView.frame.size.height)];
        [self.supView addSubview:glView];
        glView.backgroundColor = [UIColor clearColor];
        _glView = glView;
    }
    return _glView;
}

-(AVPlayer *)player{
    if (!self.currentPlayItem)  return nil;
    if (!_player) {
        _player = [[AVPlayer alloc]initWithPlayerItem:self.currentPlayItem];
    }else{
        [_player replaceCurrentItemWithPlayerItem:self.currentPlayItem];
    }
    return _player;
}

/** 播放的 AVPlayerItem */
-(void)setCurrentPlayItem:(AVPlayerItem *)currentPlayItem{
    if (_currentPlayItem != currentPlayItem) {
        [currentPlayItem removeOutput:self.videoOutput];
        self.videoOutput = nil;
    }
    _currentPlayItem = currentPlayItem;
    if (currentPlayItem) {
        self.videoOutput = [[AVPlayerItemVideoOutput alloc]init];
        [currentPlayItem addOutput:self.videoOutput];
    }
}

/** 计时器 */
- (CADisplayLink *)displayLink{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkDidrefresh:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _displayLink;
}

-(void)stopDisplayLink{
    [self.displayLink setPaused:YES];
}

-(void)startDisplayLink{
    [self.displayLink setPaused:NO];
}

-(void)destoryDisplayLink{
    [_displayLink invalidate];
    _displayLink = nil;
}

// - 放视频 item 的数组
-(NSMutableArray *)playItemsArray{
    if(!_playItemsArray){
        _playItemsArray = [[NSMutableArray alloc] init];
    }
    return _playItemsArray;
}

#pragma mark -/** *** 计时器事件 *** */
-(void)displayLinkDidrefresh:(CADisplayLink*)link{
    CMTime itemTime = _player.currentItem.currentTime;
    CVPixelBufferRef pixelBuffer = [self.videoOutput copyPixelBufferForItemTime:itemTime itemTimeForDisplay:nil];
    [self.glView displayPixelBuffer:pixelBuffer];
    CVPixelBufferRelease(pixelBuffer);

    Float64 duration = -1;
    if (self.player.currentItem.status == AVPlayerStatusReadyToPlay) {
        duration = CMTimeGetSeconds(_player.currentItem.duration);
    }
    if (CMTimeGetSeconds(itemTime) == duration) {
        AVPlayerItem *item = [self popTopItem];
        [self playItem:item];
        return;
    }
}

#pragma mark -/** *** 如队列和出队列视频数据 *** */
/** 出队列 */
-(AVPlayerItem *)popTopItem{
    if (self.playItemsArray.count == 0){
        self.currentPlayItem = nil;
        return nil;
    }
    self.currentPlayItem = [self.playItemsArray firstObject];
    [self.playItemsArray removeObjectAtIndex:0];
    return self.currentPlayItem;
}

/** 在后边添加播放的视频 */
-(void)pushItem:(AVPlayerItem *)item{
    [self.playItemsArray addObject:item];
    if (!self.currentPlayItem) {
        [self playItem:[self popTopItem]];
    }
}

/** 在前边添加播放的视频 */
-(void)insertItem:(AVPlayerItem *)item{
    [self.playItemsArray insertObject:item atIndex:0];
    if (!self.currentPlayItem) {
        [self playItem:[self popTopItem]];
    }
}

#pragma mark -/** *** 播放视频 *** */
-(void)playItem:(AVPlayerItem *)item{
    if (!item) {
        self.glView.hidden = YES;
        [self stopDisplayLink];
        return;
    }
    
    self.glView.hidden = NO;
    [self startDisplayLink];
    [self.player play];
}

/** 销毁 view */
-(void)deallocEffectView{
    [self destoryDisplayLink];
}
@end
