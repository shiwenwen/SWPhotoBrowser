//
//  SWIndicatorView.m
//  SWPhotoBrowser
//
//  Created by mac on 2016/6/18.
//  Copyright © 2016年 sww. All rights reserved.
//
#import "SWIndicatorView.h"
#import "UIView+Frame.h"

static CGFloat const WidthIndicator = 42;
static CGFloat const SWMargin = 10;
static  CGFloat const SWMarginSmall = 5;
@implementation SWIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.7];
        self.clipsToBounds = YES;
        self.viewMode = SWIndicatorViewModeLoopDiagram;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
    
    // 1.当进度完成时，从父视图移除
    if (progress >= 1) {
        [self removeFromSuperview];
    }
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width = WidthIndicator;
    frame.size.height = WidthIndicator;
    self.layer.cornerRadius = WidthIndicator / 2;
    [super setFrame:frame];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef content = UIGraphicsGetCurrentContext();

    CGFloat centerX = rect.size.width / 2;
    CGFloat centerY = rect.size.height / 2;
    [[UIColor whiteColor] set];
    
    switch (self.viewMode) {
        case SWIndicatorViewModeLoopDiagram:
        {
            CGContextSetLineWidth(content, 2);
            CGContextSetLineCap(content, kCGLineCapRound);
            CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.05; // 初始值0.05
            CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5 - SWMargin;
            CGContextAddArc(content, centerX, centerY, radius, - M_PI * 0.5, to, 0);
            CGContextStrokePath(content);}
            break;
        default:
        {
            CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - SWMarginSmall;
            
            CGFloat contentW = radius * 2 + SWMargin;
            CGFloat contentH = contentW;
            CGFloat contentX = (rect.size.width - contentW) * 0.5;
            CGFloat contentY = (rect.size.height - contentH) * 0.5;
            CGContextAddEllipseInRect(content, CGRectMake(contentX, contentY, contentW, contentH));
            CGContextFillPath(content);
            
            [[UIColor lightGrayColor] set];
            CGContextMoveToPoint(content, centerX, centerY);
            CGContextAddLineToPoint(content, centerX, 0);
            CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.001; // 初始值
            CGContextAddArc(content, centerX, centerY, radius, - M_PI * 0.5, to, 1);
            CGContextClosePath(content);
            
            CGContextFillPath(content);
        }
            break;
    }
}
@end
