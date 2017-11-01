//
//  nmNoDataView.m
//  nmLiveWatch
//
//  Created by zyh on 2017/10/31.
//  Copyright © 2017年 zyh. All rights reserved.
//

#import "nmNoDataView.h"

@implementation nmNoDataView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(actionReload)];
    [self addGestureRecognizer:tap];
    return self;
}

-(void)setNoDataView{
    errorImg =[[UIImageView alloc]init];
    errorLab =[[UILabel alloc]init];
    [self addSubview:errorImg];
    [self addSubview:errorLab];
    
    [errorImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).with.offset(-20);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    [errorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(errorImg.mas_bottom).with.offset(3);
        make.height.mas_equalTo(20);
    }];
    errorLab.font = [UIFont systemFontOfSize:13];
    errorLab.textColor =[UIColor grayColor];
    errorLab.text= _errorStr;
    
}

-(void)actionReload{
    if ([self.delegate respondsToSelector:@selector(noDataViewReloadData:)]) {
        [self.delegate noDataViewReloadData:self];
    }
}

@end
