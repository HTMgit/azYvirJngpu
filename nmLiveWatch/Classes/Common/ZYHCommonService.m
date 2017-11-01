//
//  ZYHCommonService.m
//  SmartHome
//
//  Created by 周宇航 on 2016/11/29.
//  Copyright © 2016年 gtscn. All rights reserved.
//

#import "ZYHCommonService.h"
#import "SBJsonWriter.h"
#import "AFNetworking.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CommonCrypto/CommonDigest.h>

@implementation ZYHCommonService
 static  NSDictionary * dicError;
static NSInteger rIndex = 0; //已用数字包存

#pragma mark - 获取wifi
+ (NSString *)fetchSsid {
    // TODO:切换wifi在返回此界面，wifi不能自动更换
    NSDictionary *ssidInfo = [self fetchSSIDInfo];
    return [ssidInfo objectForKey:@"SSID"];
    
}

// refer to http://stackoverflow.com/questions/5198716/iphone-get-ssid-without-private-library
+ (NSDictionary *)fetchSSIDInfo {
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    //    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        //        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return SSIDInfo;
}

+(UIImage*) createImageWithColor:(UIColor*) color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (NSString *)stringFromDateWithDate:(NSDate *)date formatStr:(NSString *)formatStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    if (!formatStr) {
        formatStr=@"yyyy-MM-dd HH:mm:ss";
    }
    [dateFormatter setDateFormat:formatStr];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}

