//
//  NMGlobDefine.h
//  nmLiveWatch
//
//  Created by zyh on 2017/10/30.
//  Copyright © 2017年 zyh. All rights reserved.
//

#ifndef NMGlobDefine_h
#define NMGlobDefine_h




#define TEXTFONT 13
#define WECHATLOGIN @"wx522f1b9a1aa882e1"
#define SYSTEMCOlOR [UIColor orangeColor]
//用户登陆地址
#define REQUESTURL @"http://116.62.11.8/stlive"

//----------------------------------颜色--------------------------------------{
#define fRgbColor(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1]
#define fRgbaColor(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]
#define fHexColor(hex)                                                                                                                                         \    [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]
//----------------------------------颜色--------------------------------------}
//----------------------------------分辨率--------------------------------------{
//设备屏宽
#define kNMDeviceWidth [[UIScreen mainScreen] bounds].size.width
// 设备屏高
#define kNMDeviceHeight [[UIScreen mainScreen] bounds].size.height

#endif /* NMGlobDefine_h */
