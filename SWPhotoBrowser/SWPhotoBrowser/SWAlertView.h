//
//  SWAlertView.h
//  SWPhotoBrowser
//
//  Created by mac on 2016/6/18.
//  Copyright © 2016年 sww. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SWAlertViewStyle) {
    SWAlertViewStyleSuccess,
    SWAlertViewStyleError
};

@interface SWAlertView : UIView
/** 1.风格类型 */
@property (nonatomic, assign)SWAlertViewStyle style;
/** 2.显示 */
- (void)show;
@end
