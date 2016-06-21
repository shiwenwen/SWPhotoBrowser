//
//  SWPhotoCell.m
//  SWPhotoBrowser
//
//  Created by mac on 2016/6/18.
//  Copyright © 2016年 sww. All rights reserved.
//

#import "SWPhotoCell.h"
#import "UIImageView+WebCache.h"
#import "SWAlertView.h"
#import "SWIndicatorView.h"
@interface SWPhotoCell()<UIScrollViewDelegate,UIAlertViewDelegate>{
    
    
    
}

@property(nonatomic,strong)UIScrollView *imageScrollView;
@property(nonatomic,strong)SWIndicatorView *indicatorView;
@end

@implementation SWPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.maxScale = 2.0;
        
        [self configImageViews];
//        self.backgroundColor = [UIColor yellowColor];
        
    }
    return self;
}
#pragma --配置图片视图
-(void)configImageViews{
    
    self.imageScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    
    self.imageScrollView.backgroundColor = [UIColor blackColor];
    
    [self.contentView addSubview:self.imageScrollView];
    
    self.imageScrollView.delegate = self;
    self.imageScrollView.bounces = NO;
    self.imageScrollView.bouncesZoom = NO;
    self.imageView = [[UIImageView alloc]initWithFrame:self.imageScrollView.bounds];
    
    [self.imageScrollView addSubview:self.imageView];
//    self.imageScrollView.backgroundColor = [UIColor redColor];
    self.imageScrollView.contentSize = self.imageView.frame.size;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageZooming:)];
    doubleTap.numberOfTapsRequired = 2;
    self.imageView.userInteractionEnabled = YES;
    
    [self.imageView addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    [self.imageScrollView addGestureRecognizer:tap];
    
    [tap requireGestureRecognizerToFail:doubleTap];
    
    
}

- (SWIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[SWIndicatorView alloc]init];
        [_indicatorView setViewMode:SWIndicatorViewModePieDiagram];
        _indicatorView.center = self.imageScrollView.center;
    }
    return _indicatorView;
}
#pragma mark -- 长按保存图片
-(void)setAllowSaveImage:(BOOL)allowSaveImage{
    _allowSaveImage = allowSaveImage;
    
    
    UILongPressGestureRecognizer *longPre = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveImage:)];
    [self.imageView addGestureRecognizer:longPre];
}
-(void)saveImage:(UILongPressGestureRecognizer *)longPre{
    
    if (longPre.state ==UIGestureRecognizerStateBegan ) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"保存图片？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        
        UIImageWriteToSavedPhotosAlbum(self.imageView.image,
                                       self,
                                       @selector(savedPhotosAlbumWithImage:didFinishSavingWithError:contextInfo:),
                                       NULL);

        
    }
    
}

