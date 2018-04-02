//
//  XCIAPManager.m
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/24.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCIAPManager.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"

#define kReceiptPassword @""

@interface XCIAPManager () <SKPaymentTransactionObserver,SKProductsRequestDelegate>

@property (copy, nonatomic) NSString *purchID;
@property (copy, nonatomic) IAPCompletionHandle handle;

@end

@implementation XCIAPManager

static XCIAPManager *_sharedManager = nil;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[XCIAPManager alloc] init];
        // 购买监听写在程序入口,程序挂起时移除监听,这样如果有未完成的订单将会自动执行并回调 paymentQueue:updatedTransactions:方法
        [[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedManager];
    });
    return _sharedManager;
}

- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [SVProgressHUD dismiss];
}

#pragma mark - Public Method
/// 开始购买
- (void)startPurchWithID:(NSString *)purchID completeHandle:(IAPCompletionHandle)handle{
    [SVProgressHUD showProgress:-1 status:@"Loading Subscription Info"];
    if (purchID) {
        if ([SKPaymentQueue canMakePayments]) {
            // 开始购买服务
            self.purchID = purchID;
            self.handle = handle;
            NSSet *nsset = [NSSet setWithArray:@[purchID]];
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
            request.delegate = self;
            [request start];
        }else{
            [self handleActionWithType:kIAPPurchNotArrow data:nil];
        }
    }
}


/// 恢复购买
- (void)restoreTransaction {
    [SVProgressHUD showProgress:-1 status:@"Restoring..."];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - Private Method
//最终退出口
- (void)handleActionWithType:(IAPPurchType)type data:(NSData *)data{
#if DEBUG
    switch (type) {
        case kIAPPurchSuccess:
            NSLog(@"购买成功");
            [SVProgressHUD showSuccessWithStatus:@"Subscribe Success"];
            break;
        case kIAPPurchFailed:
            NSLog(@"购买失败");
            [SVProgressHUD showErrorWithStatus:@"Subscribe Failure"];
            break;
        case kIAPPurchCancle:
            NSLog(@"用户取消购买");
            [SVProgressHUD showErrorWithStatus:@"Cancel Subscribe"];
            break;
        case KIAPPurchVerFailed:
            NSLog(@"订单校验失败");
            [SVProgressHUD showErrorWithStatus:@"Check Failure"];
            break;
        case KIAPPurchVerSuccess:
            NSLog(@"订单校验成功");
            [SVProgressHUD showSuccessWithStatus:@"Check Success"];
            break;
        case kIAPPurchNotArrow:
            NSLog(@"不允许程序内付费");
            [SVProgressHUD showErrorWithStatus:@"No procedures are allowed to pay"];
            break;
        default:
            break;
    }
#endif
    [SVProgressHUD dismiss];
    if(self.handle){
        self.handle(type,data);
    }
}
// 交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"completeTransaction~");
    [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:NO Compl:^(NSDate *currentDate) {
        
    }];
}

// 交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [self handleActionWithType:kIAPPurchFailed data:nil];
    }else{
        [self handleActionWithType:kIAPPurchCancle data:nil];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [SVProgressHUD dismiss];
}

