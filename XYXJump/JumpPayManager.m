//
//  JumpPayManager.m
//  DDZCJ
//
//  Created by jjj on 2019/9/18.
//  Copyright © 2019 df. All rights reserved.
//

#import "JumpPayManager.h"
#import <StoreKit/StoreKit.h>

@interface JumpPayManager ()<SKPaymentTransactionObserver, SKProductsRequestDelegate>
// 苹果内购
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) applePayCompleteBlockBlock applePayCompleteBlock;

@end

@implementation JumpPayManager


+ (instancetype)sharedPayManager {
    static JumpPayManager *payManager;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        payManager = [[JumpPayManager alloc] init];
        // 注册苹果内购
        [[SKPaymentQueue defaultQueue] addTransactionObserver:payManager];
        
    });
    return payManager;
}

- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}


#pragma mark - 苹果支付充值
//请求商品
- (void)requestAppleStoreProductWithProductId:(NSString *)productId applePayCompleteBlock:(applePayCompleteBlockBlock)payCompletionBlock {
    if(![SKPaymentQueue canMakePayments]) {
        [MBProgressHUD showText:Klang(@"This device does not support Apple Pay！") toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    self.applePayCompleteBlock = payCompletionBlock;
    self.productId = productId;
    
    NSArray *product = [[NSArray alloc] initWithObjects:productId, nil];
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
}

//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *productArray = response.products;
    if([productArray count] == 0){
        NSLog(@"--------------没有商品------------------");
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[productArray count]);
    
    SKProduct *product = nil;
    for (SKProduct *pro in productArray) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        
        if([pro.productIdentifier isEqualToString:self.productId]){
            product = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------错误-----------------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------");
}

//交易结果
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
                //交易完成
            case SKPaymentTransactionStatePurchased: {
                NSLog(@"交易完成-restoreCompletedTransactions");
                /* your code */
                [self buyAppleStoreProductSucceedWithPaymentTransactionp:transaction];
                
                [self completeTransaction:transaction];
                
                self.applePayCompleteBlock(self.productId, YES);
                
                break;
            }
                //交易失败
            case SKPaymentTransactionStateFailed: {
                NSLog(@"交易失败");
                /* your code */
                [self completeTransaction:transaction];
                
                self.applePayCompleteBlock(@"", NO);
                
                break;
            }
                //已经购买过该商品
            case SKPaymentTransactionStateRestored: {
                NSLog(@"已经购买过商品");
//                [self restoreTransaction:transaction];
//                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
                //商品添加进列表
            case SKPaymentTransactionStatePurchasing: {
                NSLog(@"商品添加进列表");
                break;
            }
            default: {
                NSLog(@"transactionState: %ld", (long)transaction.transactionState);
                break;
            }
        }
    }
}


// 苹果内购支付成功
- (void)buyAppleStoreProductSucceedWithPaymentTransactionp:(SKPaymentTransaction *)paymentTransactionp {
    
    /* 获取相应的凭据，并做 base64 编码处理 */
    NSString *base64ResultStr = [paymentTransactionp.transactionReceipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//    NSLog(@"苹果内购凭据号\n\n\n\n\n\n%@\n\n\n\n\n\n",base64Str);
    [self checkApplePayResultWithBase64String:base64ResultStr];
}


- (void)checkApplePayResultWithBase64String:(NSString *)base64String {
    
    /* 生成订单参数，注意沙盒测试账号与线上正式苹果账号的验证途径不一样，要给后台标明 */
    NSNumber *sandbox;
#if (defined(APPSTORE_ASK_TO_BUY_IN_SANDBOX) && defined(DEBUG))
    sandbox = @(0);
#else
    sandbox = @(1);
#endif
    
    NSMutableDictionary *prgam = [[NSMutableDictionary alloc] init];;
    [prgam setValue:sandbox forKey:@"sandbox"];
    [prgam setValue:base64String forKey:@"reciept"];
    
    /*
     请求后台接口，服务器处验证是否支付成功，依据返回结果做相应逻辑处理
     */
    [self verifyApplePayResult];
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}


#pragma mark 客户端验证购买凭据
- (void)verifyApplePayResult{
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    // 传输的是BASE64编码的字符串
    /**
     BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
     BASE64是可以编码和解码的
     */
    NSDictionary *requestContents = @{
                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0]
                                      };
    NSError *error;
    // 转换为 JSON 格式
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
    // 不存在
    if (!requestData) { /* ... Handle error ... */ }
    
    // 发送网络POST请求，对购买凭据进行验证
    NSString *verifyUrlString;
#if (defined(APPSTORE_ASK_TO_BUY_IN_SANDBOX) && defined(DEBUG))
    verifyUrlString = @"https://sandbox.itunes.apple.com/verifyReceipt";
#else
    verifyUrlString = @"https://buy.itunes.apple.com/verifyReceipt";
#endif
    // 国内访问苹果服务器比较慢，timeoutInterval 需要长一点
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:verifyUrlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    // 在后台对列中提交验证请求，并获得官方的验证JSON结果
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   NSLog(@"链接失败");
                               } else {
                                   NSError *error;
                                   NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   if (!jsonResponse) {
                                       NSLog(@"验证失败");
                                   }
                                   
                                   // 比对 jsonResponse 中以下信息基本上可以保证数据安全
                                   /*
                                    bundle_id
                                    application_version
                                    product_id
                                    transaction_id
                                    */
                                   
                                   NSLog(@"验证成功");
                               }
                           }];
    
}


@end
