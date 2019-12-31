//
//  JumpPayManager.h
//  DDZCJ
//
//  Created by jjj on 2019/9/18.
//  Copyright © 2019 df. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 苹果内购是否为沙盒测试账号,打开就代表为沙盒测试账号,注意上线时注释掉！！
#define APPSTORE_ASK_TO_BUY_IN_SANDBOX 1

typedef void(^applePayCompleteBlockBlock)(NSString *product_id, BOOL isSuccess);

@interface JumpPayManager : NSObject

+ (instancetype)sharedPayManager;

/// 苹果内购
- (void)requestAppleStoreProductWithProductId:(NSString *)productId applePayCompleteBlock:(applePayCompleteBlockBlock)payCompletionBlock;
/// 验证苹果支付订单凭证
- (void)checkApplePayResultWithBase64String:(NSString *)base64String;

@end

NS_ASSUME_NONNULL_END
