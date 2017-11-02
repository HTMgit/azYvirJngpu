//
//  nmBaseModel.h
//  nmLiveWatch
//
//  Created by zyh on 2017/10/30.
//  Copyright © 2017年 zyh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol nmBaseModel
@end
@interface nmBaseModel : JSONModel

@end

@protocol nmPlayListRoomModel
@end
@interface nmPlayListRoomModel : JSONModel

@property(nonatomic,strong)NSString<Optional> * nickname;
@property(nonatomic,strong)NSString<Optional> * faceUrl;
@property(nonatomic,strong)NSString<Optional> * frontUrl;
@property(nonatomic,strong)NSString<Optional> * brief;//直播间描述
@property(nonatomic,assign)int sid;
@property(nonatomic,assign)int userNum;
@end

@protocol nmPlayerModel
@end

@interface nmPlayerModel : JSONModel
@property(nonatomic,strong)NSString<Optional> * stream;
@property(nonatomic,strong)NSString<Optional> * imName;
@property(nonatomic,strong)NSString<Optional> * zbFaceUrl;
@property(nonatomic,strong)NSString<Optional> * sdkAppId;
@property(nonatomic,strong)NSString<Optional> * zbNickname;
@property(nonatomic,strong)NSString<Optional> * accountType;
@property(nonatomic,strong)NSString<Optional> * imId;
@property(nonatomic,strong)NSString<Optional> * imSid;
@property(nonatomic,strong)NSString<Optional> * groupId;
@property(nonatomic,assign)int userNum;
@end

@interface LPuserModel : JSONModel

@property(nonatomic,strong)NSString<Optional> * username;
@property(nonatomic,strong)NSString<Optional> * nickname;
@property(nonatomic,strong)NSString<Optional> * faceUrl;
@property(nonatomic,strong)NSString<Optional> * frontUrl;
@property(nonatomic,strong)NSString<Optional> * signupTime;
@property(nonatomic,strong)NSString<Optional> * signinTime;
@property(nonatomic,strong)NSString<Optional> * vcInValidTime;
@property(nonatomic,strong)NSString<Optional> * vc;
@property(nonatomic,strong)NSString<Optional> * brief;//直播间描述
@property(nonatomic,assign)int sex;
@property(nonatomic,assign)BOOL isZhubo;
@property(nonatomic,assign)BOOL isBlacklist;
@end

//直播间
@interface LPlivingRoomModel : JSONModel

@property(nonatomic,strong)NSString<Optional> * stream;
@property(nonatomic,strong)NSString<Optional> * imName;
@property(nonatomic,strong)NSString<Optional> * zbFaceUrl;
@property(nonatomic,strong)NSString<Optional> * sdkAppId;
@property(nonatomic,strong)NSString<Optional> * zbNickName;
@property(nonatomic,assign)int  userNaum;
@property(nonatomic,strong)NSString<Optional> * imId;
@property(nonatomic,strong)NSString<Optional> * accountType;
@property(nonatomic,strong)NSString<Optional> * groupId;
@property(nonatomic,strong)NSString<Optional> * imSid;
