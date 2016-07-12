//
//  lsMediaCapture.h
//  lsMediaCapture
//
//  Created by NetEase on 15/8/12.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "nMediaLiveStreamingDefs.h"


// 直播中的NSNotificationCenter消息广播
#define LS_LiveStreaming_Started             @"LSLiveStreamingStarted"       // 直播推流已经开始
#define LS_LiveStreaming_Finished            @"LSLiveStreamingFinished"     // 直播推流已经结束
#define LS_LiveStreaming_Bad                 @"LSLiveStreamingBad"         // 直播推流状况不好，建议降低分辨率
#define LS_AudioFile_eof                     @"LSAudioFileEof"            //当前audio文件播放结束
#define LS_LiveStreaming_SDK_dealloc         @"LSMediaCaptureSdkDealloc" //当前audio文件播放结束

/**
 *  @brief 获取最新一帧视频截图后的回调
 *
 *  @param latestFrameImage 最新一帧视频截图
 */
typedef void(^LSFrameCaptureCompletionBlock)(UIImage *latestFrameImage);

///直播类LSMediacapture，用于推流
@interface LSMediaCapture : NSObject

/**
 *  直播过程中发生错误的回调函数
 *
 *  @param error 具体错误信息
 */
@property (nonatomic,copy) void (^onLiveStreamError)(NSError *error);
/**
 *  初始化mediacapture
 *
 *  @param  liveStreamingURL 推流的url地址
 *
 *  @return LSMediaCapture
 */
- (instancetype)initLiveStream:(NSString *)liveStreamingURL;
/**
 *  初始化mediacapture
 *
 *  @param  liveStreamingURL 推流的url
 *  @param  videoParaCtx 推流视频参数
 *
 *  @return LSMediaCapture
 */
- (instancetype)initLiveStream:(NSString *)liveStreamingURL withVideoParaCtx:(LSVideoParaCtx)videoParaCtx ;
/**
 *  初始化mediacapture
 *
 *  @param  liveStreamingURL 推流的url
 *  @param  lsParaCtx 推流参数
 *
 *  @return LSMediaCapture
 */
- (instancetype)initLiveStream:(NSString *)liveStreamingURL withLivestreamParaCtx:(LSLiveStreamingParaCtx)lsParaCtx;

/**
 *  打开视频预览
 *
 *  @param  preview 预览窗口
 */
- (void)startVideoPreview:(UIView*)preview;

/**
 *  @warning 暂停视频预览，如果正在直播，则同时关闭视频预览以及视频推流
 *
 */
- (void)pauseVideoPreview;

/**
 *  @warning 继续视频预览，如果正在直播，则开始视频推流
 *
 */
- (void)resumeVideoPreview;

/**
 *
 *  推流地址
 */
@property(nonatomic,copy)NSString* pushUrl;

/**
 *  直播推流之前，可以再次设置一下视频参数
 *  @param  videoResolution 采集分辨率
 *  @param  bitrate 推流码率 default会按照分辨率设置
 *  @param  fps     采集帧率 default ＝ 15
 *
 */
- (void)setVideoParameters:(LSVideoStreamingQuality)videoResolution
                   bitrate:(int)bitrate
                       fps:(int)fps
         cameraOrientation:(LSCameraOrientation) cameraOrientation;

/**
 *  开始直播
 *
 *  @param outError 具体错误信息
 */

- (BOOL)startLiveStreamWithError:(NSError**)outError;

/**
 *  结束推流
 * @warning 只有直播真正开始后，也就是收到LSLiveStreamingStarted消息后，才可以关闭直播,error为nil的时候，说明直播结束，否则直播过程中发生错误，
 */
- (void)stopLiveStream:(void(^)(NSError *))completionBlock;


/**
 *  重启开始视频推流
 *  @warning 需要先启动推流startLiveStreamWithError，开启音视频推流，才可以中断视频推流，重启视频推流，
 */
- (void)resumeVideoLiveStream;

/**
 *  中断视频推流
 *  @warning 需要先启动推流startLiveStreamWithError，开启音视频推流，才可以中断视频推流，重启视频推流，
 */
- (void)pauseVideoLiveStream;


/**
 *  重启音频推流，
 *  @warning：需要先启动推流startLiveStreamWithError，开启音视频推流，才可以中断音频推流，重启音频推流，
 */
- (BOOL)resumeAudioLiveStream;

