//
//  XCFMDB.m
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/26.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#import "XCFMDB.h"

@interface XCFMDB () <NSCopying, NSMutableCopying> {
    FMDatabase  *_db;
}

@end

@implementation XCFMDB

static XCFMDB *_sharedFMDB = nil;
+ (instancetype)sharedFMDB {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFMDB = [[XCFMDB alloc] init];
        [_sharedFMDB initDataBase];
    });
    return _sharedFMDB;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (_sharedFMDB == nil) {
        _sharedFMDB = [super allocWithZone:zone];
    }
    return _sharedFMDB;
}

- (id)copy {
    return self;
}

- (id)mutableCopy {
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}

- (void)initDataBase {
    NSString *document = kPathDocument;
    
    NSString *photoPath = [document stringByAppendingPathComponent:@"Photo.sqlite"];
    
    // initialize FMDataBase
    _db = [FMDatabase databaseWithPath:photoPath];
    
    if (![_db open]) {
        NSLog(@"db open fail!");
    };
    
    // initialize Table
    NSString *photoSql = @"CREATE TABLE IF NOT EXISTS Photo ('category' text, 'ID' text, 'smallimageurl' text, 'createdate' text, 'type' text, 'imageurl' text)";
    BOOL update = [_db executeUpdate:photoSql];
    if (!update) {
        NSLog(@"db create table fail!");
    }
    
    [_db close];
}

#pragma mark - add photo -
- (void)addPhoto:(XCPhotoModel *)photo {
    [_db open];
    
    BOOL update = [_db executeUpdate:@"INSERT INTO Photo(category, ID, smallimageurl, createdate, type, imageurl) VALUES (?, ?, ?, ?, ?, ?)", photo.category, photo.ID, photo.smallimageurl, photo.createdate, photo.type, photo.imageurl];
    if (!update) {
        NSLog(@"db add photo fail!");
    }
    
    [_db open];
}

#pragma mark - is photo exist
- (BOOL)isPhotoExist:(XCPhotoModel *)photo {
    [_db open];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM Photo"];
    while ([res next]) {
        NSString *smallimageurl = [res stringForColumn:@"smallimageurl"];
        NSString *imageurl = [res stringForColumn:@"imageurl"];
        if ([photo.smallimageurl isEqualToString:smallimageurl] &&
            [photo.imageurl isEqualToString:imageurl]) {
            
            [_db close];
            return YES;
        }
    }
    
    [_db close];
    return NO;
}

#pragma mark - delete photo -
- (void)removePhoto:(XCPhotoModel *)photo {
    [_db open];
    
    BOOL update = [_db executeUpdate:@"DELETE FROM Photo WHERE smallimageurl = ? and imageurl = ?", photo.smallimageurl, photo.imageurl];
    if (!update) {
        NSLog(@"db remove photo fail!");
    }
    
    [_db close];
}

#pragma mark - get all photos -
- (NSArray<XCPhotoModel *> *)getFavoritePhotos {
    [_db open];
    
    NSMutableArray<XCPhotoModel *> *photos = [NSMutableArray array];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM Photo"];
    while ([res next]) {
        XCPhotoModel *model = [[XCPhotoModel alloc] init];
        model.category = [res stringForColumn:@"category"];
        model.ID = [res stringForColumn:@"ID"];
        model.smallimageurl = [res stringForColumn:@"smallimageurl"];
        model.createdate = [res stringForColumn:@"createdate"];
        model.type = [res stringForColumn:@"type"];
        model.imageurl = [res stringForColumn:@"imageurl"];
        [photos addObject:model];
    }
    
    [_db close];
    return photos;
}

@end
