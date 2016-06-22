//
//  SWBrowserPhotoController.m
//  SWPhotoBrowser
//
//  Created by mac on 2016/6/18.
//  Copyright © 2016年 sww. All rights reserved.
//

#import "SWBrowserPhotoController.h"
#import "SDWebImageManager.h"
@interface SWBrowserPhotoController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    BOOL _isUrl;//是否是网络图片
    
}
@property (nonatomic,strong)UICollectionView *imageCollectionView;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,strong)UILabel *indexTitleView;//浏览位置标题
@property (nonatomic,strong)UIButton *deleteButton;//删除按钮
@end

@implementation SWBrowserPhotoController
#pragma mark -- 初始化
-(instancetype)initWithPhotos:(NSArray *)photos pushAnimation:(BOOL) isAnimation sourceImagesContainerView:(UIScrollView *)containerView{
    
    if (self = [super init]) {
        self.LoadingInAdvance = YES;
        self.photos = [NSMutableArray arrayWithArray:photos];
        self.isAnimation = isAnimation;
        self.hidesBottomBarWhenPushed = YES;
        self.sourceImagesContainerView = containerView;
        self.view.backgroundColor = [UIColor blackColor];
        self.maxZoomScale = 2;
  
 }
    
    return self;
}
-(instancetype)initWithPhotos:(NSArray *)photos sourceImagesContainerView:(UIScrollView *)containerView{
    if (self = [super init]) {
        self.LoadingInAdvance = YES;
        self.photos = [NSMutableArray arrayWithArray:photos];
        self.hidesBottomBarWhenPushed = YES;
        self.sourceImagesContainerView = containerView;
        self.view.backgroundColor = [UIColor blackColor];
        self.maxZoomScale = 2;
        
    }
    
    return self;
}
#pragma mark -- 显示
-(void)show{
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self
                                                                                     animated:NO
                                                                                   completion:nil];
    
}
-(void)showInController:(UIViewController *)controller{
    
    [controller presentViewController:self animated:NO completion:nil];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:self.isAnimation];
    
    [self.imageCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    if (self.showPageControl) {
        
        [self.view addSubview:self.pageControl];
        
    }
    if (self.showIndexTitle) {
        [self.view addSubview:self.indexTitleView];
    }
    if (self.showDelete) {
        [self.view addSubview:self.deleteButton];
    }
    
    
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    [self showPhotoBrowser];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configImageCollectionView];
    
    
    
}

#pragma mark -- UIPageControl
-(UIPageControl *)pageControl{
    
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 45, SCREEN_WIDTH, 40)];
        
        _pageControl.numberOfPages = self.photos.count;
        _pageControl.currentPage = self.currentIndex;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        
    }
    return _pageControl;
}
#pragma mark --标题
-(UILabel *)indexTitleView{
    if (!_indexTitleView) {
        _indexTitleView = [[UILabel alloc]initWithFrame:CGRectMake(100, 32.5, SCREEN_WIDTH - 200, 20)];
        _indexTitleView.textColor = [UIColor whiteColor];
        _indexTitleView.font = [UIFont systemFontOfSize:19];
        _indexTitleView.textAlignment = NSTextAlignmentCenter;
        
    }
    _indexTitleView.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex+1,(unsigned long)self.photos.count];
    return _indexTitleView;
}
#pragma mark -- 删除
-(UIButton *)deleteButton{
    
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(SCREEN_WIDTH - 65, 32.5, 50, 20);
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deletePic) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:19];
    }
    return _deleteButton;
}
-(void)deletePic{
    [self.photos removeObjectAtIndex:self.currentIndex];
    if (_isUrl) {
        
        if ([self.placeholderPhotos.firstObject isKindOfClass:[NSString class]]) {
            
            
            [self.placeholderPhotos removeObjectAtIndex:self.currentIndex];
        }
        
    }
    
    if ([self.delegate respondsToSelector:@selector(photoBrowser:deleteAtIndex:)]) {
        
        [self.delegate photoBrowser:self deleteAtIndex:self.currentIndex];
        
    }
    
    if (self.currentIndex == self.photos.count) {
        
        self.currentIndex = self.photos.count - 1;
    }
    self.indexTitleView.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex+1,(unsigned long)self.photos.count];
    self.pageControl.numberOfPages = self.photos.count;
    self.pageControl.currentPage = self.currentIndex;
    if (self.photos.count < 1) {
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:self.isAnimation];
        }else{
            [self dismissViewControllerAnimated:NO completion:NULL];
        }
        
        
    }
    [self.imageCollectionView reloadData];
    
    
}

