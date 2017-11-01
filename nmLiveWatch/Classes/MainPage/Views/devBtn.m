//
//  devBtn.m
//  hotel
//
//  Created by zhidao on 16/5/10.
//  Copyright © 2016年 zj. All rights reserved.
//

#import "devBtn.h"

@implementation devBtn

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
         _labName=[[UILabel alloc]init];
        _labName.textAlignment=NSTextAlignmentCenter;
        
        _labPanel=[[UILabel alloc]init];
        _labPanel.textAlignment=NSTextAlignmentCenter;
        
        imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
    }
    return self;
}

-(void)setDevBtn{
    
    _labName.font=[UIFont systemFontOfSize:13];
    _labName.textAlignment = NSTextAlignmentCenter;
    _labName.text=self.theStr;
    imageView.image=self.imgDef;
    
    
    _labPanel.font=[UIFont systemFontOfSize:13];
    _labPanel.text=self.panelStr;
    _labPanel.hidden = !_isShowPanel;
    
    [self addSubview:_labName];
    [self addSubview:_labPanel];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).with.offset(-15);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    [_labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).with.offset(8);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(15);
    }];
    
    [_labPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_labName.mas_bottom).with.offset(4);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(15);
    }];

    
    

}


-(void)changeDevBtnShow{
    if (self.selected) {
        _labName.text=self.theSelStr;
        imageView.image=self.imgSel;
    }else{
        _labName.text=self.theStr;
        imageView.image=self.imgDef;
    }
    
}

@end