- (void)savedPhotosAlbumWithImage:(UIImage *)image
         didFinishSavingWithError:(NSError *)error
                      contextInfo:(void *)contextInfo
{
    
    
    
    SWAlertView *alert = [[SWAlertView alloc]init];
    
    if (error) {
        [alert setStyle:SWAlertViewStyleError];
    }else {
        [alert setStyle:SWAlertViewStyleSuccess];
    }
    [alert show];
}
#pragma mark --单击
-(void)singleTap:(UITapGestureRecognizer *)tap{
    
    if (self.singleBlock) {
        self.singleBlock();
    }
    
    
}
#pragma mark --双击放大
-(void)imageZooming:(UITapGestureRecognizer *)tap{
    

    CGPoint touchPoint = [tap locationInView:self];
    if (self.imageScrollView.zoomScale <= 1.0) {
        CGFloat scaleX = touchPoint.x + self.imageScrollView.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + self.imageScrollView.contentOffset.y;//需要放大的图片的Y点
        [self.imageScrollView zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
    } else {
        [self.imageScrollView setZoomScale:1.0 animated:YES]; //还原
    }

    
    
}
-(void)restoreTheSize{
    
    [self.imageScrollView setZoomScale:1.0 animated:YES]; //还原
    
}

-(void)setPlaceholderImageUrl:(NSString *)placeholderImageUrl{
    
    _placeholderImageUrl = placeholderImageUrl;
    
    self.imageScrollView.scrollEnabled = NO;
    __weak typeof(self) weakSelf = self;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_placeholderImageUrl] placeholderImage:self.placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        
        
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error) {
            
            return ;
            
        }
        
        
        strongSelf.imageScrollView.minimumZoomScale = 1;
        
        if (image.size.width > image.size.height) {
            //宽图
            if (image.size.width > SCREEN_WIDTH) {
                
                //比屏幕宽
                
                CGFloat height = image.size.height * SCREEN_WIDTH / image.size.width;
                
                if (height > SCREEN_HEIGHT) {
                    height = SCREEN_HEIGHT;
                    CGFloat width = image.size.width * SCREEN_HEIGHT / image.size.height;
                    strongSelf.imageView.frame = CGRectMake((SCREEN_WIDTH - width)/2, 0, width, height);
                }else{
                    
                    strongSelf.imageView.frame = CGRectMake(0, (SCREEN_HEIGHT - height)/2, SCREEN_WIDTH, height);
                }
                
                
            }else{
                
                
                if (strongSelf.FillTheSamllPic) {
                    //填充
                    
                    
                    //填充
                    CGFloat height = image.size.height * SCREEN_WIDTH / image.size.width;
                    if (height > SCREEN_HEIGHT) {
                        height = SCREEN_HEIGHT;
                        CGFloat width = image.size.width * SCREEN_HEIGHT / image.size.height;
                        strongSelf.imageView.frame = CGRectMake((SCREEN_WIDTH - width)/2, 0, width, height);
                    }else{
                        
                        strongSelf.imageView.frame = CGRectMake(0, (SCREEN_HEIGHT - height)/2, SCREEN_WIDTH, height);
                    }
                    
                }else{
                    //不填充
                    CGFloat width = image.size.width;
                    CGFloat height = image.size.height;
                    strongSelf.imageView.frame = CGRectMake((SCREEN_WIDTH - width)/2, (SCREEN_HEIGHT - height)/2, width, height);
                }
                
                
                
            }
            
            
            strongSelf.imageScrollView.minimumZoomScale = strongSelf.imageView.frame.size.width / SCREEN_WIDTH;
            
        }else{
            //长图
            
            if (image.size.height > SCREEN_HEIGHT) {
                
                //比屏幕高
                
                CGFloat width = image.size.width * SCREEN_HEIGHT / image.size.height;
                if (width > SCREEN_WIDTH) {
                    width = SCREEN_WIDTH;
                    CGFloat height = image.size.height * SCREEN_WIDTH / image.size.width;
                    strongSelf.imageView.frame = CGRectMake(0,(SCREEN_HEIGHT - height)/2, width, height);
                }else{
                    strongSelf.imageView.frame = CGRectMake((SCREEN_WIDTH - width)/2, 0, width, SCREEN_HEIGHT);
                }
                
                
                
                
            }else{
                
                if (self.FillTheSamllPic) {
                    //填充
                    CGFloat width = image.size.width * SCREEN_HEIGHT / image.size.height;
                    if (width > SCREEN_WIDTH) {
                        width = SCREEN_WIDTH;
                        CGFloat height = image.size.height * SCREEN_WIDTH / image.size.width;
                        strongSelf.imageView.frame = CGRectMake(0,(SCREEN_HEIGHT - height)/2, width, height);
                    }else{
                        
                        strongSelf.imageView.frame = CGRectMake((SCREEN_WIDTH - width)/2, 0, width, SCREEN_HEIGHT);
                    }
                    
                    
                    
                }else{
                    //不填充
                    CGFloat width = image.size.width;
                    CGFloat height = image.size.height;
                    strongSelf.imageView.frame = CGRectMake((SCREEN_WIDTH - width)/2, (SCREEN_HEIGHT - height)/2, width, height);
                    
                    
                }
                
                
                
            }
            
            strongSelf.imageScrollView.minimumZoomScale = strongSelf.imageView.frame.size.height / SCREEN_HEIGHT;
            
        }
        
        
        
    }];

    
}

