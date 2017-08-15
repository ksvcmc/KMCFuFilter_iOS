//
//  macro.h
//  KMCShortVideoDemo
//
//  Created by ksyun on 2017/6/22.
//  Copyright © 2017年 ksyun. All rights reserved.
//

#ifndef macro_h
#define macro_h

#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

#define kScreenSizeHeight (SCREEN_SIZE.height)
#define kScreenSizeWidth (SCREEN_SIZE.width)
#define kalgoHeight 49
#define kEffectCFGViewHeight 140
#define kStartButtonCenterY kScreenSizeHeight-(36+kalgoHeight+35)
#define kStartButtonPopCenterY kScreenSizeHeight-(36+kalgoHeight+35+kEffectCFGViewHeight)

#define FONT(value) [UIFont systemFontOfSize:value]
#define kBeautyCFGViewHideFrame CGRectMake(0, kScreenSizeHeight, kScreenSizeWidth, kEffectCFGViewHeight)
#define kBeautyCFGViewShowFrame CGRectMake(0, kScreenSizeHeight - kEffectCFGViewHeight- kalgoHeight, kScreenSizeWidth, kEffectCFGViewHeight)

#define kStartViewHideFrame CGRectMake(0, kScreenSizeHeight, kScreenSizeWidth, kEffectCFGViewHeight)
#define kStartViewShowFrame CGRectMake(0, kScreenSizeHeight - kEffectCFGViewHeight- kalgoHeight, kScreenSizeWidth, kEffectCFGViewHeight)

#define RGBCOLOR(r,g,b)                      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define kWhiteColor         RGBCOLOR(255,255,255)

#define KFilterCellHeight 140
#define KFilterCellWidth 63
#define kFilterSpaceWidth 17
#define kEffectNum  6

#define WeakObj(o) autoreleasepool{} __weak typeof(o) weak##o = o;
#define kGetAkURI       @"https://kmc.api.ksyun.com?APIAction=GetAuthInfo&Action=GetDemoAKSign&Version=2017-05-31"

#define buttonCount 3

#endif /* macro_h */
