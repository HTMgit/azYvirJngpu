//
//  ZYHCommonService.h
//  SmartHome
//
//  Created by 周宇航 on 2016/11/29.
//  Copyright © 2016年 gtscn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^SHResultObjectBlock)(id result, NSError * error);
typedef void (^SHResultBlock)(BOOL succeeded, NSError *error);
typedef void (^SHResultArrayBlock)(NSArray *results, NSError *error);


@interface ZYHCommonService : NSObject

//获取wifi
+ (NSString *)fetchSsid;

//颜色转换成图片
+(UIImage*) createImageWithColor:(UIColor*) color;

#pragma mark 时间
//UTC时间格式转化
+ (NSDate *)htcTimeToLocationDate:(NSString*)strM;

+ (NSString *)stringFromDate:(NSString *)dateStr dateFormat:(NSString *)dateFormat;

//时间戳 转化 字符串
+(NSString *)stringFromDate:(NSString *)dateStr;
// 字符串 转化 nsdate
+(NSDate *)nsdateFromString:(NSString *)dateStr WithFormat:(NSString*)format;

// nsdate 转化 字符串
+ (NSString *)stringFromDateWithDate:(NSDate *)date formatStr:(NSString *)formatStr;
//判断两个nsdate大小，NSDateComponents>0未前者大
+(NSDateComponents *)nsdateIsBiggerThanLastNsdateWithFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate;

//根据str 或者date 获取这一天是周几
+(NSString *)getWeekendfromStr:(NSString *)str formatter:(NSString *)formatter orDate:(NSDate*)date;

//返回间隔时间
/* type 1:天数
 *2:小时
 *3:分钟
 * beginDate减endDate;
 */
+(long)timeDifferentNum:(NSDate*)beginDate endDate:(NSDate*)endDate type:(int)type;



//手机号验证
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (NSDictionary *)dictionaryWithString:(NSString *)jsonString sectionStr:(NSString *)sectionStr rowStr:(NSString *)rowStr;

#pragma mark md5
//md5加密
+ (NSString *)md5:(NSString *)str;
+ (NSString *)md5To16Str:(NSString *)str;
+(NSString *)md5ToChar:(const char *)original_str;
+ (NSString*)getMD5WithData:(NSData *)data;

#pragma mark Json
+ (NSDictionary *)DictionaryWithJsonString:(NSString *)jsonString;


#pragma mark 压缩图片质量
+ (UIImage *)reduceImage:(UIImage *)image percent:(float)percent;
#pragma mark 文字

+(void)showMakeToastView:(NSString *)str;
    
/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result float 返回的高度
 titleLabelWidth为预设文字的长度，即UILable的宽度；9999为文字的最大高度，设置一个非常大的数可根据文字的高度显示。options参数为NSStringDrawingUsesLineFragmentOrigin，那么整个文本将以每行组成的矩形为单位计算整个文本的尺寸。attributes：后传入字典，可设置文字的多个属性，这里只设置文字大小。context为上下文置空即可。
 */
+ (float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width ;

//返回Yes -字符串为空，
+ (BOOL)isBlankString:(NSString *)string;

// AlreadyIndex == -1 叠加   == 0 重0开始
+ (NSString *)resultObjectId:(NSString*)mId;


//根据类型返回1-light,2-dimmer,3-curtain 0-没有
+(int)getDeviceNumWithType:(NSString *)type;


//POST请求
+(void)createASIFormDataRequset:(NSString *)urlStr
                          param:(NSDictionary*)param
                     completion:(SHResultObjectBlock)completion;

+(void)upDataImgWithImage:(UIImage *)image requesetUrl:(NSString *)requesetUrl imageType:(NSString *)type completion:(SHResultObjectBlock)completion;

+(void)upDataImgWithImage2:(UIImage *)image requesetUrl:(NSString *)requesetUrl imageType:(NSString *)type completion:(SHResultObjectBlock)completion;

+(void)doUpLoad:(NSString *)url param:(NSDictionary *)dic data:(NSData *)data type:(NSString *)type name:(NSString *)name fileName:(NSString *)fileName completion:(SHResultObjectBlock)completion;
@end