-(void)setImageUrl:(NSString *)imageUrl{
    
    _imageUrl = imageUrl;
    [self addSubview:self.indicatorView];
    __weak typeof(self) weakSelf = self;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:self.placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (receivedSize < expectedSize) {
            
            strongSelf.imageScrollView.scrollEnabled = NO;
        }else{
            strongSelf.imageScrollView.scrollEnabled = YES;
        }
        
        
        strongSelf.indicatorView.progress = (CGFloat)receivedSize / expectedSize;
        
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error) {
            
            strongSelf.imageScrollView.scrollEnabled = NO;
            
            return ;
        }
        
        [strongSelf.indicatorView removeFromSuperview];
        
        
        if (image.size.width > image.size.height) {
            //宽图
            if (image.size.width > SCREEN_WIDTH) {
                
                //比屏幕宽
                
                CGFloat height = image.size.height * SCREEN_WIDTH / image.size.width;
            
                if (height > SCREEN_HEIGHT) {
                    height = SCREEN_HEIGHT;
                    CGFloat width = image.size.width * SCREEN_HEIGHT / image.size.height;
                    strongSelf.imageView.frame = CGRectMake((SCREEN_WIDTH - width)/2, 0, width, height);
                }else{
                    
                    strongSelf.imageView.frame = CGRectMake(0, (SCREEN_HEIGHT - height)/2, SCREEN_WIDTH, height);
                }
                
                
            }else{
                
                
                if (strongSelf.FillTheSamllPic) {
                    //填充
                   
                    
                    //填充
                    CGFloat height = image.size.height * SCREEN_WIDTH / image.size.width;
                    if (height > SCREEN_HEIGHT) {
                        height = SCREEN_HEIGHT;
                        CGFloat width = image.size.width * SCREEN_HEIGHT / image.size.height;
                        strongSelf.imageView.frame = CGRectMake((SCREEN_WIDTH - width)/2, 0, width, height);
                    }else{
                        
                        strongSelf.imageView.frame = CGRectMake(0, (SCREEN_HEIGHT - height)/2, SCREEN_WIDTH, height);
                    }
                    
                }else{
                    //不填充
                    CGFloat width = image.size.width;
                    CGFloat height = image.size.height;
                    strongSelf.imageView.frame = CGRectMake((SCREEN_WIDTH - width)/2, (SCREEN_HEIGHT - height)/2, width, height);
                }
                
                
                
            }
            
            
            strongSelf.imageScrollView.minimumZoomScale = strongSelf.imageView.frame.size.width / SCREEN_WIDTH;
            
        }else{
            //长图
            
            if (image.size.height > SCREEN_HEIGHT) {
                
                //比屏幕高
                
                CGFloat width = image.size.width * SCREEN_HEIGHT / image.size.height;
                if (width > SCREEN_WIDTH) {
                    width = SCREEN_WIDTH;
                    CGFloat height = image.size.height * SCREEN_WIDTH / image.size.width;
                    strongSelf.imageView.frame = CGRectMake(0,(SCREEN_HEIGHT - height)/2, width, height);
                }else{
                  strongSelf.imageView.frame = CGRectMake((SCREEN_WIDTH - width)/2, 0, width, SCREEN_HEIGHT);
                }
                
                
                
                
            }else{
                
                if (strongSelf.FillTheSamllPic) {
                    //填充
                    CGFloat width = image.size.width * SCREEN_HEIGHT / image.size.height;
                    if (width > SCREEN_WIDTH) {
                        width = SCREEN_WIDTH;
                        CGFloat height = image.size.height * SCREEN_WIDTH / image.size.width;
                        strongSelf.imageView.frame = CGRectMake(0,(SCREEN_HEIGHT - height)/2, width, height);
                    }else{
                        
                        strongSelf.imageView.frame = CGRectMake((SCREEN_WIDTH - width)/2, 0, width, SCREEN_HEIGHT);
                    }
                    
                    
                    
                }else{
                    //不填充
                    CGFloat width = image.size.width;
                    CGFloat height = image.size.height;
                    strongSelf.imageView.frame = CGRectMake((SCREEN_WIDTH - width)/2, (SCREEN_HEIGHT - height)/2, width, height);
                    
                    
                }
                
                
                
            }
            
         strongSelf.imageScrollView.minimumZoomScale = strongSelf.imageView.frame.size.height / SCREEN_HEIGHT;
            
        }
        
        strongSelf.imageScrollView.scrollEnabled = YES;
        strongSelf.imageScrollView.maximumZoomScale = strongSelf.maxScale;
        
    }];
    
    
    
}
-(void)setImage:(UIImage *)image{
    
    _image = image;
    
    self.imageView.image = _image;
    
    
    
    self.imageScrollView.minimumZoomScale = 1;
    
    if (image.size.width > image.size.height) {
        //宽图
        if (image.size.width > SCREEN_WIDTH) {
            
            //比屏幕宽
            
            CGFloat height = image.size.height * SCREEN_WIDTH / image.size.width;
            
            if (height > SCREEN_HEIGHT) {
                height = SCREEN_HEIGHT;
                CGFloat width = image.size.width * SCREEN_HEIGHT / image.size.height;
                self.imageView.frame = CGRectMake((SCREEN_WIDTH - width)/2, 0, width, height);
            }else{
                
                self.imageView.frame = CGRectMake(0, (SCREEN_HEIGHT - height)/2, SCREEN_WIDTH, height);
            }
            
            
        }else{
            
            
            if (self.FillTheSamllPic) {
                //填充
                
                
                //填充
                CGFloat height = image.size.height * SCREEN_WIDTH / image.size.width;
                if (height > SCREEN_HEIGHT) {
                    height = SCREEN_HEIGHT;
                    CGFloat width = image.size.width * SCREEN_HEIGHT / image.size.height;
                    self.imageView.frame = CGRectMake((SCREEN_WIDTH - width)/2, 0, width, height);
                }else{
                    
                    self.imageView.frame = CGRectMake(0, (SCREEN_HEIGHT - height)/2, SCREEN_WIDTH, height);
                }
                
            }else{
                //不填充
                CGFloat width = image.size.width;
                CGFloat height = image.size.height;
                self.imageView.frame = CGRectMake((SCREEN_WIDTH - width)/2, (SCREEN_HEIGHT - height)/2, width, height);
            }
            
            
            
        }
        
        
        self.imageScrollView.minimumZoomScale = self.imageView.frame.size.width / SCREEN_WIDTH;
        
    }else{
        //长图
        
        if (image.size.height > SCREEN_HEIGHT) {
            
            //比屏幕高
            
            CGFloat width = image.size.width * SCREEN_HEIGHT / image.size.height;
            if (width > SCREEN_WIDTH) {
                width = SCREEN_WIDTH;
                CGFloat height = image.size.height * SCREEN_WIDTH / image.size.width;
                self.imageView.frame = CGRectMake(0,(SCREEN_HEIGHT - height)/2, width, height);
            }else{
                self.imageView.frame = CGRectMake((SCREEN_WIDTH - width)/2, 0, width, SCREEN_HEIGHT);
            }
            
            
            
            
        }else{
            
            if (self.FillTheSamllPic) {
                //填充
                CGFloat width = image.size.width * SCREEN_HEIGHT / image.size.height;
                if (width > SCREEN_WIDTH) {
                    width = SCREEN_WIDTH;
                    CGFloat height = image.size.height * SCREEN_WIDTH / image.size.width;
                    self.imageView.frame = CGRectMake(0,(SCREEN_HEIGHT - height)/2, width, height);
                }else{
                    
                    self.imageView.frame = CGRectMake((SCREEN_WIDTH - width)/2, 0, width, SCREEN_HEIGHT);
                }
                
                
                
            }else{
                //不填充
                CGFloat width = image.size.width;
                CGFloat height = image.size.height;
                self.imageView.frame = CGRectMake((SCREEN_WIDTH - width)/2, (SCREEN_HEIGHT - height)/2, width, height);
                
                
            }
            
            
            
        }
        
        self.imageScrollView.minimumZoomScale = self.imageView.frame.size.height / SCREEN_HEIGHT;
        
    }
    
    
    
    self.imageScrollView.scrollEnabled = YES;
    self.imageScrollView.maximumZoomScale = self.maxScale;
    
    
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width)?
    (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height)?
    (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}


#pragma --UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}// any offset changes
- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2){
    
    self.imageView.center = [self centerOfScrollViewContent:scrollView];
    
    
}// any zoom scale changes

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}
// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0){
    
}
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    
}// called on finger up as we are moving
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
}// called when scroll view grinds to a halt

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    
}// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    
    
    return self.imageView;
}// return a view that will be scaled. if delegate returns nil, nothing happens
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view NS_AVAILABLE_IOS(3_2){
    
    
}// called before the scroll view begins zooming its content
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    
    
    
}// scale between minimum and maximum. called after any 'bounce' animations

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    
    return NO;
}// return a yes if you want to scroll to the top. if not defined, assumes YES
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    
    
}// called when scrolling animation finished. may be called immediately if already at top



@end
