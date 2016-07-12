//
//  PrivilegeTableViewCell.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/6/20.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "PrivilegeTableViewCell.h"

@implementation PrivilegeTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.backgroundColor=[UIColor whiteColor];
    
    leftView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 35)];
    leftView.hidden=YES;
    {
        leftImageV=[[UIImageView alloc]initWithFrame:CGRectMake(gotiphon6(30), 5, gotiphon6(24), gotiphon6(24))];
        [leftView addSubview:leftImageV];
        
        leftLabel =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftImageV.frame)+gotiphon6(18), 7, ScreenWidth/2-gotiphon6(36)-CGRectGetWidth(leftImageV.frame), 20)];
        leftLabel.textColor=kUIColorFromRGB(0x323232);
        leftLabel.font=[UIFont systemFontOfSize:14.0];
        [leftView addSubview:leftLabel];
    }
    [self addSubview:leftView];
    
    rightView=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame), 0, ScreenWidth/2, 35)];
    rightView.hidden=YES;
    {
        rightImageV=[[UIImageView alloc]initWithFrame:CGRectMake(gotiphon6(20), 5, gotiphon6(24), gotiphon6(24))];
        [rightView addSubview:rightImageV];
        
        rightLabel =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rightImageV.frame)+gotiphon6(18), 7, ScreenWidth/2-gotiphon6(36)-CGRectGetWidth(rightImageV.frame), 20)];
        rightLabel.textColor=kUIColorFromRGB(0x323232);
        rightLabel.font=[UIFont systemFontOfSize:14.0];
        [rightView addSubview:rightLabel];
    }
    [self addSubview:rightView];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setPrivilegeInfoByModel:(NSArray *)array{
    leftView.hidden=NO;
    rightView.hidden=YES;
    
    
    leftLabel.text=array[0][@"b51"];
    [leftImageV sd_setImageWithURL:array[0][@"b35"] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
    leftView.tag=[array[0][@"b34"] integerValue];
    UITapGestureRecognizer *panGesFrist=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(panFristAction)];
    [leftView addGestureRecognizer:panGesFrist];
    
    
    if (array.count==2) {
        rightView.hidden=NO;
        rightLabel.text=array[1][@"b51"];
        [rightImageV sd_setImageWithURL:array[1][@"b35"] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
        rightView.tag=[array[1][@"b34"] integerValue];
        UITapGestureRecognizer *panGessection=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(panSectionAction)];
        [rightView addGestureRecognizer:panGessection];
    }
}
- (void)panSectionAction{
    if (_delegate && [_delegate respondsToSelector:@selector(getPrivilegecode:AndTitle:)]) {
        [_delegate getPrivilegecode:rightView.tag AndTitle:rightLabel.text];
    }
}
- (void)panFristAction{
    if (_delegate && [_delegate respondsToSelector:@selector(getPrivilegecode:AndTitle:)]) {
        [_delegate getPrivilegecode:leftView.tag AndTitle:leftLabel.text];
    }
}
@end
