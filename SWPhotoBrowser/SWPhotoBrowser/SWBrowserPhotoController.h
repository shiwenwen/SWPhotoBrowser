//
//  SWBrowserPhotoController.h
//  SWPhotoBrowser
//
//  Created by mac on 2016/6/18.
//  Copyright © 2016年 sww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWPhotoCell.h"
@class SWBrowserPhotoController;
@protocol SWPhotoBrowserDelegate <NSObject>
@optional
/**
 *  删除图片的代理
 *
 *  @param photoBrowser SWPhotoBrowser
 *  @param index        删除的的索引
 */
-(void)photoBrowser:(SWBrowserPhotoController *)photoBrowser deleteAtIndex:(NSInteger)index;

///**
// *  长按图片的代理
// *
// *  @param photoBrowser SWPhotoBrowser
// *  @param index        长按图片的索引
// *  @param image        长按的图片
// */
//
//- (void)didSelectImageWithLongPress:(SWBrowserPhotoController *)photoBrowser atIndex:(NSInteger)index image:(UIImage *)image;
///**
// *   点击图片的代理
// *
// *  @param photoBrowser SWPhotoBrowser
// *  @param index        长按图片的索引
// *  @param image        长按的图片
// */
//
//- (void)didSelectImage:(SWBrowserPhotoController *)photoBrowser atIndex:(NSInteger)index image:(UIImage *)image;
//



@end
@interface SWBrowserPhotoController : UIViewController
/**
 *  自定义初始化
 *
 *  @param photos 数据数组
 *
 *  @param containerView 承载图片的容器 UICollectionView ScrollView ImageView Button
 *
 *  @return SWBrowserPhotoController
 */
-(instancetype)initWithPhotos:(NSArray *)photos sourceImagesContainerView:(UIView *)containerView;
/**
 *  显示 如果显示不了 使用showInController:(UIViewController *)controller;
 */
-(void)show;
/**
 *  显示 如果当前在present的控制器上，show使用不显示 使用这个
 *
 *  @param controller 当前视图控制器
 */
-(void)showInController:(UIViewController *)controller;
/**
 *  图片源数组，可以是URL字符串数组，图片数组
 */
@property(nonatomic,strong)NSMutableArray *photos;
/**
 *  占位图片数组 可为空 通常网络图片可用小图站位 如果不用小图站位 数组中可只存一个本地展位图
 */
@property(nonatomic,strong)NSMutableArray *placeholderPhotos;
/**
 *  当前的图片位置
 */
@property(nonatomic,assign)NSInteger currentIndex;
/**
 *  是否显示删除按钮，通常是用于查看发送的图片的
 */
@property(nonatomic,assign)BOOL showDelete;

/**
 *  代理对象
 */
@property(nonatomic,weak)id<SWPhotoBrowserDelegate> delegate;
/**
 *  是否显示PageControl
 */
@property(nonatomic,assign)BOOL showPageControl;
/**
 *  是否显示位置标题
 */
@property(nonatomic,assign)BOOL showIndexTitle;
/**
 *  是否提前加载图片 设置图片前调用 默认为YES
 */
@property(nonatomic,assign)BOOL LoadingInAdvance;
/**
 *  是否允许保存图片 --长按保存
 */
@property(nonatomic,assign)BOOL allowSaveImage;
/**
 *  如果图片小于屏幕 是否填充显示
 */
@property (nonatomic,assign)BOOL FillTheSamllPic;
/**
 *  最大放大倍数 默认为2
 */
@property (nonatomic,assign)CGFloat maxZoomScale;
/**
 *  承载图片的容器 这里只可传UIScrollView和UICollectionView
 */
@property (nonatomic,strong)UIView *sourceImagesContainerView;

@end
