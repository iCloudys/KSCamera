//
//  KSCameraControl.h
//  Camera
//
//  Created by Mac on 2018/10/15.
//  Copyright © 2018年 kong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSCameraDefines.h"

@class KSCameraConfigure;
@class KSCameraControl;
@protocol KSCameraControlDelegate <NSObject>

@optional
- (void)cameraControlDidCancel:(KSCameraControl* )cameraControl;
- (void)cameraControlTakePhoto:(KSCameraControl* )cameraControl;
- (void)cameraControl:(KSCameraControl* )cameraControl focusPoint:(CGPoint)point;

- (void)cameraControl:(KSCameraControl* )cameraControl didChangeLocation:(KSInterfaceLocation)locatoin;

@end
@interface KSCameraControl : UIView

@property (nonatomic, strong) KSCameraConfigure* configure;

@property (nonatomic, assign) KSInterfaceLocation location;

@property (nonatomic, weak) id<KSCameraControlDelegate> delegate;

@end
