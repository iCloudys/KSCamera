//
//  KSCameraLocation.m
//  Camera
//
//  Created by Mac on 2018/10/15.
//  Copyright © 2018年 kong. All rights reserved.
//

#import "KSCameraLocation.h"

@implementation KSCameraLocation

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageLayer = [CALayer layer];
        [self addSublayer:self.imageLayer];
        
        self.textLayer = [CATextLayer layer];
        self.textLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
        self.textLayer.cornerRadius = 8;
        self.textLayer.contentsScale = [UIScreen mainScreen].scale;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.textLayer.fontSize = 24;
        }else{
            self.textLayer.fontSize = 17;
        }
        self.textLayer.alignmentMode = kCAAlignmentCenter;
        [self addSublayer:self.textLayer];
    }
    return self;
}

- (void)setLocation:(KSInterfaceLocation)location{
    _location = location;

    switch (location) {
        case KSInterfaceTongue:
        {
            self.imageLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"KSCameraBundle.bundle/location"].CGImage);
            self.textLayer.string = @"正对镜头，舌头下伸";
        }
            break;
        case KSInterfaceFace:
        {
            self.imageLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"KSCameraBundle.bundle/face"].CGImage);
            self.textLayer.string = @"正对镜头，挺胸抬头";
        }
            break;
        case KSInterfaceHand:
        {
            self.imageLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"KSCameraBundle.bundle/hand"].CGImage);
            self.textLayer.string = @"伸出左手，五指张开";
        }
            break;
    }
    
    [self setNeedsLayout];
}

- (void)layoutSublayers{
    [super layoutSublayers];
    CGFloat scale = 1;
    
    switch (self.location) {
        case KSInterfaceTongue:
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                scale = 0.54;
            }else{
                scale = 0.64;
            }
        }
            break;
        default:
            break;
    }
   
    CGFloat w = CGRectGetWidth(self.bounds) * scale;

    CGSize size = CGSizeMake(w, w * 1.34);
    
    self.imageLayer.frame = CGRectMake((CGRectGetWidth(self.bounds) - size.width) / 2,
                                       (CGRectGetHeight(self.bounds) - size.height) / 2,
                                       size.width, size.height);
    
    CGFloat textWidth = [self.textLayer.string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.textLayer.fontSize]}].width + 30;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.textLayer.frame = CGRectMake((CGRectGetWidth(self.bounds) - textWidth) / 2,
                                          70,
                                          textWidth,
                                          35);
    }else{
        self.textLayer.frame = CGRectMake((CGRectGetWidth(self.bounds) - textWidth) / 2,
                                          100,
                                          textWidth,
                                          25);
    }
    
}

@end
