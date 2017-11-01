//
//  nmWatchPlayVC.m
//  nmLiveWatch
//
//  Created by zyh on 2017/10/31.
//  Copyright © 2017年 zyh. All rights reserved.
//

#import "nmWatchPlayVC.h"
#import "LPLivePlayingLayoutView.h"
#import <AliyunPlayerSDK/AliyunPlayerSDK.h>
#import <IMMessageExt/IMMessageExt.h>
#import <IMGroupExt/TIMGroupManager+Ext.h>
#import "Reachability.h"
@interface nmWatchPlayVC ()<LPLivePlayingLayoutViewDelegate>{
    LPLivePlayingLayoutView * layoutView;
    AliVcMediaPlayer* mediaPlayer;
    nmPlayerModel * playerModel;
    TIMConversation * roomConversation;//会话
    TIMManager *roomIMManager;
    UIActivityIndicatorView * loadingView;
    BOOL isPlaying;
    NSString * stateStr;
}

@end

@implementation nmWatchPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES];
    [self loadLayoutView];
    [self loadViewPlayInfo];
    
    loadingView =[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((kNMDeviceWidth-40)/2, (kNMDeviceHeight-40)/2, 40, 40)];
    [loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    loadingView.hidesWhenStopped = YES;
    [layoutView addSubview:loadingView];
    [loadingView startAnimating];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}



-(void)loadLayoutView{
    layoutView = [[LPLivePlayingLayoutView alloc]initWithFrame:CGRectMake(0, 0, kNMDeviceWidth, kNMDeviceHeight)];
    layoutView.delegate = self;
    layoutView.playerModel = self.roomModel;
    layoutView.layer.zPosition = 100;
    [layoutView setLayoutView];
    [self.view addSubview:layoutView];
    
    
}


#pragma mark 初始化
//加载直播信息
-(void)loadViewPlayInfo{
    NSString * requestUrl = [REQUESTURL stringByAppendingString:@"/live/detail?sid=5&stype=2"];
    [layoutView reloadConversationTabelView:@[@{@"msg":@"载入房间信息..."}]];
    [ZYHCommonService createASIFormDataRequset:requestUrl param:nil completion:^(id result, NSError *error) {
        if (error) {
            [layoutView reloadConversationTabelView:@[@{@"msg":@"房间信息载入失败"}]];
        }else{
            NSDictionary * dicResult =[NSDictionary dictionaryWithDictionary:result];
            if (dicResult) {
                NSError * error;
                playerModel =[nmPlayerModel arrayOfModelsFromDictionaries:@[dicResult] error:&error].lastObject;
                [layoutView reloadConversationTabelView:@[@{@"msg":@"载入直播视频信息..."}]];
                [self loadVideoInfo];
            }else{
                [layoutView reloadConversationTabelView:@[@{@"msg":@"房间信息加载失败"}]];
            }
        }
    }];
}


//初始化播放器的类
-(void)loadVideoInfo{
    //初始化播放器的类
    mediaPlayer = [[AliVcMediaPlayer alloc] init];
    //播放器倍数播放，支持0.5～2倍数播放，创建播放器后设置参数，在播放过程中可更新倍数播放数值；默认倍数播放值是1(正常播放速度)。
    mediaPlayer.playSpeed = 1;
    mediaPlayer.mediaType =MediaType_LIVE;
    mediaPlayer.timeout = 25000;//毫秒
    mediaPlayer.dropBufferDuration = 8000;
    //创建播放器，传入显示窗口
    [mediaPlayer create:self.view];
    [self performSelector:@selector(actionGetVideoTimeOut) withObject:nil afterDelay:3];
    self.view.userInteractionEnabled = YES;
    layoutView.userInteractionEnabled = YES;
    //注册通知
    [self addPlayerObserver];
    //传入播放地址，准备播放
    [mediaPlayer prepareToPlay:[NSURL URLWithString:playerModel.stream]];
    //开始播放
   [mediaPlayer play];
    
}


