//
//  ViewController.m
//  QGTest
//
//  Created by 李超群 on 2019/1/22.
//  Copyright © 2019 李超群. All rights reserved.
//

#import "ViewController.h"
//#import "LYOpenGLView.h"
#import "OpenGLESView.h"
#import <AVFoundation/AVFoundation.h>


@interface ViewController ()
@property (nonatomic,strong)AVPlayer *player;
@property (nonatomic,strong)AVPlayerItemVideoOutput *videoOutput;
@property (nonatomic, strong) LYOpenGLView *playerView;
/** <#注释#> */
@property (nonatomic, strong) UIImageView *imgView;;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self splitVideo:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"rocket" ofType:@"mp4"]] fps:30 completedBlock:nil];
    self.view.backgroundColor = [UIColor blueColor];
    self.playerView = [[LYOpenGLView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.playerView];
    self.playerView.backgroundColor = [UIColor clearColor];
    
    [self.playerView setupGL];
    [self loadAVPlayer];
}



-(void)loadAVPlayer{
//    NSURL *url = [[NSBundle mainBundle]URLForResource:@"rocket" withExtension:@"mp4"];
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"guanjun" withExtension:@"mp4"];
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:url];
    AVPlayer *player = [[AVPlayer alloc]initWithPlayerItem:item];
    _player = player;
    [player play];
    
    
    AVPlayerItemVideoOutput *videoOutput = [[AVPlayerItemVideoOutput alloc]init];
    [item addOutput:videoOutput];
    self.videoOutput = videoOutput;
    //
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkDidrefresh:)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)displayLinkDidrefresh:(CADisplayLink*)link{
    
    CMTime itemTime = _player.currentItem.currentTime;
    CVPixelBufferRef pixelBuffer = [_videoOutput copyPixelBufferForItemTime:itemTime itemTimeForDisplay:nil];

    [self.playerView displayPixelBuffer:pixelBuffer];
    
//    //  可以将buffer转换为UIimage
//        CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
//        CIContext *temporaryContext = [CIContext contextWithOptions:nil];
//        CGImageRef videoImage = [temporaryContext
//                                 createCGImage:ciImage
//                                 fromRect:CGRectMake(0, 0,
//                                                     CVPixelBufferGetWidth(pixelBuffer),
//                                                     CVPixelBufferGetHeight(pixelBuffer))];
//    
//        //当前帧的画面
//        UIImage *currentImage = [UIImage imageWithCGImage:videoImage];
//    
//    self.imgView.image = currentImage;
    
    CVPixelBufferRelease(pixelBuffer);

}


- (UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBufferRef {
    CVImageBufferRef imageBuffer =  pixelBufferRef;
    
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    
    CGImageRef cgImage = CGImageCreate(width, height, 8, 32, bytesPerRow, rgbColorSpace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrderDefault, provider, NULL, true, kCGRenderingIntentDefault);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(rgbColorSpace);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    return image;
}


//- (void)splitVideo:(NSURL *)fileUrl fps:(float)fps completedBlock:(void(^)())completedBlock {
//    if (!fileUrl) {
//        return;
//    }
//    NSDictionary *optDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
//    AVURLAsset *avasset = [[AVURLAsset alloc] initWithURL:fileUrl options:optDict];
//
//    CMTime cmtime = avasset.duration; //视频时间信息结构体
//    Float64 durationSeconds = CMTimeGetSeconds(cmtime); //视频总秒数
//
//    NSMutableArray *times = [NSMutableArray array];
//    Float64 totalFrames = durationSeconds * fps; //获得视频总帧数
//    CMTime timeFrame;
//    for (int i = 1; i <= totalFrames; i++) {
//        timeFrame = CMTimeMake(i, fps); //第i帧  帧率
//        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
//        [times addObject:timeValue];
//    }
//
//    NSLog(@"------- start");
//    AVAssetImageGenerator *imgGenerator = [[AVAssetImageGenerator alloc] initWithAsset:avasset];
//    //防止时间出现偏差
//    imgGenerator.requestedTimeToleranceBefore = kCMTimeZero;
//    imgGenerator.requestedTimeToleranceAfter = kCMTimeZero;
//    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    NSInteger timesCount = [times count];
//    [imgGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
//        printf("current-----: %lld\n", requestedTime.value);
//        switch (result) {
//            case AVAssetImageGeneratorCancelled:
//                NSLog(@"Cancelled");
//                break;
//            case AVAssetImageGeneratorFailed:
//                NSLog(@"Failed");
//                break;
//            case AVAssetImageGeneratorSucceeded: {
//                UIImage *img = [UIImage imageWithCGImage:image];
//                UIImage *left = [ConverImage cropImage:img toRect:CGRectMake(0, 0, img.size.width/2, img.size.height)];
//                UIImage *right = [ConverImage cropImage:img toRect:CGRectMake(img.size.width/2, 0, img.size.width/2, img.size.height)];
//
//
//                [ConverImage changeColorToTransparent:right];
//                if (requestedTime.value == timesCount) {
//                    NSLog(@"completed");
//                    if (completedBlock) {
//                        completedBlock();
//                    }
//                }
//            }
//                break;
//        }
//    }];
//}



@end
