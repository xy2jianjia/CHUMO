//
//  HomeViewCell.m
//  微信
//
//  Created by Think_lion on 15/6/17.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "HomeViewCell.h"
#import "HomeModel.h"
#import "HomeConstomView.h"

@interface HomeViewCell ()
@property (nonatomic,weak) HomeConstomView *constomView;
@end

@implementation HomeViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self ){
        //添加子视图
        [self setupFirst];
    }
    return self;
}

-(void)setupFirst
{
    HomeConstomView *constomView=[[HomeConstomView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
   
    [self.contentView addSubview:constomView];
   
    self.constomView=constomView;
    
}

+(id)cellWithTableView:(UITableView *)tableView cellWithIdentifier:(NSString *)indentifier
{
    HomeViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell==nil){
        cell=[[HomeViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}
#pragma mark 根据模型设置
-(void)setHomeModel:(HomeModel *)homeModel
{
    self.constomView.homeModel=homeModel;
    
}

@end
