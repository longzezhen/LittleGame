//
//  UIImage+category.m
//  ThreeSandOcean
//
//  Created by 龙泽桢 on 2019/5/13.
//  Copyright © 2019 tools. All rights reserved.
//

#import "UIImage+category.h"

@implementation UIImage (category)
//压缩图片质量
+(UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength
{
    //1/(2^6) = 0.015625 < 0.02，也能达到每次循环 compression 减小 0.02 的效果。这样的压缩次数比循环减小 compression 少，耗时短
    CGFloat compression = 1;
    NSData * data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) {
        return image;
    }
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i<6; i++) {
        compression = (max + min)/2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength*0.9) {
            min = compression;
        }else if (data.length > maxLength){
            max = compression;
        }else{
            break;
        }
    }
    UIImage * resultImage = [UIImage imageWithData:data];
    return resultImage;
}

//压缩图片尺寸
+(UIImage *)compressImageSize:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

//view 颜色转image
+ (UIImage *)drawImageWithSize:(CGSize)size color:(UIColor *)color{
    
    UIImage *renderImage;
    UIView *renderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    renderView.backgroundColor = color;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [renderView.layer renderInContext:context];
    renderImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return renderImage;
    
}

//view 转image
+(UIImage *)convertViewToImage:(UIView *)view
{
    UIImage *imageRet = [[UIImage alloc]init];
    //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageRet;
}

//生成二维码（中间有图片）
+(UIImage *)createImageQRCodeWithString:(NSString *)QRString centerImage:(UIImage *)centerImage
{
    //创建滤镜对象
    CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复滤镜默认属性
    [filter setDefaults];
    //将字符串转换成NSData;
    NSData * data = [QRString dataUsingEncoding:kCFStringEncodingUTF8];
    //设置过滤器的输入值，KVC赋值
    [filter setValue:data forKey:@"inputMessage"];
    //获得滤镜输出的图像(27,27)
    CIImage * outImage = [filter outputImage];
    //调整图片大小
    outImage = [outImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    //将CIImage类型转成UIImage类型
    UIImage * startImage = [UIImage imageWithCIImage:outImage];
    if (!centerImage) {
        return startImage;
    }
    
    //开启绘图，获取图形上下文
    UIGraphicsBeginImageContext(startImage.size);
    //把二维码图片画上去（这里是以图形上下文，左上角为（0，0）点）
    [startImage drawInRect:CGRectMake(0, 0, startImage.size.width, startImage.size.height)];
    
    // 再把小图片画上去
    
    CGFloat center_imageW = 200;
    CGFloat center_imageH = 200;
    CGFloat center_imageX = (startImage.size.width - center_imageW) * 0.5;
    CGFloat center_imageY = (startImage.size.height - center_imageH) * 0.5;
    [centerImage drawInRect:CGRectMake(center_imageX, center_imageY, center_imageW, center_imageH)];
    // 获取当前画得的这张图片
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    //返回二维码图像
    return resultImage;
}
@end