//初始化IM
-(void)initImLiveRoomSet{
    
    TIMSdkConfig *config = [[TIMSdkConfig alloc] init];
    config.sdkAppId = [playerModel.sdkAppId intValue] ;
    config.accountType = playerModel.accountType;
    config.disableCrashReport = NO;
    config.connListener = self;
    
    roomIMManager = [TIMManager sharedInstance];
    [roomIMManager initSdk:config];
    int result = [[TIMManager sharedInstance] addMessageListener:self];
    NSLog(@"注册消息接收 %d ：%@",result,!result?@"成功":@"失败");
    
    TIMUserConfig *userConfig = [[TIMUserConfig alloc] init];
    //    userConfig.disableStorage = YES;//禁用本地存储（加载消息扩展包有效）
    //    userConfig.disableAutoReport = YES;//禁止自动上报（加载消息扩展包有效）
    //    userConfig.enableReadReceipt = YES;//开启C2C已读回执（加载消息扩展包有效）
    userConfig.disableRecnetContact = NO;//不开启最近联系人（加载消息扩展包有效）
    userConfig.disableRecentContactNotify = YES;//不通过onNewMessage:抛出最新联系人的最后一条消息（加载消息扩展包有效）
    userConfig.enableFriendshipProxy = YES;//开启关系链数据本地缓存功能（加载好友扩展包有效）
    userConfig.enableGroupAssistant = YES;//开启群组数据本地缓存功能（加载群组扩展包有效）
    TIMGroupInfoOption *giOption = [[TIMGroupInfoOption alloc] init];
    giOption.groupFlags = 0xffffff;//需要获取的群组信息标志（TIMGetGroupBaseInfoFlag）,默认为0xffffff
    giOption.groupCustom = nil;//需要获取群组资料的自定义信息（NSString*）列表
    userConfig.groupInfoOpt = giOption;//设置默认拉取的群组资料
    TIMGroupMemberInfoOption *gmiOption = [[TIMGroupMemberInfoOption alloc] init];
    gmiOption.memberFlags = 0xffffff;//需要获取的群成员标志（TIMGetGroupMemInfoFlag）,默认为0xffffff
    gmiOption.memberCustom = nil;//需要获取群成员资料的自定义信息（NSString*）列表
    userConfig.groupMemberInfoOpt = gmiOption;//设置默认拉取的群成员资料
    TIMFriendProfileOption *fpOption = [[TIMFriendProfileOption alloc] init];
    fpOption.friendFlags = 0xffffff;//需要获取的好友信息标志（TIMProfileFlag）,默认为0xffffff
    fpOption.friendCustom = nil;//需要获取的好友自定义信息（NSString*）列表
    fpOption.userCustom = nil;//需要获取的用户自定义信息（NSString*）列表
    userConfig.friendProfileOpt = fpOption;//设置默认拉取的好友资料
    userConfig.userStatusListener = self;//用户登录状态监听器
    userConfig.refreshListener = self;//会话刷新监听器（未读计数、已读同步）（加载消息扩展包有效）
    //        userConfig.receiptListener = self;//消息已读回执监听器（加载消息扩展包有效）
    //        userConfig.messageUpdateListener = self;//消息svr重写监听器（加载消息扩展包有效）
    //        userConfig.uploadProgressListener = self;//文件上传进度监听器
    //        userConfig.groupEventListener = self;
    userConfig.friendshipListener = self;//关系链数据本地缓存监听器（加载好友扩展包、enableFriendshipProxy有效）
    userConfig.groupListener = self;//群组据本地缓存监听器（加载群组扩展包、enableGroupAssistant有效）
    //    userConfig.groupass
    //    GroupAssistantListener
    if (!_roomConversationMgr){
        _roomConversationMgr = [[IMAConversationManager alloc] init];
    }
    userConfig.messgeRevokeListener = _roomConversationMgr;
    [roomIMManager setUserConfig:userConfig];
    
    TIMLoginParam * loginParam = [[TIMLoginParam alloc] init];
    loginParam.identifier =playerModel.imId;
    loginParam.appidAt3rd = playerModel.sdkAppId;
    loginParam.userSig = playerModel.imSid;//[[NSDate date] timeIntervalSince1970];
    [[TIMManager sharedInstance] login:loginParam succ:^{
        NSLog(@"登录成功");
        [self actionBeginConversation];
    } fail:^(int code, NSString *msg) {
        NSLog(@"登录失败");
    }];
}

