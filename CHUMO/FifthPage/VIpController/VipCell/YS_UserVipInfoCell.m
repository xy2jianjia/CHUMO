//
//  YS_UserVipInfoCell.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/4.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "YS_UserVipInfoCell.h"

@implementation YS_UserVipInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithUserInfo:(DHUserInfoModel *)userinfo ByVipDictionary:(NSArray *)vipDict{
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:userinfo.b57] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
    self.headImage.layer.cornerRadius=5;
    self.headImage.layer.masksToBounds=YES;
    NSString *nickName = userinfo.b52;
    if (![nickName isEqualToString:@"(null)"] && [nickName length] != 0) {
        self.nameLabel.text=nickName;
    }
    
    
    if ([userinfo.b144 integerValue]==1) {
        self.vipImage.hidden=NO;
        self.nameLabel.textColor=kUIColorFromRGB(0xe62739);
        
    }else if([userinfo.b144 integerValue]==2){
        self.nameLabel.textColor=kUIColorFromRGB(0x737171);
        
    }
    
    for (UIView *view in [self.vipInfoView subviews]) {
        [view removeFromSuperview];
    }
    
    if (vipDict.count==0) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.vipInfoView.bounds), 21)];
        label.text=@"普通用户";
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=kUIColorFromRGB(0x737171);
        [self.vipInfoView addSubview:label];
    }else{
        for (int i=0;i<vipDict.count;i++) {
            NSDictionary *dict = (NSDictionary *)vipDict[i];
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, i*18, CGRectGetMaxX(self.vipInfoView.bounds), 18)];
            label.textColor=kUIColorFromRGB(0x737171);
            
            switch ([dict[@"b78"] integerValue]) {
                case 2:
                {
                    label.text=[NSString stringWithFormat:@"写信包月 %@",dict[@"b136"],nil];
                }
                    break;
                case 1:
                {
                    label.text=[NSString stringWithFormat:@"VIP会员 %@",dict[@"b136"],nil];
                }
                    break;
        
                    
                default:
                    break;
            }
            label.font=[UIFont systemFontOfSize:12];
            [self.vipInfoView addSubview:label];
        }
    }
}


- (void)setCellByDictionary:(NSDictionary *)dict ByVipDictionary:(NSArray *)vipDict{
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:dict[@"b57"]] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
    self.headImage.layer.cornerRadius=5;
    self.headImage.layer.masksToBounds=YES;
    
    self.nameLabel.text=dict[@"b52"];
    
    if ([dict[@"b144"] integerValue]==1) {
        self.vipImage.hidden=NO;
        self.nameLabel.textColor=kUIColorFromRGB(0xe62739);
        
    }else if([dict[@"b144"] integerValue]==2){
        self.nameLabel.textColor=kUIColorFromRGB(0x737171);
        
    }
    
    for (UIView *view in [self.vipInfoView subviews]) {
        [view removeFromSuperview];
    }
    
    if (vipDict.count==0) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.vipInfoView.bounds), 21)];
        label.text=@"普通用户";
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=kUIColorFromRGB(0x737171);
        [self.vipInfoView addSubview:label];
    }else{
        for (int i=0;i<vipDict.count;i++) {
            NSDictionary *dict = (NSDictionary *)vipDict[i];
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, i*18, CGRectGetMaxX(self.vipInfoView.bounds), 18)];
            label.textColor=kUIColorFromRGB(0x737171);
            
            switch ([dict[@"b133"] integerValue]) {
                case 1004:
                {
                    label.text=[NSString stringWithFormat:@"写信包月 %@",dict[@"b136"],nil];
                }
                    break;
                case 1003:
                {
                    label.text=[NSString stringWithFormat:@"VIP会员 %@",dict[@"b136"],nil];
                }
                    break;
                case 1001:
                {
                    label.text=[NSString stringWithFormat:@"VIP会员 %@",dict[@"b136"],nil];
                }
                    break;
                case 1002:
                {
                    label.text=[NSString stringWithFormat:@"写信包月 %@",dict[@"b136"],nil];
                }
                    break;
                    
                default:
                    break;
            }
            label.font=[UIFont systemFontOfSize:12];
            [self.vipInfoView addSubview:label];
        }
    }
    
}
@end
