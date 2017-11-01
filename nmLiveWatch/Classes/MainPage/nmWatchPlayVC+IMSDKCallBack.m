//
//  nmWatchPlayVC+IMSDKCallBack.m
//  nmLiveWatch
//
//  Created by zyh on 2017/11/1.
//  Copyright © 2017年 zyh. All rights reserved.
//

#import "nmWatchPlayVC+IMSDKCallBack.h"


// IMSDK回调（除MessageListener外）统一处理
@implementation nmWatchPlayVC (IMSDKCallBack)

#pragma mark - TIMConnListener

/**
 *  网络连接成功
 */
- (void)onConnSucc
{
    //[ZYHCommonService showMakeToastView:@"网络连接成功"];
}

/**
 *  网络连接失败
 *
 *  @param code 错误码
 *  @param err  错误描述
 */
- (void)onConnFailed:(int)code err:(NSString*)err
{
    NSString * errorMsg =[NSString stringWithFormat:@"网络连接失败:%@",err];
    [ZYHCommonService showMakeToastView:errorMsg];
    
}

/**
 *  网络连接断开
 *
 *  @param code 错误码
 *  @param err  错误描述
 */
- (void)onDisconnect:(int)code err:(NSString*)err
{
    NSString * errorMsg =[NSString stringWithFormat:@"网络连接断开:%@",err];
    [ZYHCommonService showMakeToastView:errorMsg];
}


/**
 *  连接中
 */
- (void)onConnecting
{
    // [ZYHCommonService showMakeToastView:@"连接中"];
}

- (void)registNotification
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}

#pragma mark - TIMUserStatusListener

/**
 *  踢下线通知
 */

static BOOL kIsAlertingForceOffline = NO;
- (void)onForceOffline
{
    
    kIsAlertingForceOffline = YES;
    [ZYHCommonService showMakeToastView:@"下线通知:您的帐号于另一台手机上登录"];
    [self signOutPlaying];
    
}

/**
 *  断线重连失败
 */
- (void)onReConnFailed:(int)code err:(NSString*)err
{
    [ZYHCommonService showMakeToastView:@"断线重连失败"];
}

/**
 *  用户登录的userSig过期，需要重新登录
 */
- (void)onUserSigExpired
{
    [ZYHCommonService showMakeToastView:@"用户登录的userSig过期，需要重新登录"];
}

- (void)OnRefreshTicketSuccess:(TLSUserInfo *)userInfo
{
    [ZYHCommonService showMakeToastView:@"更新本地票据"];
}

- (void)OnRefreshTicketFail:(TLSErrInfo *)errInfo
{
    NSString *err = [[NSString alloc] initWithFormat:@"刷新票据失败\ncode:%d, error:%@", errInfo.dwErrorCode, errInfo.sErrorTitle];
    [ZYHCommonService showMakeToastView:err];
}

- (void)OnRefreshTicketTimeout:(TLSErrInfo *)errInfo
{
    [self OnRefreshTicketFail:errInfo];
}

#pragma mark -TIMRefreshListener

- (void)onRefresh
{
    // TODO:重新刷新会话列列
    NSLog(@"=========>>>>> 刷新会话列表");
    dispatch_async(dispatch_get_main_queue(), ^{
        //        int result = [[TIMManager sharedInstance] addMessageListener:self];
        //        NSLog(@"注册消息接收 %d ：%@",result,!result?@"成功":@"失败");
    });
}

- (void)onRefreshConversations:(NSArray*)conversations
{
    
    
}

@end

#pragma mark -GroupAssistantListener
@implementation nmWatchPlayVC (GroupAssistantListener)

/**nmWatchPlayVC
 *  有新用户加入群时的通知回调
 *
 *  @param groupId     群ID
 *  @param membersInfo 加群用户的群资料（TIMGroupMemberInfo*）列表
 */
-(void) onMemberJoin:(NSString *)groupId membersInfo:(NSArray *)membersInfo
{
    [self groupAssistantListenerJoinUpdate:groupId updata:membersInfo];
}

/**
 *  有群成员退群时的通知回调
 *
 *  @param groupId 群ID
 *  @param members 退群成员的identifier（NSString*）列表
 */
-(void) onMemberQuit:(NSString*)groupId members:(NSArray*)members
{
    [self groupAssistantListenerQuitUpdate:groupId updata:members];
}

/**
 *  群成员信息更新的通知回调
 *
 *  @param groupId     群ID
 *  @param membersInfo 更新后的群成员资料（TIMGroupMemberInfo*）列表
 */
-(void) onMemberUpdate:(NSString*)groupId membersInfo:(NSArray*)membersInfo
{
    NSString * error = [NSString stringWithFormat:@"群成员信息更新:groupId = %@, membersInfo = %@", groupId, membersInfo];
    [ZYHCommonService showMakeToastView:error];
    //    DebugLog(@"groupId = %@, membersInfo = %@", groupId, membersInfo);
}

/**
 *  加入群的通知回调
 *
 *  @param groupInfo 加入群的群组资料
 */
-(void) onGroupAdd:(TIMGroupInfo*)groupInfo
{
    //     [self groupAssistantListenerJoinUpdate:groupInfo.group updata:nil];
    [self updateGroupAssistantList];
}

/**
 *  解散群的通知回调
 *
 *  @param groupId 解散群的群ID
 */
-(void) onGroupDelete:(NSString*)groupId
{
    NSString * error = [NSString stringWithFormat:@"解散群的通知回调:groupId = %@", groupId];
    [ZYHCommonService showMakeToastView:error];
}

/**
 *  群资料更新的通知回调
 *
 *  @param groupInfo 更新后的群资料信息
 */
- (void)onGroupUpdate:(TIMGroupInfo*)groupInfo
{
    NSString * error = [NSString stringWithFormat:@"群资料更新的通知回调:groupInfo = %@", groupInfo];
    [ZYHCommonService showMakeToastView:error];
}


@end
