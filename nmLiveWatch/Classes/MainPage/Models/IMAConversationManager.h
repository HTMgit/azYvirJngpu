//
//  IMAConversationManager.h
//  TIMAdapter
//
//  Created by AlexiChen on 16/2/18.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//


typedef NS_OPTIONS(NSUInteger, IMAConversationChangedNotifyType) {
    EIMAConversation_SyncLocalConversation =    0x01,               // 同步本地会话结束
    EIMAConversation_BecomeActiveTop    =       0x01 << 1,          // 当前会话放在会话列表顶部
    EIMAConversation_NewConversation    =       0x01 << 2,          // 新增会话
    EIMAConversation_DeleteConversation =       0x01 << 3,          // 删除会话
    
    EIMAConversation_Connected          =       0x01 << 4,          // 网络连上
    EIMAConversation_DisConnected       =       0x01 << 5,          // 网络连上
    
    EIMAConversation_ConversationChanged    =       0x01 << 6,          // 会话有更新
    
    
    
    EIMAConversation_AllEvents         = EIMAConversation_SyncLocalConversation | EIMAConversation_BecomeActiveTop | EIMAConversation_NewConversation | EIMAConversation_DeleteConversation |  EIMAConversation_Connected | EIMAConversation_DisConnected | EIMAConversation_ConversationChanged,
};


@interface IMAConversationChangedNotifyItem : NSObject

//@property (nonatomic, strong) TIMConversation *conversation;

- (instancetype)initWith:(IMAConversationChangedNotifyType)type;
@end

typedef void (^IMAConversationChangedCompletion)(IMAConversationChangedNotifyItem *item);

@interface IMAConversationManager : NSObject<TIMMessageListener, TIMMessageRevokeListener>


@property (nonatomic, strong) TIMConversation *conversation;
@property (nonatomic, assign) NSInteger unReadMessageCount;
@property (nonatomic, copy) IMAConversationChangedCompletion  conversationChangedCompletion;

- (void)updateOnLocalMsgComplete;
@end
