//
//  ViewController.m
//  KSCameraDemo
//
//  Created by Mac on 2018/10/25.
//  Copyright © 2018年 kong. All rights reserved.
//

#import "ViewController.h"
#import "KSCameraController.h"

#import <Photos/Photos.h>

@interface ViewController ()<
KSCameraControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)takePhotosAction:(UIButton *)sender {
    
    KSCameraConfigure* configure = [[KSCameraConfigure alloc] init];
    configure.tintColor = [UIColor redColor];
    
    KSCameraController* camera = [[KSCameraController alloc] initWithConfigure:configure];
    
    camera.delegate = self;
    [self presentViewController:camera animated:YES completion:NULL];
}

#pragma mark- KSCameraControllerDelegate
- (void)cameraControllerDidCancel:(KSCameraController *)cameraController{
    NSLog(@"cameraController closed");
}

- (void)cameraController:(KSCameraController *)cameraController didFinashPickerImage:(UIImage *)image{
    
    //保存图片
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            } error:NULL];
        }
    }];
    
    [cameraController dismissViewControllerAnimated:YES completion:NULL];
}

@end