/**
 *  中断音频推流，
 *  @warning：需要先启动推流startLiveStreamWithError，开启音视频推流，才可以中断音频推流，重启音频推流，
 */
- (BOOL)pauseAudioLiveStream;


/**
 *  切换前后摄像头
 *
 *  @return 当前摄像头的位置，前或者后
 */
- (LSCameraPosition)switchCamera;


//混音相关部分
/**
 *  开始播放混音文件
 *
 *  @param musicURL 音频文件地址/文件名
 *  @param enableLoop 当前音频文件是否单曲循环
 */
- (BOOL)startPlayMusic:(NSString*)musicURL withEnableSignleFileLooped:(BOOL)enableLoop;
/**
 *  结束播放混音文件，释放播放文件
 */
- (BOOL)stopPlayMusic;
/**
 *  继续播放混音文件
 */
- (BOOL)resumePlayMusic;
/**
 *  中断播放混音文件
 */
- (BOOL)pausePlayMusic;
/**
 *  设置混音强度
 *  @param value 混音强度范围【1-10】
 */
- (void)setMixIntensity:(int )value;

//滤镜相关部分
/**
 *  设置滤镜类型
 *
 *  @param filterType 滤镜类型，目前支持7种滤镜，参考 GPUImageFilterType 描述
 *
 */
- (void)setFilterType:(LSGpuImageFilterType)filterType;
/**
 *  设置滤镜强度
 *
 *   @param value 滤镜强度设置
 *
 *    注意： 对于不同滤镜类型，可调节强度不同
 * 只有四种滤镜提供了 强度调节，其他款滤镜只有一种强度值:
 * LS_GPUIMAGE_BEAUTY    [0~1]
 * LS_GPUIMAGE_SEPIA     [0~1]
 * LS_GPUIMAGE_TONECURVE [0~1]
 * LS_GPUIMAGE_CONTRAST  [0~4]
 */
- (void)setFilterIntensity:(float)value;


/**
 *  flash摄像头
 *
 *  @return 打开或者关闭摄像头flash
 */
@property (nonatomic, assign)BOOL flash;

/**
 *  摄像头变焦功能属性：最大拉伸值，系统最大为：videoMaxZoomFactor
 *
 *  @warning iphone4s以及之前的版本，videoMaxZoomFactor＝1；不支持拉伸
 */
@property (nonatomic, assign) CGFloat maxZoomScale;

/**
 *  摄像头变焦功能属性：拉伸值，［1，maxZoomScale］
 *
 *  @warning iphone4s以及之前的版本，videoMaxZoomFactor＝1；不支持拉伸
 */
@property (nonatomic, assign) CGFloat zoomScale;

/**
 *  摄像头变焦功能属性：拉伸值变化回调block
 *
 *  摄像头响应uigesture事件，而改变了拉伸系数反馈
 *  @warning  zoom功能考虑到性能需求，目前仅用于非滤镜模块
 */
@property (nonatomic,copy) void (^onZoomScaleValueChanged)(CGFloat value);


/**
 *  设置水印，
 *  @param  image 水印图片
 *  @param  rect 水印图片位置
 *  @param  rect 水印图片标准位置，左右上下，中心店，当第一种位置模式时，具体位置由rect origin点决定
 *  @return 当前摄像头的位置，前或者后
 */

- (void) addWaterMark: (UIImage*) image
                 rect: (CGRect) rect
             location: (LSWaterMarkLocation) location;

/**
 *  获取视频截图，
 *
 *  @param  LSFrameCaptureCompletionBlock 获取最新一幅视频图像的回调
 *
 */

- (void)snapShotWithCompletionBlock:(LSFrameCaptureCompletionBlock)completionBlock;

/**
 *  得到直播过程中的统计信息
 *
 *  @param statistics 统计信息结构体
 *
 */
@property (nonatomic,copy) void (^onStatisticInfoGot)(LSStatistics* statistics);

/**
 *  设置trace 的level
 *
 *  @param loglevl trace 信息的级别
 */
- (void)setTraceLevel:(LSMediaLog)logLevel;

/**
 *  设置是否输出到文件，
 *
 *  默认存放在／library/cache
 *
 *  @param  isToFile   是否输出到文件，默认是输出到文件，当为false时，则不输出到文件
 */
- (void)isLogToFile:(BOOL)isToFile;

/**
 *  获取当前sdk的版本号
 *
 */
- (NSString*) getSDKVersionID;

@end



