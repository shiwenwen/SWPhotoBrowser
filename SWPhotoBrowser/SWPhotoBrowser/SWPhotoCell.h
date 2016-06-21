//
//  SWPhotoCell.h
//  SWPhotoBrowser
//
//  Created by mac on 2016/6/18.
//  Copyright © 2016年 sww. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
typedef void(^SingleBlock)(void);
@interface SWPhotoCell : UICollectionViewCell
/**
 *  图片视图
 */
@property(nonatomic,strong)UIImageView *imageView;
/**
 *  图片URL
 */
@property(nonatomic,copy)NSString *imageUrl;
/**
 *  图片
 */
@property(nonatomic,strong)UIImage *image;
/**
 *  最大放大倍数 默认为2
 */
@property (nonatomic,assign)CGFloat maxScale;
/**
 *  占位图
 */
@property (nonatomic,strong)UIImage *placeholderImage;
/**
 *  展位图URL 一般为小图的URL小图一般已经加载好
 */
@property (nonatomic,strong)NSString *placeholderImageUrl;
/**
 *  单击的block
 */
@property (nonatomic,copy)SingleBlock singleBlock;
/**
 *  是否允许保存图片 --长按保存
 */
@property(nonatomic,assign)BOOL allowSaveImage;
/**
 *  恢复大小
 */
-(void)restoreTheSize;
/**
 *  如果图片小于屏幕 是否填充显示
 */
@property (nonatomic,assign)BOOL FillTheSamllPic;


@end
