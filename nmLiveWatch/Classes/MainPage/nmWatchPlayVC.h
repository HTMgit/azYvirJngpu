//
//  nmWatchPlayVC.h
//  nmLiveWatch
//
//  Created by zyh on 2017/10/31.
//  Copyright © 2017年 zyh. All rights reserved.
//

#import "nmBaseViewController.h"

#import "IMAConversationManager.h"
#import "WXApi.h"

@interface nmWatchPlayVC : nmBaseViewController <TIMMessageListener,WXApiDelegate>
@property(nonatomic,strong)nmPlayListRoomModel * roomModel;
@property(nonatomic ,strong)IMAConversationManager * roomConversationMgr;  // 会话列表
-(void)updateGroupAssistantList;
-(void)signOutPlaying;
-(void)groupAssistantListenerJoinUpdate:(NSString *)groupId updata:(NSArray *)updata;
-(void)groupAssistantListenerQuitUpdate:(NSString *)groupId updata:(NSArray *)updata;

@end
