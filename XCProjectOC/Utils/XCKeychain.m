//
//  XCKeychain.m
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/23.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCKeychain.h"

@implementation XCKeychain

+ (NSMutableDictionary *)getKeychinaQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:(id)kSecClassGenericPassword, (id)kSecClass, service, (id)kSecAttrService, service, (id)kSecAttrAccount, (id)kSecAttrAccessibleAfterFirstUnlock, (id)kSecAttrAccessible, nil];
}

#pragma mark -- 写入
+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keyChinaQuery = [self getKeychinaQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keyChinaQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keyChinaQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keyChinaQuery, NULL);
}
#pragma mark -- 读取
+ (id)load:(NSString *)service {
    
    id ret = nil;
    NSMutableDictionary *keychinaQuery = [self getKeychinaQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychinaQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychinaQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychinaQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
    
}
#pragma mark -- 删除
+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychinaQuery = [self getKeychinaQuery:service];
    SecItemDelete((CFDictionaryRef)keychinaQuery);
}

@end
