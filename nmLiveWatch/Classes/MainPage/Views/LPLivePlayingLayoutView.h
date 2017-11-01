//
//  LPLivePlayingLayoutView.h
//  AlivcLiveVideoDemo
//
//  Created by zyh on 2017/10/13.
//  Copyright © 2017年 Alibaba Video Cloud. All rights reserved.
//

#import <UIKit/UIKit.h>





@class LPLivePlayingLayoutView;
@protocol LPLivePlayingLayoutViewDelegate<NSObject>
@optional
-(void)livePlayingLayout:(int)btnNum sender:(id)sender;
-(void)livePlayingSendMsg:(NSString *)sendMsg sender:(id)sender;
@end

@interface LPLivePlayingLayoutView : UIView<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    UITableView * talkTableView;
    UIView * headerView;
    UIImageView * userImg;
    UILabel * labWatchNum;
    UILabel * labFansNum;
    UIButton * btnClose;
    UIImageView * imgClose;
    
//    UILabel * labTimer;
    UITextField * txtTalk;
    UIButton * btnSend;
    
    UIButton * btnMore;
    BOOL isScreenRotate;
    float cellConWidth;
    
    float keyWordHight;
    BOOL isKeyShow;
    BOOL keyboardShown;
    BOOL isMove;//是否需要移动添加框
    
}

@property(nonatomic,strong) UILabel * labTimer;
@property(nonatomic,strong)UIButton * btnConnect;
@property(nonatomic,strong)UIImageView * imgConnect;
@property(nonatomic,strong)nmPlayListRoomModel * playerModel;
@property(nonatomic,strong)NSMutableArray * arrText;//会话消息

@property(nonatomic,weak) id<LPLivePlayingLayoutViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame;
-(void)setViewFrame;
-(void)setLayoutView;
-(void)setWatcherNum:(int)watcherNum;
-(void)reloadConversationTabelView:(NSArray *)arrNewText;
@end
