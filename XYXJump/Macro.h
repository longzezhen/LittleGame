//
//  Macro.h
//  XYXJump
//
//  Created by df on 2019/11/5.
//  Copyright © 2019 cons. All rights reserved.
//

#ifndef Macro_h
#define Macro_h
#define ColorRBG(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ColorRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define KFont(fSize)                  [UIFont systemFontOfSize:fSize]
#define KHeight [UIScreen mainScreen].bounds.size.height

#define KWidth [UIScreen mainScreen].bounds.size.width
#define ImageName(name) [UIImage imageNamed:name]
#define WEAKSELF typeof(self) __weak weakSelf = self
//屏幕比例
#define Auto_Width(a)       (((KScreenWidth)/(375))*(a))
#define Auto_Height(a)      (((KScreenHeight)/(667))*(a))
#define Klang(key)          NSLocalizedString(key,nil)

#define kDeviceHeight                       ([UIScreen mainScreen].bounds.size.height)
#define IS_IPHONEX          ((kDeviceHeight >= 812) ? (YES) : (NO))
#define KTopHeight   (IS_IPHONEX ? 24.f:0.f)
#endif /* Macro_h */
