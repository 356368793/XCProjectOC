//
//  NetworkDefine.h
//  LiveWallpapers
//
//  Created by xiaochen on 2018/3/21.
//  Copyright © 2018年 xiaochen. All rights reserved.
//

#ifndef NetworkDefine_h
#define NetworkDefine_h

#define XC @"http://s.fastcleanerme.com/v3/wallpaper/"
#define avc @"?avc=1"

#define URLWallpaperCategory  (XC @"Getwpcategory" avc)// category list

#define URLAddList   (XC @"Getaddlist" avc)// add list
#define URLPopList (XC @"Getpoplist" avc)// pop list
#define URLCategoryImgList   (XC @"Getwpcgimg" avc)// category images
#define URLAllList  (XC @"Getwallpaper" avc)// all list

#define URLAudit @"http://m.gglowb.com/v3/wallpaper/Getversioninfo?avc=1" // (XC @"Getversioninfo" avc)

#endif /* NetworkDefine_h */