+(NSString *)stringFromDate:(NSString *)dateStr {
    if(dateStr.length>=10){
         dateStr = [dateStr substringToIndex:10];
    }
    NSTimeInterval timeInterval = [dateStr longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *d = [cal components:unitFlags fromDate:[NSDate date] toDate:date options:0];
    long hour = [d year];
    if (hour > 90) {
        return @"永久";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

+(NSDate *)nsdateFromString:(NSString *)dateStr WithFormat:(NSString*)format{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    if (!format) {
        format=@"YYYY-MM-dd HH:mm:ss";
    }
    [formater setDateFormat:format];
    NSDate* date = [formater dateFromString:dateStr];
    return date;
}

+ (NSDate *)htcTimeToLocationDate:(NSString*)strM
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDate *dateFormatted = [dateFormatter dateFromString:strM];
    return dateFormatted;
}

+ (NSString *)stringFromDate:(NSString *)dateStr dateFormat:(NSString *)dateFormat{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDate *dateFormatted = [dateFormatter dateFromString:dateStr];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:dateFormat];
    NSString *daStr = [dateFormatter2 stringFromDate:dateFormatted];
    return daStr;
}

+(NSDateComponents *)nsdateIsBiggerThanLastNsdateWithFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate{
    
//    firstDate = [firstDate substringToIndex:10];
//    lastDate = [lastDate substringToIndex:10];
//    
//    NSTimeInterval bindTimeInterval = [bind longLongValue];
//    NSTimeInterval endTimeInterval = [end longLongValue];
//    
//    NSDate *bindDate = [NSDate dateWithTimeIntervalSince1970:bindTimeInterval];
//    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTimeInterval];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *d = [cal components:unitFlags fromDate:firstDate toDate:lastDate options:0];
    return  d;
}

//根据str 或者date 获取这一天是周几
+(NSString *)getWeekendfromStr:(NSString *)str formatter:(NSString *)formatter orDate:(NSDate*)date{
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (!date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        if (!formatter) {
            formatter=@"YYYY-MM-dd";
        }
        [dateFormatter setDateFormat:formatter];
        date=[dateFormatter dateFromString:str];
    }
    
    [dateFormatter setDateFormat:@"EEE"];
    
//    NSString *string = [dateFormatter stringFromDate:date];//  string为  周日
    
    [dateFormatter setDateFormat:@"e"];
    
    NSString *string1 = [dateFormatter stringFromDate:date]; //string1 为 1
    int weeekend=[string1 intValue]-1;
    if (weeekend==1) {
        return @"周一";
    }else if (weeekend==2) {
        return @"周二";
    }else if (weeekend==3) {
        return @"周三";
    }else if (weeekend==4) {
        return @"周四";
    }else if (weeekend==5) {
        return @"周五";
    }else if (weeekend==6) {
        return @"周六";
    }else if (weeekend==0) {
        return @"周日";
    }
    return @"";
}


//返回间隔时间
+(long)timeDifferentNum:(NSDate*)beginDate endDate:(NSDate*)endDate type:(int)type{
    
    NSTimeInterval time = [beginDate timeIntervalSinceDate:endDate];  //计算天数、时、分、秒
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minutes = ((int)time)%(3600*24)%3600/60;
    int seconds = ((int)time)%(3600*24)%3600%60;
    NSString *dateContent = [[NSString alloc] initWithFormat:@"仅剩%i天%i小时%i分%i秒",days,hours,minutes,seconds];
    //（%i可以自动将输入转换为十进制,而%d则不会进行转换）  //赋值显示
    //UILabel *timeLab = (UILabel *)[self.view viewWithTag:666666];
    
        if (type ==1) {
            return days;
        }else if (type ==2) {
            return hours+days*24;
        }else if (type ==3) {
            return (hours+days*24)*60 + minutes;
        }
        return seconds;
    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    unsigned int unitFlag  = NSDayCalendarUnit;
//
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    unsigned int unitFlag = NSDayCalendarUnit;
//    NSDateComponents *components = [calendar components:unitFlag fromDate:beginDate toDate:endDate options:0];
//    if (type ==1) {
//        return [components day];
//    }else if (type ==2) {
//        return [components hour];
//    }else if (type ==3) {
//        return [components minute];
//    }
//    return [components day];
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum{
    //手机号以13，14， 15，17，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return [phoneTest evaluateWithObject:mobileNum];

}


+ (NSDictionary *)dictionaryWithString:(NSString *)String sectionStr:(NSString *)sectionStr rowStr:(NSString *)rowStr{
    NSMutableDictionary * dic=[[NSMutableDictionary alloc]initWithCapacity:0];
    NSArray * arr=[String componentsSeparatedByString:sectionStr];
    for (NSString * strSection in arr) {
        NSArray * arrStr=[strSection componentsSeparatedByString:rowStr];
        [dic setObject:arrStr.lastObject forKey:arrStr.firstObject];
        
    }
    return [NSDictionary dictionaryWithDictionary:dic];
}



#pragma mark md5加密
//md5加密
+ (NSString *)md5:(NSString *)str
{
    const char * original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];
}

+ (NSString *)md5To16Str:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"XXXXXXXXXXXXXXXX",    // 小写 x 表示输出的是小写 MD5 ，大写 X 表示输出的是大写 MD5
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(NSString *)md5ToChar:(const char *)original_str{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];
}

+ (NSString*)getMD5WithData:(NSData *)data{
    
    const char* original_str = (const char *)[data bytes];
    
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    
    CC_MD5(original_str, strlen(original_str), digist);
    
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        
        [outPutStr appendFormat:@"%02x",digist[i]];// 小写 x 表示输出的是小写 MD5 ，大写 X 表示输出的是大写 MD5
    }
    return [outPutStr lowercaseString];
}

#pragma mark Json
+ (NSDictionary *)DictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    if ([jsonString isEqualToString:@"HEARTBEATRESP"]) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:jsonData
                                                       options:NSJSONReadingMutableContainers
                                                         error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//压缩图片质量
+ (UIImage *)reduceImage:(UIImage *)image percent:(float)percent{
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}

#pragma mark 文字

+(void)showMakeToastView:(NSString *)str{
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow makeToast:str duration:2.0 position:CSToastPositionBottom];
}

