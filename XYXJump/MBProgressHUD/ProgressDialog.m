

#define FSDIALOGTIP_TAG 2103405
#define FSDIALOGTIP_IMG_TAG 2103406
#define FSDIALOGTIP_IMG_TAG_C 21034089


#define FSOPERATION__TAG 2103407
#define FSOPERATION__IMG_TAG 2103408

#import "ProgressDialog.h"
#import "Masonry.h"
#import <objc/runtime.h>


@implementation ProgressDialog

+ (void)createProgressDialog{
    
    UIView* tipShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    UIImageView* progressImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiaotou1"]];
    NSMutableArray *imageAnimations = [[NSMutableArray alloc] init];
    for (int i = 1; i < 8; i++) {
        [imageAnimations addObject:[UIImage imageNamed:[NSString stringWithFormat:@"xiaotou%d",i]]];
    }

    progressImgView.animationImages = imageAnimations;
    progressImgView.animationDuration = 1.2;
    progressImgView.frame = CGRectMake(0, 0, 28, 64);
    progressImgView.center = CGPointMake(tipShowView.frame.size.width/2, tipShowView.center.y-50);
    tipShowView.tag = FSDIALOGTIP_TAG;
    progressImgView.tag = FSDIALOGTIP_IMG_TAG;
    [tipShowView addSubview:progressImgView];
    
    UIImageView* progressImgViewC = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiaotou1"]];
    NSMutableArray *imageAnimationsC = [[NSMutableArray alloc] init];
    for (int i = 1; i < 8; i++) {
        [imageAnimationsC addObject:[UIImage imageNamed:[NSString stringWithFormat:@"xiaotou%d",i]]];
    }
    progressImgViewC.animationImages = imageAnimationsC;
    progressImgViewC.animationDuration = 1.2;
    progressImgViewC.frame = CGRectMake(0, 0, 28, 64);
    progressImgViewC.center = CGPointMake(tipShowView.frame.size.width/2, tipShowView.center.y-50);
    progressImgViewC.tag = FSDIALOGTIP_IMG_TAG_C;
    [tipShowView addSubview:progressImgViewC];
    
    tipShowView.backgroundColor = [UIColor clearColor];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:tipShowView];
    [tipShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([[[UIApplication sharedApplication] delegate] window]).mas_equalTo(0);
        make.left.equalTo([[[UIApplication sharedApplication] delegate] window]);
        make.right.equalTo([[[UIApplication sharedApplication] delegate] window]);
        make.bottom.equalTo([[[UIApplication sharedApplication] delegate] window]);
    }];
    tipShowView.hidden = YES;
    
}

+ (void)addProgressDialogDismissAfter:(NSTimeInterval)delay block:(void(^)())block{
    UIView* progressDialog = (UIView*)[[[[UIApplication sharedApplication] delegate] window] viewWithTag:FSDIALOGTIP_TAG];
    if (!progressDialog) {
        [self createProgressDialog];
        progressDialog = (UIView*)[[[[UIApplication sharedApplication] delegate] window] viewWithTag:FSDIALOGTIP_TAG];
    }
    UIImageView* progressImgView = (UIImageView*)[[[[UIApplication sharedApplication] delegate] window] viewWithTag:FSDIALOGTIP_IMG_TAG];
    UIImageView* progressImgViewC = (UIImageView*)[[[[UIApplication sharedApplication] delegate] window] viewWithTag:FSDIALOGTIP_IMG_TAG_C];
    if (progressDialog.isHidden) {
        [progressDialog setHidden:NO];
    }
  
    [[[[UIApplication sharedApplication] delegate] window] bringSubviewToFront:progressDialog];
    [progressImgView startAnimating];
    [progressImgViewC startAnimating];
    if (delay) {
        [self performSelector:@selector(removeProgressDialogWithBlock:) withObject:block afterDelay:delay];
    }
}

+ (void)removeProgressDialog{
    
    UIView* progressDialog = (UIView*)[[[[UIApplication sharedApplication] delegate] window] viewWithTag:FSDIALOGTIP_TAG];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeProgressDialog) object:nil];
    UIImageView* progressImgView = (UIImageView*)[[[[UIApplication sharedApplication] delegate] window] viewWithTag:FSDIALOGTIP_IMG_TAG];
    UIImageView* progressImgViewC = (UIImageView*)[[[[UIApplication sharedApplication] delegate] window] viewWithTag:FSDIALOGTIP_IMG_TAG_C];
    [progressImgView stopAnimating];
    [progressImgViewC stopAnimating];
    [progressDialog setHidden:YES];

}

+ (void)removeProgressDialogWithBlock:(void(^)())block{
    [self removeProgressDialog];
    if (block) {
        block();
    }
}

+ (void)addProgressDialog{
    
    [self addProgressDialogDismissAfter:0 block:nil];
}




@end
