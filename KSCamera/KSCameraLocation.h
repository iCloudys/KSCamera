//
//  KSCameraLocation.h
//  Camera
//
//  Created by Mac on 2018/10/15.
//  Copyright © 2018年 kong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSCameraDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSCameraLocation : CALayer
@property (nonatomic, strong) CALayer* imageLayer;
@property (nonatomic, strong) CATextLayer* textLayer;
@property (nonatomic, assign) KSInterfaceLocation location;

@end

NS_ASSUME_NONNULL_END