+ (float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width {
    //    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize]
    //                         constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
    //                             lineBreakMode:NSLineBreakByWordWrapping]; //此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    //    return sizeToFit.height;
    
    CGSize titleSize = [value boundingRectWithSize:CGSizeMake(width, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return titleSize.height;
}

+ (BOOL)isBlankString:(NSString *)string{
    //字符串的长度为0表示空串
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }

    if (string.length == 0) {
        return YES;
    }
    if ([string containsString:@"null"]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


// AlreadyIndex == -1 叠加   == 0 重0开始
+ (NSString *)resultObjectId:(NSString*)mId
{
    NSString *rid = nil;
    if ([mId isEqualToString:@"" ]|| mId == nil) {
        return rid;
    }
    rIndex++;
    rid = [NSString stringWithFormat:@"%@_%ld",mId,(long)rIndex];
    return rid;
}




/*
 *AccessKeyId : 阿里云颁发给用户的访问服务所用的密钥 ID
 *Action      : 操作接口名，系统规定参数
 *
 */
//+(void)createdSignWithAccessKeyId:(NSString *)AccessKeyId Action:(NSString *)action AppName:(NSString *)AppName DomainName:(NSString *)DomainName Format:(NSString *)Format Signature:(NSString *)Signature SignatureMethod:(NSString *)SignatureMethod SignatureNonce:(NSString *)SignatureVersion SignatureNonce:(NSString *)SignatureVersion StreamName:(NSString *)StreamName Timestamp:(NSString *)Timestamp Version:(NSString *)Version {
//    https://live.aliyuncs.com/?Action=DescribeLiveStreamOnlineUserNum&DomainName=test101.cdnpe.com&<公共请求参数>
//}
//



+(void)createASIFormDataRequset:(NSString *)urlStr
                          param:(NSDictionary*)param
                     completion:(SHResultObjectBlock)completion
{
    NSString *paramsJson;
    if (param) {
        paramsJson = [[[SBJsonWriter alloc] init] stringWithObject:param];
    }else{
        paramsJson = [[[SBJsonWriter alloc] init] stringWithObject:@{}];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: [paramsJson dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"\nCGI post 请求 \n url:%@ ,paramsJson:%@\n",request,paramsJson);
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
     session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript", nil];
    [session.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    __block NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"\n获取失败..%@\n",error.localizedDescription);
            completion(nil,error);
        } else {
            NSDictionary * dicResult = [NSDictionary dictionaryWithDictionary:responseObject];
            if([dicResult.allKeys containsObject:@"errmsg"]){
                NSLog(@"\n获取失败..%@\n",dicResult[@"errmsg"]);
                NSError * errorGet =[[NSError alloc]initWithDomain:dicResult[@"errmsg"] code:[dicResult[@"errcode"] integerValue] userInfo:dicResult];
                completion(nil,errorGet);
            }else{
                NSLog(@"\n获取成功..%@\n",responseObject);
                completion(responseObject,nil);
            }
        }
    }];
    
    [task resume];
}

+(void)upDataImgWithImage:(UIImage *)image requesetUrl:(NSString *)requesetUrl imageType:(NSString *)type completion:(SHResultObjectBlock)completion{
    
    NSURL *URL = [[NSURL alloc]initWithString:requesetUrl];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:URL cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:5];
    request.HTTPMethod = @"POST";
    NSString *boundary = @"wfWiEWrgEFA9A78512weF7106A";
    request.allHTTPHeaderFields = @{
                                    @"Content-Type":[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary]
                                    };
    
    NSMutableData *postData = [[NSMutableData alloc]init];//请求体数据
    NSArray * params = @[@"type"];
    for (NSString *key in params) {
        //循环参数按照部分1、2、3那样循环构建每部分数据
        NSString *pair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n",boundary,key];
        [postData appendData:[pair dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[type dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
//    //文件部分
//    NSArray *docdirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docdir = [docdirs objectAtIndex:0];
//    NSString *path = @"nmLivePlay";
//    NSString *configFilePath = [docdir stringByAppendingPathComponent:path];
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
//
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//
//    if (![[NSFileManager defaultManager] fileExistsAtPath:configFilePath]) {
//        BOOL bCreateDir = [fileManager createDirectoryAtPath:configFilePath withIntermediateDirectories:YES attributes:nil error:nil];
//        if(!bCreateDir){
//            NSLog(@"创建文件夹失败！");
//        }
//    }
//    BOOL isSaved=  [fileManager createFileAtPath:[configFilePath stringByAppendingString:[NSString stringWithFormat:@"/%@.jpg",@"showImage"]] contents:imageData attributes:nil];
//    NSLog(@"图片保存状态：%d",isSaved);
//
//    NSData * imageFileData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/showImage.jpg",configFilePath]];
//    NSString *filePair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n",boundary,@"files"];
////    NSString *filePair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\";Content-Type=%@\r\n\r\n",boundary,@"files",@"showImage.jpg",@"image/jpeg"];
//    [postData appendData:[filePair dataUsingEncoding:NSUTF8StringEncoding]];
//    [postData appendData:imageFileData]; //加入文件的数据
    
    //设置请求体
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPBody = postData;
    //设置请求头总数据长度
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    __block NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"\n获取失败..%@\n",error.localizedDescription);
            completion(nil,error);
        } else {
            NSDictionary * dicResult = [NSDictionary dictionaryWithDictionary:responseObject];
            if([dicResult.allKeys containsObject:@"errmsg"]){
                NSLog(@"\n获取失败..%@\n",dicResult[@"errmsg"]);
                NSError * errorGet =[[NSError alloc]initWithDomain:dicResult[@"errmsg"] code:[dicResult[@"errcode"] integerValue] userInfo:dicResult];
                completion(nil,errorGet);
            }else{
                NSLog(@"\n获取成功..%@\n",responseObject);
                completion(responseObject,nil);
            }
        }
    }];
    
    [task resume];
    
}


+(void)upDataImgWithImage2:(UIImage *)image requesetUrl:(NSString *)requesetUrl imageType:(NSString *)type completion:(SHResultObjectBlock)completion{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript", nil];
    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    NSArray *docdirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docdir = [docdirs objectAtIndex:0];
    NSString *path = @"nmLivePlay";
    NSString *configFilePath = [docdir stringByAppendingPathComponent:path];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![[NSFileManager defaultManager] fileExistsAtPath:configFilePath]) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:configFilePath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"创建文件夹失败！");
        }
    }
    BOOL isSaved=  [fileManager createFileAtPath:[configFilePath stringByAppendingString:[NSString stringWithFormat:@"/%@.jpg",@"showImage"]] contents:imageData attributes:nil];
    NSLog(@"图片保存状态：%d",isSaved);

    [manager POST:requesetUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:[type dataUsingEncoding:NSUTF8StringEncoding] name:@"type"];
        [formData appendPartWithFileData:imageData name:@"files" fileName:@"showImage.jpg" mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NSNotificationCenter.defaultCenter postNotificationName:@"userUploadAvatarSuccess" object:nil];
        NSLog(@"上传成功%@",responseObject);
        NSDictionary * dicResult =[NSDictionary dictionaryWithDictionary:responseObject];
        if ([dicResult.allKeys containsObject:@"errmsg"]) {
            NSError * errorRequest =[NSError errorWithDomain:dicResult[@"errmsg"] code:[dicResult[@"errmsg"] integerValue] userInfo:dicResult];
             completion(nil,errorRequest);
        }else{
            completion(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败");
        completion(nil,error);
    }];
//
}

+(void)doUpLoad:(NSString *)url param:(NSDictionary *)dic data:(NSData *)data type:(NSString *)type name:(NSString *)name fileName:(NSString *)fileName completion:(SHResultObjectBlock)completion{
    
    NSString *paramsJson;
    if (dic) {
        paramsJson = [[[SBJsonWriter alloc] init] stringWithObject:dic];
    }else{
        paramsJson = [[[SBJsonWriter alloc] init] stringWithObject:@{}];
    }
    
    AFHTTPSessionManager * httpManager = [AFHTTPSessionManager manager];
//    [httpManager.requestSerializer setValue: [[NSUserDefaults standardUserDefaults] objectForKey:PostCookisName] forHTTPHeaderField:@"Cookie"];
    
    [httpManager POST:url parameters:paramsJson constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:type];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功---%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败---%@",error);
    }];
  
}

+ (void)showAlertView:(NSString *)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:sender
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];

    [alert show];
}

@end
