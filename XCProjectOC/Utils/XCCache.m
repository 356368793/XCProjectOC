//
//  XCCache.m
//  XCProjectOC
//
//  Created by xiaochen on 2018/3/20.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCCache.h"

@interface XCCache ()

@property (copy, nonatomic) NSString *fileCachePath;

@end

@implementation XCCache

- (NSString *)getCacheString {
    //获取文件管理器对象
    NSFileManager * fileManger = [NSFileManager defaultManager];
    //获取缓存沙盒路径
    NSString * cachePath = kPathCache;
    //拼接缓存文件夹路径
    NSString * fileCachePath = cachePath; // [cachePath stringByAppendingPathComponent:@"缓存文件夹（非全路径）"];
    //将缓存文件夹路径赋值给成员属性(后面删除缓存文件时需要用到)
    self.fileCachePath = fileCachePath;
    //通过缓存文件路径创建文件遍历器
    NSDirectoryEnumerator * fileEnumrator = [fileManger enumeratorAtPath:fileCachePath];
    //先定义一个缓存目录总大小的变量
    long long fileTotalSize = 0;
    for (NSString * fileName in fileEnumrator) {
        //拼接文件全路径（注意：是文件）
        NSString * filePath = [fileCachePath stringByAppendingPathComponent:fileName];
        //获取文件属性
        NSDictionary * fileAttributes = [fileManger attributesOfItemAtPath:filePath error:nil];
        //根据文件属性判断是否是文件夹（如果是文件夹就跳过文件夹，不将文件夹大小累加到文件总大小）
        if ([fileAttributes[NSFileType] isEqualToString:NSFileTypeDirectory])
            continue;
        //获取单个文件大小,并累加到总大小
        fileTotalSize += [fileAttributes[NSFileSize] integerValue];
    }
    //将字节大小转为MB，然后传出去
    return [self stringWithFileSize:fileTotalSize];
}

- (NSString*)stringWithFileSize:(unsigned long long)size {
    if (size == 0) {
        return @"无缓存";
    } else if (size < 1000) {
        return [NSString stringWithFormat:@"%lluB", size];
    } else if(size < 1024 * 1024) {
        return [NSString stringWithFormat:@"%.2fKB", size / 1024.0];
    } else if(size < 1024 * 1024 * 1024) {
        return [NSString stringWithFormat:@"%.2fMB", size / (1024.0 * 1024)];
    } else if(size < 1024 * 1024 * 1024 * 1024ull) {
        return [NSString stringWithFormat:@"%.2fGB", size / (1024.0 * 1024 * 1024)];
    } else {
        return [NSString stringWithFormat:@"%.2fTB", size / (1024.0 * 1024 * 1024 * 1024)];
    }
}

- (void)removeCache {
    [[NSFileManager defaultManager] removeItemAtPath:self.fileCachePath error:nil];
}

@end
