//
//  KSCameraCapture.h
//  Camera
//
//  Created by Mac on 2018/10/15.
//  Copyright © 2018年 kong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@class KSCameraCapture;

@protocol KSCameraCaptureDelegate <NSObject>

@optional


/**
 Capture准备开始拍照

 @param cameraCapture self
 @param error 为nil的时候，正常使用，否则不能使用
 */
- (void)cameraCapture:(KSCameraCapture*)cameraCapture didStartWithError:(NSError*)error;

/**
 点击拍照之后回调

 @param cameraCapture self
 @param image 图片
 */
- (void)cameraCapture:(KSCameraCapture*)cameraCapture didFinishTakePhoto:(UIImage*)image;


@end

@interface KSCameraCapture : NSObject

@property (nonatomic, strong, readonly) AVCaptureSession* session;

@property (nonatomic, strong, readonly) AVCaptureDevice* device;

@property (nonatomic, strong, readonly) AVCaptureStillImageOutput* imageOutput;

@property (nonatomic, strong, readonly) AVCaptureVideoPreviewLayer* previewLayer;

@property (nonatomic, weak) id<KSCameraCaptureDelegate> delegate;

/**
 一切从这里开始
 */
- (void)start;

/**
 聚焦

 @param point 坐标点
 */
- (void)fouceAtPoint:(CGPoint)point;

/**
 点击拍照
 */
- (void)takePhoto;


/**
 到这里结束
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
