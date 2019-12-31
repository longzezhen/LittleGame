//
//  UIImage+category.h
//  ThreeSandOcean
//
//  Created by 龙泽桢 on 2019/5/13.
//  Copyright © 2019 tools. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIImage (category)
//压缩图片质量
+(UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength;
//压缩图片尺寸
+(UIImage *)compressImageSize:(UIImage *)image toSize:(CGSize)size;
//view颜色转image
+ (UIImage *)drawImageWithSize:(CGSize)size color:(UIColor *)color;
//view转image
+(UIImage *)convertViewToImage:(UIView *)view;
//生成二维码（中间有图片）
+(UIImage *)createImageQRCodeWithString:(NSString *)QRString centerImage:(UIImage *)centerImage;
@end


