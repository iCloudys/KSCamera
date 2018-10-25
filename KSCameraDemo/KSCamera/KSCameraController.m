//
//  KSCameraController.m
//  Camera
//
//  Created by Mac on 2018/10/15.
//  Copyright © 2018年 kong. All rights reserved.
//

#import "KSCameraController.h"
#import "KSCameraCapture.h"
#import "KSCameraControl.h"
#import "KSCameraLocation.h"

@interface KSCameraController ()
<
KSCameraControlDelegate,
KSCameraCaptureDelegate>
{
    struct {
        unsigned cameraControllerDidFinashPickerImage : 1;
        unsigned cameraControllerDidCancel : 1;
    }_delegateHas;
}

@property (nonatomic, strong) KSCameraControl* control;

@property (nonatomic, strong) KSCameraCapture* capture;

@property (nonatomic, strong) KSCameraLocation* locationView;

@end

@implementation KSCameraController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.capture = [[KSCameraCapture alloc] init];
    self.capture.delegate = self;
    [self.capture start];
    [self.view.layer addSublayer:self.capture.previewLayer];
    
    self.control = [[KSCameraControl alloc] init];
    self.control.delegate = self;
    self.control.location = self.location;
    [self.view addSubview:self.control];
    
    self.locationView = [[KSCameraLocation alloc] init];
    self.locationView.location = self.location;
    [self.view.layer addSublayer:self.locationView];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.locationView.frame = self.view.bounds;
    self.control.frame = self.view.bounds;
    self.capture.previewLayer.frame = self.view.bounds;
    [self.view bringSubviewToFront:self.control];
}

- (void)setDelegate:(id<KSCameraControllerDelegate>)delegate{
    _delegate = delegate;
    _delegateHas.cameraControllerDidFinashPickerImage = [delegate respondsToSelector:@selector(cameraController:didFinashPickerImage:)];
    _delegateHas.cameraControllerDidCancel = [delegate respondsToSelector:@selector(cameraControllerDidCancel:)];
}

#pragma mark- KSCameraCaptureDelegate
- (void)cameraCapture:(KSCameraCapture*)cameraCapture didStartWithError:(NSError*)error{
    if (error && error.code == -1) {
        UIAlertController* al = [UIAlertController alertControllerWithTitle:@"请打开相机权限"
                                                                    message:@"设置-隐私-相机"
                                                             preferredStyle:UIAlertControllerStyleAlert];
        [al addAction:[UIAlertAction actionWithTitle:@"确定"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action) {
                                                 [self cameraControlDidCancel:nil];
                                             }]];
        [self presentViewController:al animated:YES completion:NULL];
    }
}

- (void)cameraCapture:(KSCameraCapture *)cameraCapture didFinishTakePhoto:(UIImage *)image{
    if (_delegateHas.cameraControllerDidFinashPickerImage) {
        [_delegate cameraController:self didFinashPickerImage:image];
    }
}

#pragma mark- KSCameraControlDelegate
- (void)cameraControlDidCancel:(KSCameraControl *)cameraControl{
    
    [self.capture stop];
    
    if (_delegateHas.cameraControllerDidCancel) {
        [_delegate cameraControllerDidCancel:self];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)cameraControlTakePhoto:(KSCameraControl *)cameraControl{
    [self.capture takePhoto];
}

- (void)cameraControl:(KSCameraControl *)cameraControl focusPoint:(CGPoint)point{
    [self.capture fouceAtPoint:point];
}

- (void)cameraControl:(KSCameraControl *)cameraControl didChangeLocation:(KSInterfaceLocation)locatoin{
    self.locationView.location = locatoin;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
