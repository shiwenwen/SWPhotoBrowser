//
//  SWAlertView.m
//  SWPhotoBrowser
//
//  Created by mac on 2016/6/18.
//  Copyright © 2016年 sww. All rights reserved.
//
#import "SWAlertView.h"
#import "UIView+Frame.h"

static CGFloat const WAlert = 154;
static CGFloat const HAlert = 112;

@interface SWAlertView()
/** 1.标题 */
@property (nonatomic, strong, nullable)UILabel *labelTitle;
/** 2.图片 */
@property (nonatomic, strong, nullable)UIImageView *imageView;
@end

@implementation SWAlertView

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, WAlert, HAlert);
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, WAlert, HAlert);
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:115/255.0]];
    [self setClipsToBounds:YES];
    [self.layer setCornerRadius:2];
    [self.layer setOpacity:1.0];
    
    [self addSubview:self.labelTitle];
    [self addSubview:self.imageView];
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self setCenter:[UIApplication sharedApplication].keyWindow.center];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    [UIView animateKeyframesWithDuration:0.5
                                   delay:0.5
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                     [self.layer setOpacity:0.0];
                                 } completion:^(BOOL finished) {
                                     [self removeFromSuperview];
                                 }];
}

- (void)setStyle:(SWAlertViewStyle)style
{
    _style = style;
    
    if (style == SWAlertViewStyleError) {
        [self.labelTitle setText:@"图片保存出错"];
        [self.imageView setImage:[UIImage imageNamed:@"error_icon"]];
    }else{
        [self.labelTitle setText:@"图片已保存"];
        [self.imageView setImage:[UIImage imageNamed:@"success_icon"]];
    }
}

- (UILabel *)labelTitle
{
    if (!_labelTitle) {
        CGFloat titleX = 0;
        CGFloat titleY = self.height/2 - 5;
        CGFloat titleW = self.width;
        CGFloat titleH = self.height/2;
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
        [_labelTitle setTextColor:[UIColor whiteColor]];
        [_labelTitle setTextAlignment:NSTextAlignmentCenter];
        [_labelTitle setFont:[UIFont systemFontOfSize:15]];
    }
    return _labelTitle;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        CGFloat imageW = 40;
        CGFloat imageH = 40;
        CGFloat imageCenterX = self.width / 2;
        CGFloat imageCenterY = (self.height - imageH) / 2 + 10;
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageW, imageH)];
        [_imageView setCenter:CGPointMake(imageCenterX, imageCenterY)];
    }
    return _imageView;
}
@end
