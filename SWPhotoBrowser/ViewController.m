//
//  ViewController.m
//  SWPhotoBrowser
//
//  Created by 石文文 on 16/6/21.
//  Copyright © 2016年 石文文. All rights reserved.
//

#import "ViewController.h"
#import "SWBrowserPhotoController.h"
#import "UIButton+WebCache.h"
@interface ViewController ()

@property (nonatomic, strong, nullable)NSArray *arrayImageUrl; //

@property (nonatomic, strong, nullable)UIScrollView *scrollView; //

@property (nonatomic, strong, nullable)NSMutableArray *arrayButton; //
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
    
    
    __block CGFloat buttonW = (SCREEN_WIDTH - 10 * 3)/3;
    __block CGFloat buttonH = buttonW;
    __block CGFloat buttonX = 0;
    __block CGFloat buttonY = 0;
    [self.arrayImageUrl enumerateObjectsUsingBlock:^(NSString *imageUrl, NSUInteger idx, BOOL * _Nonnull stop) {
        buttonX = 10 + (idx % 3) * (buttonW + 5);
        buttonY = (idx / 3) * (buttonH + 5);
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(buttonX,
                                                                     buttonY,
                                                                     buttonW,
                                                                     buttonH)];
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        button.clipsToBounds = YES;
        [button sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                          forState:UIControlStateNormal
                  placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        
        [button setTag:idx];
        [button addTarget:self
                   action:@selector(buttonClick:)
         forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        [self.arrayButton addObject:button];
    }];
    
    
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,
                                               (self.arrayImageUrl.count / 3 + 1)* (buttonH +
                                                                                    5))];
}



- (void)buttonClick:(UIButton *)button
{
    SWBrowserPhotoController *bro = [[SWBrowserPhotoController alloc]initWithPhotos:self.arrayImageUrl sourceImagesContainerView:button.imageView];
    bro.showIndexTitle = YES;
    bro.showPageControl = YES;
    bro.currentIndex = (int)button.tag;
    bro.allowSaveImage = YES;
    
    bro.showDelete = YES;
    bro.FillTheSamllPic = YES;
    bro.maxZoomScale = 2;
    [bro show];
    
    
}






- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,
                                                                    20,
                                                                    SCREEN_WIDTH,
                                                                    SCREEN_HEIGHT - 20)];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
    }
    return _scrollView;
}

- (NSArray *)arrayImageUrl
{
    return @[@"http://img.jj20.com/up/allimg/911/121215132T8/151212132T8-1-lp.jpg",
             @"http://b.zol-img.com.cn/sjbizhi/images/6/208x312/1396940684766.jpg",
             @"http://b.zol-img.com.cn/sjbizhi/images/6/208x312/1394701139813.jpg",
             @"http://img.jj20.com/up/allimg/911/0P315132137/150P3132137-1-lp.jpg",
             @"http://b.zol-img.com.cn/sjbizhi/images/1/208x312/1350915106394.jpg",
             @"http://b.zol-img.com.cn/sjbizhi/images/8/208x312/1427966117121.jpg",
             @"http://img.jj20.com/up/allimg/811/052515103222/150525103222-1-lp.jpg",
             @"http://b.zol-img.com.cn/sjbizhi/images/8/208x312/1435742799400.jpg",
             @"http://imga1.pic21.com/bizhi/131016/02507/s11.jpg"];
}

- (NSMutableArray *)arrayButton
{
    if (!_arrayButton) {
        _arrayButton = [NSMutableArray array];
    }
    return _arrayButton;
}

@end
