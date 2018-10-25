//
//  KSCameraControl.m
//  Camera
//
//  Created by Mac on 2018/10/15.
//  Copyright © 2018年 kong. All rights reserved.
//

#import "KSCameraControl.h"

@interface KSCameraControl()
{
    struct {
        unsigned cameraControlDidCancel : 1;
        unsigned cameraControlTakePhoto : 1;
        unsigned cameraControlFocusPoint : 1;
        unsigned cameraControlDidChangeLocation : 1;
    } _delegateHas;
}

@property (nonatomic, strong) UIButton* cancelButton;
@property (nonatomic, strong) UIButton* photoButton;
@property (nonatomic, strong) UIView* focusView;

//舌头
@property (nonatomic, strong) UIButton* tongueButton;
//面部
@property (nonatomic, strong) UIButton* faceButton;
//手心
@property (nonatomic, strong) UIButton* handButton;

@property (nonatomic, strong) UIButton* currentLocationButton;

@end

@implementation KSCameraControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
        
        self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.photoButton setImage:[UIImage imageNamed:@"KSCameraBundle.bundle/photograph"] forState:UIControlStateNormal];
        [self.photoButton addTarget:self action:@selector(photoAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.photoButton];
        
        self.tongueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.tongueButton.tag = 0;
        [self.tongueButton setTitle:@"舌苔" forState:UIControlStateNormal];
//        [self.tongueButton setTitleColor:ThemeColor forState:UIControlStateSelected];
        [self.tongueButton addTarget:self action:@selector(locationChangeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.tongueButton];
        
        self.faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.faceButton.tag = 1;
        [self.faceButton setTitle:@"面部" forState:UIControlStateNormal];
//        [self.faceButton setTitleColor:ThemeColor forState:UIControlStateSelected];
        [self.faceButton addTarget:self action:@selector(locationChangeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.faceButton];
        
        self.handButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.handButton.tag = 2;
        [self.handButton setTitle:@"手心" forState:UIControlStateNormal];
//        [self.handButton setTitleColor:ThemeColor forState:UIControlStateSelected];
        [self.handButton addTarget:self action:@selector(locationChangeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.handButton];
        
        self.focusView = [[UIView alloc] init];
        self.focusView.layer.borderWidth = 1;
        self.focusView.layer.borderColor = [UIColor greenColor].CGColor;
        self.focusView.frame = CGRectMake(0, 0, 80, 80);
        self.focusView.userInteractionEnabled = NO;
        self.focusView.hidden = YES;
        [self addSubview:self.focusView];
        
        UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusAction:)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat cancelW = 40;
    CGFloat photoW = 60;
    
    CGFloat space = 20;
    
    self.cancelButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - space - cancelW,
                                         space,
                                         cancelW,
                                         cancelW);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.photoButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - photoW - space,
                                            (CGRectGetHeight(self.bounds) - photoW ) / 2,
                                            photoW,
                                            photoW);
        
        self.tongueButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - photoW - space,
                                             CGRectGetMaxY(self.photoButton.frame) + space,
                                             photoW,
                                             photoW / 2);
        
        self.faceButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - photoW - space,
                                           CGRectGetMaxY(self.tongueButton.frame) + space,
                                           photoW,
                                           photoW / 2);
        
        self.handButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - photoW - space,
                                           CGRectGetMaxY(self.faceButton.frame) + space,
                                           photoW,
                                           photoW / 2);
        
        
    }else{
        self.photoButton.frame = CGRectMake((CGRectGetWidth(self.bounds) - photoW) / 2,
                                            CGRectGetHeight(self.bounds) - 100,
                                            photoW,
                                            photoW);
        
        self.faceButton.frame = CGRectMake((CGRectGetWidth(self.bounds) - photoW )/2,
                                           space,
                                           cancelW,
                                           cancelW);
        
        self.tongueButton.frame = CGRectMake(CGRectGetMinX(self.faceButton.frame) - photoW,
                                             space,
                                             cancelW,
                                             cancelW);
        
        self.handButton.frame = CGRectMake(CGRectGetMinX(self.faceButton.frame) + photoW,
                                           space,
                                           cancelW,
                                           cancelW);
    }
    
    self.tongueButton.layer.cornerRadius =
    self.faceButton.layer.cornerRadius =
    self.handButton.layer.cornerRadius = photoW / 4;
}

- (void)setDelegate:(id<KSCameraControlDelegate>)delegate{
    _delegate = delegate;
    _delegateHas.cameraControlDidCancel = [delegate respondsToSelector:@selector(cameraControlDidCancel:)];
    _delegateHas.cameraControlTakePhoto = [delegate respondsToSelector:@selector(cameraControlTakePhoto:)];
    _delegateHas.cameraControlFocusPoint = [delegate respondsToSelector:@selector(cameraControl:focusPoint:)];
    _delegateHas.cameraControlDidChangeLocation = [delegate respondsToSelector:@selector(cameraControl:didChangeLocation:)];
}

- (void)setLocation:(KSInterfaceLocation)location{
    _location = location;
    
    switch (location) {
        case KSInterfaceTongue:
        {
            [self locationChangeAction:self.tongueButton];
        }
            break;
            
        case KSInterfaceFace:
        {
            [self locationChangeAction:self.faceButton];
        }
            break;
        case KSInterfaceHand:
        {
            [self locationChangeAction:self.handButton];
        }
            break;
    }
}

- (void)locationChangeAction:(UIButton*)button{
    
    _location = button.tag;

    self.currentLocationButton.selected = NO;
    self.currentLocationButton.backgroundColor = [UIColor clearColor];
    self.currentLocationButton = button;

    button.selected = YES;
    button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    
    if (_delegateHas.cameraControlDidChangeLocation) {
        [_delegate cameraControl:self didChangeLocation:_location];
    }
}

#pragma mark- action
- (void)cancelAction:(UIButton*)cancel{
    if (_delegateHas.cameraControlDidCancel) {
        [self.delegate cameraControlDidCancel:self];
    }
}

- (void)photoAction:(UIButton*)btn{
    //防止连续点击
    btn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.userInteractionEnabled = YES;
    });
    
    if (_delegateHas.cameraControlTakePhoto) {
        [self.delegate cameraControlTakePhoto:self];
    }
}

- (void)focusAction:(UITapGestureRecognizer*)ges{
    if (_delegateHas.cameraControlFocusPoint) {
        CGPoint point = [ges locationInView:self];
        [self transformFocusView:point];
        [self.delegate cameraControl:self focusPoint:point];
    }
}

- (void)transformFocusView:(CGPoint)center{
    self.focusView.center = center;
    self.focusView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self->_focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self->_focusView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self->_focusView.hidden = YES;
        }];
    }];
}

@end