- (void)verifyPurchaseWithPaymentTransaction:(SKPaymentTransaction *)transaction isTestServer:(BOOL)flag Compl:(void (^)(NSDate *))compl{
    //交易验证
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
    
    if(!receipt){
        // 交易凭证为空验证失败
        [self handleActionWithType:KIAPPurchVerFailed data:nil];
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        return;
    }
    // 购买成功将交易凭证发送给服务端进行再次校验
    //    [self handleActionWithType:kIAPPurchSuccess data:receipt];
    
    NSError *error;
    NSDictionary *requestContents = @{
                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0],
                                      @"password": kReceiptPassword
                                      };
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
    
    if (!requestData) { // 交易凭证为空验证失败
        [self handleActionWithType:KIAPPurchVerFailed data:nil];
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        return;
    }
    
    //In the test environment, use https://sandbox.itunes.apple.com/verifyReceipt
    //In the real environment, use https://buy.itunes.apple.com/verifyReceipt
    
    NSString *serverString = @"https://buy.itunes.apple.com/verifyReceipt";
    if (flag) {
        serverString = @"https://sandbox.itunes.apple.com/verifyReceipt";
    }
    NSURL *storeURL = [NSURL URLWithString:serverString];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:storeRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (error) {
            // 无法连接服务器,购买校验失败
            [self handleActionWithType:KIAPPurchVerFailed data:nil];
        } else {
            NSError *error;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (!jsonResponse) {
                // 苹果服务器校验数据返回为空校验失败
                [self handleActionWithType:KIAPPurchVerFailed data:nil];
            }
            
            // 先验证正式服务器,如果正式服务器返回21007再去苹果测试服务器验证,沙盒测试环境苹果用的是测试服务器
            NSString *status = [NSString stringWithFormat:@"%@",jsonResponse[@"status"]];
            if (status && [status isEqualToString:@"21007"]) {
                [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:YES Compl:^(NSDate *currentDate) {
                    
                }];
            }else if(status && [status isEqualToString:@"0"]){
                [self handleActionWithType:KIAPPurchVerSuccess data:nil];
                
                //  验证成功，保存最新的过期时间
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[self expirationDateFromResponse:jsonResponse] forKey:@"expires_date"];
                [userDefaults setObject:[self getCurrentDateFromResponse:jsonResponse] forKey:@"receipt_creation_date"];
                [userDefaults synchronize];
            }else{
                [self handleActionWithType:kIAPPurchFailed data:data];
            }
            NSLog(@"----验证结果 %@",jsonResponse);
        }
    }] resume];
    
    // 验证成功与否都注销交易,否则会出现虚假凭证信息一直验证不通过,每次进程序都得输入苹果账号
    if (transaction) {
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

- (BOOL)verifyPurchaseWithPaymentTransaction:(SKPaymentTransaction *)transaction isTestServer:(BOOL)flag{
    //交易验证
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
    
    if(!receipt){
        // 交易凭证为空验证失败
        return NO;
    }
    NSError *error;
    NSDictionary *requestContents = @{
                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0],
                                      @"password"    : kReceiptPassword
                                      };
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents options:0 error:&error];
    
    if (!requestData) { // 交易凭证为空验证失败
        return NO;
    }
    
    //In the test environment, use https://sandbox.itunes.apple.com/verifyReceipt
    //In the real environment, use https://buy.itunes.apple.com/verifyReceipt
    NSString *serverString = @"https://buy.itunes.apple.com/verifyReceipt";
    if (flag) {
        serverString = @"https://sandbox.itunes.apple.com/verifyReceipt";
    }
    NSURL *storeURL = [NSURL URLWithString:serverString];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    NSURLResponse *resp;
    NSError *sessionErr;
    NSData *backData = [self sendSynchronousRequest:storeRequest returningResponse:&resp error:&sessionErr];
    if (sessionErr) {
        return NO;
    } else {
        NSError *error;
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:backData options:0 error:&error];
        if (!jsonResponse) {
            // 苹果服务器校验数据返回为空校验失败
            return NO;
        }
        
        // 先验证正式服务器,如果正式服务器返回21007再去苹果测试服务器验证,沙盒测试环境苹果用的是测试服务器
        NSString *status = [NSString stringWithFormat:@"%@",jsonResponse[@"status"]];
        if (status && [status isEqualToString:@"21007"]) {
            return [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:YES];
        }else if(status && [status isEqualToString:@"0"]){
            //  验证成功，保存最新的过期时间
            NSDate *currentDate = [self getCurrentDateFromResponse:jsonResponse];
            NSDate *expiresDate = [self expirationDateFromResponse:jsonResponse];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:expiresDate forKey:@"expires_date"];
            [userDefaults setObject:currentDate forKey:@"receipt_creation_date"];
            [userDefaults synchronize];
            if (currentDate&&expiresDate&&([[currentDate earlierDate:expiresDate] compare:currentDate]==NSOrderedSame)) {
                [SVProgressHUD showSuccessWithStatus:@"Authentication is Successful"];
                SharedAppDelegate.isPayed=YES;
            }
            [self handleActionWithType:KIAPPurchVerSuccess data:nil];
            return currentDate&&expiresDate&&([[currentDate earlierDate:expiresDate] compare:currentDate]==NSOrderedSame);
        }else{
            return NO;
        }
    }
    return NO;
}

#pragma mark ----------> SKProductsRequestDelegate
// 收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *product = response.products;
    if([product count] <= 0){
        NSLog(@"--------------No Products------------------");
        return;
    }
    
    SKProduct *p = nil;
    for(SKProduct *pro in product){
        if([pro.productIdentifier isEqualToString:self.purchID]){
            p = pro;
            break;
        }
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[product count]);
    NSLog(@"%@",[p description]);
    NSLog(@"%@",[p localizedTitle]);
    NSLog(@"%@",[p localizedDescription]);
    NSLog(@"%@",[p price]);
    NSLog(@"%@",[p productIdentifier]);
    NSLog(@"发送购买请求");
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------Error-----------------:%@", error);
    [self handleActionWithType:kIAPPurchFailed data:nil];
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------Request did Finish-----------------");
}

#pragma mark --------> SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [SVProgressHUD showProgress:-1 status:@"Paying"];
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                // 消耗型不支持恢复购买
                //                [self completeTransaction:tran];
//                [self verifyPurchaseWithPaymentTransaction:tran isTestServer:NO];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:tran];
                break;
            default:
                break;
        }
    }
}


- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    [SVProgressHUD dismiss];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD showSuccessWithStatus:@"Restore succeed!"];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    [SVProgressHUD dismiss];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD showSuccessWithStatus:@"Restore succeed!"];
}

#pragma mark - date   setting
- (NSDate *)expirationDateFromResponse:(NSDictionary *)jsonResponse {
    NSArray* receiptInfo = jsonResponse[@"latest_receipt_info"];
    if(receiptInfo){
        NSDictionary* lastReceipt = receiptInfo.lastObject;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss VV";
        
        NSDate* expirationDate  = [formatter dateFromString:lastReceipt[@"expires_date"]];
        
        return expirationDate;
    } else {
        return nil;
    }
}
- (NSDate *)getCurrentDateFromResponse:(NSDictionary *)jsonResponse{
    
    NSDictionary* receipt = jsonResponse[@"receipt"];
    if(receipt){
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss VV";
        
        NSDate* expirationDate  = [formatter dateFromString:receipt[@"receipt_creation_date"]];
        
        return expirationDate;
    } else {
        return nil;
    }
}


#pragma mark - session sys
- (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error

{
    NSError __block *err = NULL;
    NSData __block *data;
    BOOL __block reqProcessed = false;
    NSURLResponse __block *resp;
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable _data, NSURLResponse * _Nullable _response, NSError * _Nullable _error) {
        resp = _response;
        err = _error;
        data = _data;
        reqProcessed = true;
    }] resume];
    
#pragma mark - 等待执行语句？？？ -
    while (!reqProcessed) {
        [NSThread sleepForTimeInterval:0];
    }
    *response = resp;
    *error = err;
    return data;
}

@end
