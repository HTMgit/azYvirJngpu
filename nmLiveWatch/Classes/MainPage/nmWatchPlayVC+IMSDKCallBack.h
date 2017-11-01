//
//  nmWatchPlayVC+IMSDKCallBack.h
//  nmLiveWatch
//
//  Created by zyh on 2017/11/1.
//  Copyright © 2017年 zyh. All rights reserved.
//

#import "nmWatchPlayVC.h"

#import <ImSDK/TIMCallback.h>
#import <TLSSDK/TLSAccountHelper.h>
#import <TLSSDK/TLSRefreshTicketListener.h>

@interface nmWatchPlayVC (IMSDKCallBack)<TIMUserStatusListener, TIMConnListener, TIMRefreshListener,TLSRefreshTicketListener>

@end

@interface nmWatchPlayVC (TIMFriendshipListener)<TIMFriendshipListener>

@end

@interface nmWatchPlayVC (GroupAssistantListener)<TIMGroupListener>

@end