#pragma --mark 配置图片
-(void)configImageCollectionView{
    
    
    UICollectionViewFlowLayout *laytout = [[UICollectionViewFlowLayout alloc]init];
    laytout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    laytout.minimumLineSpacing = 0;
    laytout.minimumInteritemSpacing = 0;
    if (self.navigationController) {
      laytout.sectionInset = UIEdgeInsetsMake(-20, 0, 0, 0);  
    }
    
    laytout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.imageCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:laytout];
    
    self.imageCollectionView.showsVerticalScrollIndicator = NO;
    self.imageCollectionView.showsHorizontalScrollIndicator = NO;
    [self.imageCollectionView registerClass:[SWPhotoCell class] forCellWithReuseIdentifier:@"SWPhotoCell"];
    self.imageCollectionView.delegate = self;
    self.imageCollectionView.dataSource = self;
    self.imageCollectionView.pagingEnabled = YES;
//    self.imageCollectionView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.imageCollectionView];
    
    self.imageCollectionView.hidden = YES;
    
    
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.photos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SWPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SWPhotoCell" forIndexPath:indexPath];
    cell.FillTheSamllPic = self.FillTheSamllPic;
    cell.allowSaveImage = YES;
    cell.maxScale = self.maxZoomScale;

   
    if (_isUrl) {
        
        
        if (self.placeholderPhotos.count > 0) {
            
            
            if([self.placeholderPhotos.firstObject isKindOfClass:[UIImage class]]){
                cell.placeholderImage = self.placeholderPhotos.firstObject;
            }else{
               cell.placeholderImageUrl = self.placeholderPhotos[indexPath.item]; 
            }
            
        }else{
            UIView *convertView;
            
            if ([self.sourceImagesContainerView isKindOfClass:[UICollectionView class]]) {
                
                UICollectionViewCell *cell = [((UICollectionView *)self.sourceImagesContainerView)cellForItemAtIndexPath:indexPath];
                
                convertView = cell.contentView.subviews.firstObject;
                
            }else{
                
                convertView = self.sourceImagesContainerView.subviews[indexPath.item];
                
            }
            
            if ([convertView isKindOfClass:[UIButton class]]) {
                cell.placeholderImage =((UIButton *)convertView).imageView.image;
            }else if([convertView isKindOfClass:[UIImageView class]]){
              cell.placeholderImage =((UIImageView *)convertView).image;
            }
            
            

            
        }
        
     cell.imageUrl = self.photos[indexPath.item];
    }else{
        
        cell.image = self.photos[indexPath.item];
    }
   
    cell.singleBlock = ^(){
      
        [self performSelectorOnMainThread:@selector(closePhotoBrowser:) withObject:indexPath waitUntilDone:YES];
        
    };
    
    return cell;
    
}

