//
//  MBProgressHUD+PD.h
//  DDZCJ
//
//  Created by jjj on 2019/9/16.
//  Copyright © 2019 df. All rights reserved.
//

#import "MBProgressHUD.h"

@class MBProgressHUD;

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (PD)

+ (void)showText:(NSString *)text toView:(UIView *)view;

+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
