//
//  KSCameraController.h
//  Camera
//
//  Created by Mac on 2018/10/15.
//  Copyright © 2018年 kong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSCameraDefines.h"
#import "KSCameraConfigure.h"

NS_ASSUME_NONNULL_BEGIN

@class KSCameraController;
@protocol KSCameraControllerDelegate <NSObject>

@optional
- (void)cameraController:(KSCameraController*)cameraController didFinashPickerImage:(UIImage*)image;
- (void)cameraControllerDidCancel:(KSCameraController*)cameraController;

@end

@interface KSCameraController : UIViewController

- (instancetype)initWithConfigure:(KSCameraConfigure*)configure NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly ,strong) KSCameraConfigure* configure;

@property (nonatomic, weak) id<KSCameraControllerDelegate> delegate;

@property (nonatomic, assign) KSInterfaceLocation location;

@end

NS_ASSUME_NONNULL_END