-(void)setPhotos:(NSMutableArray *)photos{
    _photos = photos;
    
    if ([_photos.firstObject isKindOfClass:[NSString class]]) {
        
        _isUrl = YES;
        
        if (self.LoadingInAdvance) {
            for (NSString *urlStr in _photos) {
                
                  [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:urlStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                      
                  } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                      
                  }];
                
            }
            
            
        }
       
        
        
    }
    
    
}
#pragma mark -- ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.currentIndex = scrollView.contentOffset.x/SCREEN_WIDTH;
    if (_showIndexTitle) {
      self.indexTitleView.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.currentIndex+1,(unsigned long)self.photos.count];
    }
    if (_showPageControl) {
        
      self.pageControl.currentPage = self.currentIndex;
        
    }
    
    
    
}
#pragma mark --恢复大小
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SWPhotoCell *swCell = (SWPhotoCell *)cell;
    //恢复大小
    [swCell restoreTheSize];
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
    
    
    
}
#pragma mark -- 出现
-(void)showPhotoBrowser{
    
 
            
            SWPhotoCell *cell = (SWPhotoCell *)[self.imageCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
            
            UIImageView *tempImageView = [[UIImageView alloc] init];
            tempImageView.image = cell.imageView.image;
    
            UIView *convertView;
            
            if ([self.sourceImagesContainerView isKindOfClass:[UICollectionView class]]) {
                
                UICollectionViewCell *cell = [((UICollectionView *)self.sourceImagesContainerView)cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
                
                convertView = cell.contentView.subviews.firstObject;
                
            }else{
                
                convertView = self.sourceImagesContainerView.subviews[self.currentIndex];
                
            }
            
            CGRect frame = [convertView.superview convertRect:convertView.frame toView:[UIApplication sharedApplication].keyWindow];
            tempImageView.frame = frame;
        [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 tempImageView.frame = cell.imageView.frame;
                             } completion:^(BOOL finished) {
                                 self.imageCollectionView.hidden = NO;
                                 [tempImageView removeFromSuperview];
                             }];
    
        
    
    
}

#pragma mark--关闭图片浏览
-(void)closePhotoBrowser:(NSIndexPath *)indexpath{
    
    if (self.isAnimation) {
        if (self.navigationController) {
          [self.navigationController popViewControllerAnimated:self.isAnimation];
        }else{
            
            SWPhotoCell *cell = (SWPhotoCell *)[self.imageCollectionView cellForItemAtIndexPath:indexpath];
            
            UIImageView *tempImageView = [[UIImageView alloc] init];
            tempImageView.image = cell.imageView.image;
            tempImageView.frame = cell.imageView.frame;
            
            
            
            
            [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
            
            if (self.navigationController) {
                
                [self.navigationController popViewControllerAnimated:self.isAnimation];
                
            }else{
                
                [self dismissViewControllerAnimated:NO completion:NULL];
            }
            
            
            UIView *convertView;
            
            if ([self.sourceImagesContainerView isKindOfClass:[UICollectionView class]]) {
                
                UICollectionViewCell *cell = [((UICollectionView *)self.sourceImagesContainerView)cellForItemAtIndexPath:indexpath];
                
                convertView = cell.contentView.subviews.firstObject;
                
            }else{
                
                convertView = self.sourceImagesContainerView.subviews[self.currentIndex];
                
            }
            
            CGRect frame = [convertView.superview convertRect:convertView.frame toView:[UIApplication sharedApplication].keyWindow];
            
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 tempImageView.frame = frame;
                                 tempImageView.alpha = 0.9;
                             } completion:^(BOOL finished) {
                                 [tempImageView removeFromSuperview];
                             }];

        }
        
    }else{
        
        
        SWPhotoCell *cell = (SWPhotoCell *)[self.imageCollectionView cellForItemAtIndexPath:indexpath];
        
        UIImageView *tempImageView = [[UIImageView alloc] init];
        tempImageView.image = cell.imageView.image;
        tempImageView.frame = cell.imageView.frame;
        
        
        
        [[UIApplication sharedApplication].keyWindow addSubview:tempImageView];
        if (self.navigationController) {
            
           [self.navigationController popViewControllerAnimated:self.isAnimation];
            
        }else{
            
            [self dismissViewControllerAnimated:NO completion:NULL];
        }
        
        
        UIView *convertView;
        
        if ([self.sourceImagesContainerView isKindOfClass:[UICollectionView class]]) {
            
            UICollectionViewCell *cell = [((UICollectionView *)self.sourceImagesContainerView)cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
            
            convertView = cell.contentView.subviews.firstObject;
            
        }else{
            
            convertView = self.sourceImagesContainerView.subviews[self.currentIndex];
            
        }
        
        CGRect frame = [convertView.superview convertRect:convertView.frame toView:[UIApplication sharedApplication].keyWindow];
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             tempImageView.frame = frame;
                             tempImageView.alpha = 0.9;
                         } completion:^(BOOL finished) {
                             [tempImageView removeFromSuperview];
                         }];
        
    }
    

    
    
}
- (UIView *)getSuperView:(UIView *)view
{
    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
        return view;
    }
    return [self getSuperView:view.superview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