//添加通知
-(void)addPlayerObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self                                             selector:@selector(becomeActive)                                                 name:UIApplicationDidBecomeActiveNotification                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self                                             selector:@selector(resignActive)                                                 name:UIApplicationWillResignActiveNotification                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self                                             selector:@selector(OnVideoPrepared:)                                                 name:AliVcMediaPlayerLoadDidPreparedNotification object:mediaPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self                                             selector:@selector(OnVideoFinish:)                                                 name:AliVcMediaPlayerPlaybackDidFinishNotification object:mediaPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self                                             selector:@selector(OnVideoError:)                                                 name:AliVcMediaPlayerPlaybackErrorNotification object:mediaPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self                                             selector:@selector(OnSeekDone:)                                                 name:AliVcMediaPlayerSeekingDidFinishNotification object:mediaPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self                                             selector:@selector(OnStartCache:)                                                 name:AliVcMediaPlayerStartCachingNotification object:mediaPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self                                             selector:@selector(OnEndCache:)                                                 name:AliVcMediaPlayerEndCachingNotification object:mediaPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self                                             selector:@selector(onVideoStop:)                                                 name:AliVcMediaPlayerPlaybackStopNotification object:mediaPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self                                             selector:@selector(onVideoFirstFrame:)                                                 name:AliVcMediaPlayerFirstFrameNotification object:mediaPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
}

//通知回调
-(void)becomeActive{
    
}
-(void)resignActive{
    
}
-(void)OnVideoPrepared:(NSNotification *)sender{
    //播放器初始化视频文件完成通知
    [layoutView reloadConversationTabelView:@[@{@"msg":@"播放器初始化"}]];
    mediaPlayer.view.userInteractionEnabled = NO;
    [self.view bringSubviewToFront:layoutView];
    self.view.userInteractionEnabled = YES;
    layoutView.userInteractionEnabled = YES;
}
-(void)OnVideoFinish:(NSNotification *)sender{
    [loadingView stopAnimating];
    isPlaying = NO;
    [layoutView reloadConversationTabelView:@[@{@"msg":@"主播正在赶来的路上..."}]];
   // 播放完成通知。当视频播放完成后会收到此通知
}
-(void)OnVideoError:(NSNotification *)sender{
    //播放器播放失败发送该通知，并在该通知中可以获取到错误码。
    [loadingView stopAnimating];
  //  [layoutView reloadConversationTabelView:@[@{@"msg":@"播放器初始化失败"}]];
}
-(void)OnSeekDone:(NSNotification *)sender{
    
}
-(void)OnStartCache:(NSNotification *)sender{
    //播放器开始缓冲视频时发送该通知
    [loadingView startAnimating];
  //  [layoutView reloadConversationTabelView:@[@{@"msg":@"视频开始缓冲"}]];
}
-(void)OnEndCache:(NSNotification *)sender{
    //播放器结束缓冲视频时发送该通知
    //[layoutView reloadConversationTabelView:@[@{@"msg":@"OnEndCache"}]];
    [loadingView stopAnimating];
}
-(void)onVideoStop:(NSNotification *)sender{
   // [layoutView reloadConversationTabelView:@[@{@"msg":@"onVideoStop"}]];
}
-(void)onVideoFirstFrame:(NSNotification *)sender{
    isPlaying = YES;
    [loadingView stopAnimating];
    //播放器状态首帧显示后发送的通知
}
-(void)networkStateChange{
    
}

#pragma mark -action事件

-(void)actionGetVideoTimeOut{
    if (!isPlaying) {
        [mediaPlayer destroy];
        self.view.userInteractionEnabled = YES;
        layoutView.userInteractionEnabled = YES;
        [loadingView stopAnimating];
        [layoutView reloadConversationTabelView:@[@{@"msg":@"主播正在赶来的路上..."}]];
    }
}

