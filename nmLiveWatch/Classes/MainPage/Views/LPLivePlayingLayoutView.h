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
//type :1-声音，2-亮度
-(void)livePlayingChangeViewShow:(float)valeNum type:(int)type;
@end

@interface LPLivePlayingLayoutView : UIView<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    UIView * viewBlak;
    UIButton * btnFllow;
    UIImageView * imgPeople;
    UILabel * labNum;
    UILabel * labRoomName;
    UIButton * btnList;
    UIScrollView * scrollList;
    UILabel * labRoomNumber;
    UIImageView * imgTalk;
    UIButton * btnTalk;
    UIButton * btnPrivateChat;
    UIButton * btnShare;
    UIView * viewLine;
    
    UIView * viewTalkBlak;
    UITextField * txtTalk;
    UIButton * btnSend;
    
    NSString * sendMsgStr;
    
    UITableView * talkTableView;
    UIView * headerView;
    UIImageView * userImg;
    UILabel * labWatchNum;
    UILabel * labFansNum;
    UIButton * btnClose;
    UIImageView * imgClose;
    
//    UILabel * labTimer;
    
    UIButton * btnMore;
    BOOL isScreenRotate;
    float cellConWidth;
    
    float keyWordHight;
    BOOL isKeyShow;
    BOOL keyboardShown;
    BOOL isMove;//是否需要移动添加框
    CGPoint panPoint;
    
}

@property(nonatomic,strong)UILabel * labTimer;
@property(nonatomic,strong)UIButton * btnConnect;
@property(nonatomic,strong)UIImageView * imgConnect;
@property(nonatomic,strong)nmPlayListRoomModel * playerModel;
@property(nonatomic,strong)NSMutableArray * arrText;//会话消息

@property(nonatomic,weak) id<LPLivePlayingLayoutViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame;
-(void)setViewFrame;
-(void)setLayoutView;
-(void)setClearTxtView;
-(void)changeTxtShow:(BOOL)isShow;
-(void)setWatcherNum:(int)watcherNum;
-(void)reloadConversationTabelView:(NSArray *)arrNewText;
@end
