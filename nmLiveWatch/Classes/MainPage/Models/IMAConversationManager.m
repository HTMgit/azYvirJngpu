//
//  IMAConversationManager.m
//  TIMAdapter
//
//  Created by AlexiChen on 16/2/18.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMAConversationManager.h"

@implementation IMAConversationChangedNotifyItem

- (instancetype)initWith:(IMAConversationChangedNotifyType)type
{
    self = [super init];
    return self;
}

@end

@implementation IMAConversationManager


- (instancetype)init
{
    self = [super init];
    return self;
}


- (void)asyncUpdateConversationListComplete
{
        [self updateOnLocalMsgComplete];
}

- (void)asyncUpdateConversationList
{
    NSInteger unRead = 0;
    
        TIMConversation *conversation = nil;
        if ([conversation getType] == TIM_SYSTEM){
            #if kSupportCustomConversation
            // 可能返回空
//            conv = [[IMACustomConversation alloc] initWith:conversation];
            #else
            #endif
        }else{
//            conv = [[IMAConversation alloc] initWith:conversation];
        }
    
    
    
    [self asyncUpdateConversationListComplete];
    
    if (unRead != _unReadMessageCount)
    {
        self.unReadMessageCount = unRead;
    }
    NSLog(@"==========>>>>>>>>>asyncUpdateConversationList Complete");
}


- (NSInteger)insertPosition
{
    return 1;
    return 0;
}


/**
 *  新消息通知
 *
 *  @param msgs 新消息列表，TIMMessage 类型数组
 */
- (void)onNewMessage:(NSArray *)msgs
{
   
    NSLog(@"==========>>>>>>>>>新消息通知");
}

//申请加群请求
- (void)onAddGroupRequest:(TIMGroupSystemElem *)item
{
    NSLog(@"==========>>>>>>>>>新消息通知");
}


@end


@implementation IMAConversationManager (Protected)

- (void)onConnect
{
    // 删除
    NSLog(@"==========>>>>>>>>>删除");
  
}
- (void)onDisConnect
{
    
    // 插入一个网络断开的fake conversation
    NSLog(@"==========>>>>>>>>>插入一个网络断开的fake conversation");
}

- (void)updateOnChat:(TIMConversation *)conv moveFromIndex:(NSUInteger)index
{
    // 插入一个网络断开的fake conversation
    NSLog(@"==========>>>>>>>>>插入一个网络断开的fake conversation");
}

- (void)updateOnDelete:(TIMConversation *)conv atIndex:(NSUInteger)index
{
    // 更新界面
    NSLog(@"==========>>>>>>>>>更新界面");
}

- (void)updateOnAsyncLoadContactComplete
{
    // 通知更新界面
   NSLog(@"==========>>>>>>>>>通知更新界面");
}

- (void)updateOnLocalMsgComplete
{
    //更新界面
    NSLog(@"==========>>>>>>>>>更新界面");
}



@end
