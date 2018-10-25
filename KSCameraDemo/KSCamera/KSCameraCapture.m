//
//  KSCameraCapture.m
//  Camera
//
//  Created by Mac on 2018/10/15.
//  Copyright © 2018年 kong. All rights reserved.
//

#import "KSCameraCapture.h"

@interface KSCameraCapture ()
{
    struct {
        unsigned cameraCaptureDidFinishTakePhoto : 1;
        unsigned cameraCaptureDidStartWithError : 1;
    } _delegateHas;
}

@property (nonatomic, strong) AVCaptureSession* session;

@property (nonatomic, strong) AVCaptureDevice* device;

@property (nonatomic, strong) AVCaptureStillImageOutput* imageOutput;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;

@end

@implementation KSCameraCapture

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.previewLayer = [AVCaptureVideoPreviewLayer layer];
    }
    return self;
}

- (void)start{
    
//    dispatch_async(dispatch_get_main_queue(), ^{
    
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if (status == AVAuthorizationStatusAuthorized) {
            [self setupSession];
        }else if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted){
            NSError* error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:-1
                                             userInfo:@{NSLocalizedDescriptionKey:@"没有相机权限"}];
            [self didStartCallback:error];
        }else{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                     completionHandler:^(BOOL granted) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [self start];
                                         });
                                     }];
        }
//    });
}

- (void)stop{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.session stopRunning];
    });
}

- (void)setDelegate:(id<KSCameraCaptureDelegate>)delegate{
    _delegate = delegate;
    _delegateHas.cameraCaptureDidFinishTakePhoto = [delegate respondsToSelector:@selector(cameraCapture:didFinishTakePhoto:)];
    _delegateHas.cameraCaptureDidStartWithError = [delegate respondsToSelector:@selector(cameraCapture:didStartWithError:)];
}


- (void)setupSession{
    
    NSError* error = nil;
    
    self.device = [self findCaptureDevice:AVCaptureDevicePositionBack];
    
    AVCaptureDeviceInput* deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    self.session = [[AVCaptureSession alloc] init];
    
    [self.session beginConfiguration];
    
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    }
    
    if ([self.session canAddInput:deviceInput]) {
        [self.session addInput:deviceInput];
    }
    
    if ([self.session canAddOutput:self.imageOutput]) {
        [self.session addOutput:self.imageOutput];
    }
    
    [self.session commitConfiguration];
    
    [self.previewLayer setSession:self.session];
    
    [self.session startRunning];
    
    [self didStartCallback:error];
}

- (AVCaptureDevice*)findCaptureDevice:(AVCaptureDevicePosition)position{
    
    AVCaptureDevice* device = nil;
    
    if (@available(iOS 10.0, *)) {
        device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera
                                                    mediaType:AVMediaTypeVideo
                                                     position:position];
    }
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (!device) {
        NSLog(@"获取后置摄像头失败");
    }
    
    return device;
}

- (void)captureImageComplete:(CMSampleBufferRef)imageDataSampleBuffer{
    if (_delegateHas.cameraCaptureDidFinishTakePhoto) {
        NSData* data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage* img = [UIImage imageWithData:data];
        [_delegate cameraCapture:self didFinishTakePhoto:img];
    }
}


- (void)fouceAtPoint:(CGPoint)point{
    [self.device lockForConfiguration:nil];
    if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        self.device.focusPointOfInterest = CGPointMake(point.y / CGRectGetHeight(self.previewLayer.bounds),
                                                       point.x / CGRectGetWidth(self.previewLayer.bounds));
        [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
    }
    [self.device unlockForConfiguration];
}

- (void)takePhoto{
    
    self.previewLayer.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.previewLayer.hidden = NO;
    });
    
    AVCaptureConnection* connection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:connection
                                                  completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
                                                      [self captureImageComplete:imageDataSampleBuffer];
                                                  }];
}

- (void)didStartCallback:(NSError*)error{
    if (_delegateHas.cameraCaptureDidStartWithError) {
        [_delegate cameraCapture:self didStartWithError:error];
    }
}


@end