//界面按钮代理
-(void)livePlayingLayout:(int)btnNum sender:(id)sender{
    if (btnNum == 7) {//关闭
        [self buttonCloseClick:nil];
    }else if (btnNum == 8) {//刷新
        if (!mediaPlayer) {
            [self loadVideoInfo];
        }else if (!mediaPlayer.isPlaying) {
            [mediaPlayer play];
        }else if (mediaPlayer.isPlaying) {
            [mediaPlayer play];
        }
    }else if (btnNum == 9) {//未登录
        if ([WXApi isWXAppInstalled]) {
            stateStr =[NSString stringWithFormat:@"%@",[[NSUUID UUID] UUIDString]];
            SendAuthReq *req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_userinfo";
            req.state = stateStr;
            [WXApi sendReq:req];
        }
        else {
            [self setupAlertController];
        }
    }
}

-(void) onReq:(BaseReq*)req{
    
}
//requestStr    __NSCFString *    @"/sign/app/stlive?code=061rNFYt1Hsoca042ZZt1vHKYt1rNFYo&state=465AC395-22FE-421B-96B9-064154132B0D"    0x00000001702e8180
-(void) onResp:(BaseResp*)resp{
    SendAuthResp *req =(SendAuthResp *)resp;
    stateStr = req.state;
    NSString * requestStr = [NSString stringWithFormat:@"/sign/app/stlive?code=%@&state=%@",req.code,req.state];
    NSString * requestUrl = [REQUESTURL stringByAppendingString:requestStr];
    //@{@"String code":req.code,@"String state":req.state}
    [ZYHCommonService createASIFormDataRequset:requestUrl param:nil completion:^(id result, NSError *error) {
        if (error) {
            [ZYHCommonService showMakeToastView:@"登录失败"];
        }else{
            NSDictionary * dicResult =[NSDictionary dictionaryWithDictionary:result];
            if (dicResult) {
                NSError * error;
                playerModel =[nmPlayerModel arrayOfModelsFromDictionaries:@[dicResult] error:&error].lastObject;
                [layoutView reloadConversationTabelView:@[@{@"msg":@"载入直播视频信息..."}]];
                [self loadVideoInfo];
            }else{
                [layoutView reloadConversationTabelView:@[@{@"msg":@"房间信息加载失败"}]];
            }
        }
    }];
}

-(void)livePlayingSendMsg:(NSString *)sendMsg sender:(id)sender{
    
}

- (void)buttonCloseClick:(id)sender {
    [mediaPlayer stop];
    [mediaPlayer destroy];
//    [[TIMGroupManager sharedInstance] quitGroup:@"" succ:^{
//        
//    } fail:^(int code, NSString *msg) {
//        [ZYHCommonService showMakeToastView:@"用户退出群失败"];
//        
//    }];
//    [[TIMManager sharedInstance] logout:^{
//        [[TIMManager sharedInstance] removeMessageListener:self];
//    } fail:^(int code, NSString *msg) {
//        [ZYHCommonService showMakeToastView:@"用户退出IM失败"];
//        
//    }];
    [self.navigationController popViewControllerAnimated:YES];
//  [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)updateGroupAssistantList{
    roomConversation =  [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:playerModel.groupId];
}


-(void)signOutPlaying{
    
}

-(void)groupAssistantListenerJoinUpdate:(NSString *)groupId updata:(NSArray *)updata{
    
}

-(void)groupAssistantListenerQuitUpdate:(NSString *)groupId updata:(NSArray *)updata{
    
}
    
//加入聊天室
-(void)actionBeginConversation{
    //    roomConversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:_roomInfo.groupId];
    [[TIMGroupManager sharedInstance] joinGroup:playerModel.groupId msg:nil succ:^{
    } fail:^(int code, NSString *msg) {
        NSLog(@"加入聊天室失败");
    }];
}

- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
}

@end






























