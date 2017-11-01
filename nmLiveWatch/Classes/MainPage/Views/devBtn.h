//
//  devBtn.h
//  hotel
//
//  Created by zhidao on 16/5/10.
//  Copyright © 2016年 zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface devBtn : UIButton{
    UIImageView * imageView;
}
@property (strong, nonatomic) UILabel * labName;
@property (strong, nonatomic) UILabel * labPanel;
@property (strong, nonatomic) UIImage *imgDef;
@property (strong, nonatomic) UIImage *imgSel;
@property (strong, nonatomic) NSString *theSelStr;
@property (strong, nonatomic) NSString * theStr;
@property (strong, nonatomic) NSString * panelStr;
@property (assign, nonatomic) BOOL isShowPanel;

-(void)setDevBtn;
-(void)changeDevBtnShow;
@end
