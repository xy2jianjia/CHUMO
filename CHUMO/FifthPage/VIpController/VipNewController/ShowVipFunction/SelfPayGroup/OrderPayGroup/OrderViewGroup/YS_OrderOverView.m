//
//  YS_OrderOverView.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/6.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "YS_OrderOverView.h"


@interface YS_OrderOverView ()
{
    UILabel *productLabel;//产品名称
    UILabel *priceLabel;//支付价格
    UILabel *lastPriceLabel;//最终价格
    UILabel *discountLabel;//折扣
    UILabel *discountPriceLabel;//折扣价格
    UILabel *typeLabel;//支付方式
    UILabel *originalCostLabel;//原价
    
    //标题
    UILabel *productText;
    UILabel *discountText;
    UILabel *originalCost;
    UILabel *discountPriceText;
    UILabel *payStatusText;
    UIView *leftView;
    UIView *rightView;
}
@end
@implementation YS_OrderOverView

+(instancetype)orderOverInfoWithFrame:(CGRect)frame AndInfoModel:(YS_HistoryOrderModel *)model{
    YS_OrderOverView *view=[[YS_OrderOverView alloc]initWithFrame:[[UIScreen mainScreen] bounds] withInfoModel:model];
    return view;
}
-(instancetype)initWithFrame:(CGRect)frame withInfoModel:(YS_HistoryOrderModel *)model{
    if (self==[super initWithFrame:frame]) {
        [self setupView:model];
    }
    return self;
}
- (void)setupView:(YS_HistoryOrderModel *)model{
    self.backgroundColor=kUIColorFromRGB(0xffffff);
    //标题
    productText=[[UILabel alloc]init];
    productText.text=@"订单名称";
    productText.font=MyFont(15);
    productText.textColor=kUIColorFromRGB(0x323232);
    [self addSubview:productText];
    
    productLabel=[[UILabel alloc]init];
    productLabel.textAlignment=NSTextAlignmentRight;
    productLabel.text=model.b119;
    productLabel.textColor=kUIColorFromRGB(0x737171);
    productLabel.font=MyFont(13);
    [self addSubview:productLabel];
 
    discountText=[[UILabel alloc]init];
    discountText.text=@"优惠";
    discountText.textColor=kUIColorFromRGB(0xe62739);
    discountText.font=MyFont(13);
    [self addSubview:discountText];
    
    discountLabel=[[UILabel alloc]init];
    discountLabel.textAlignment=NSTextAlignmentRight;
    discountLabel.text=[NSString stringWithFormat:@"%@ 折",model.b128] ;
    discountLabel.textColor=kUIColorFromRGB(0xe62739);
    discountLabel.font=MyFont(13);
    [self addSubview:discountLabel];
    
    
    
    //分割线
    leftView=[[UIView alloc]init];
    leftView.backgroundColor=kUIColorFromRGB(0xe6e1e1);
    [self addSubview:leftView];
    
    payStatusText=[[UILabel alloc]init];
    switch ([model.b122 integerValue]) {
        case 1:
        {
            payStatusText.text=@"支付成功";
        }
            break;
        case 2:
        {
            payStatusText.text=@"支付失败";
        }
            break;
        case 4:
        {
            payStatusText.text=@"支付已取消";
        }
            break;
            
        default:
            break;
    }
    payStatusText.textAlignment=NSTextAlignmentCenter;
    payStatusText.textColor=kUIColorFromRGB(0xaba7a8);
    payStatusText.font=MyFont(12);
    [self addSubview:payStatusText];
    
    rightView=[[UIView alloc]init];
    rightView.backgroundColor=kUIColorFromRGB(0xe6e1e1);
    [self addSubview:rightView];
    
    priceLabel=[[UILabel alloc]init];
    priceLabel.textAlignment=NSTextAlignmentCenter;
    priceLabel.text=[NSString stringWithFormat:@"%.1f元",[model.b129 floatValue]];
    priceLabel.textColor=kUIColorFromRGB(0xe62739);
    priceLabel.font=MyFont(18);
    [self addSubview:priceLabel];
    
    //价格
    originalCost=[[UILabel alloc]init];
    originalCost.text=@"原价";
    originalCost.font=MyFont(13);
    originalCost.textColor=kUIColorFromRGB(0x737171);
    [self addSubview:originalCost];
    
    originalCostLabel=[[UILabel alloc]init];
    originalCostLabel.textAlignment=NSTextAlignmentRight;
    originalCostLabel.text=[NSString stringWithFormat:@"%.1f元",[model.b129 floatValue]];
    originalCostLabel.textColor=kUIColorFromRGB(0x737171);
    originalCostLabel.font=MyFont(13);
    [self addSubview:originalCostLabel];
    
    discountPriceText=[[UILabel alloc]init];
    discountPriceText.text=@"优惠费用";
    discountPriceText.font=MyFont(13);
    discountPriceText.textColor=kUIColorFromRGB(0x737171);
    [self addSubview:discountPriceText];
    
    discountPriceLabel=[[UILabel alloc]init];
    discountPriceLabel.textAlignment=NSTextAlignmentRight;
    discountPriceLabel.text=[NSString stringWithFormat:@"-%.1f元",[model.b123 floatValue]*(10-[model.b128 floatValue])];
    discountPriceLabel.textColor=kUIColorFromRGB(0x737171);
    discountPriceLabel.font=MyFont(13);
    [self addSubview:discountPriceLabel];
    
    typeLabel=[[UILabel alloc]init];
    switch ([model.b130 integerValue]) {
        case 1:
        {
            typeLabel.text=@"支付宝支付";
        }
            break;
        case 2:
        {
            typeLabel.text=@"微信支付";
        }
            break;
        case 6:
        {
            typeLabel.text=@"现在支付宝支付";
        }
            break;
        case 7:
        {
            typeLabel.text=@"现在银联支付";
        }
            break;
        case 8:
        {
            typeLabel.text=@"苹果内购支付";
        }
            break;
        case 9:
        {
            typeLabel.text=@"汇付宝银联支付";
        }
            break;
        case 11:
        {
            typeLabel.text=@"汇付宝微信支付";
        }
            break;
        case 12:
        {
            typeLabel.text=@"汇付宝支付宝支付";
        }
            break;
            
            
        default:
            break;
    }
    
    typeLabel.textColor=kUIColorFromRGB(0x737171);
    typeLabel.font=MyFont(13);
    [self addSubview:typeLabel];
    
    lastPriceLabel=[[UILabel alloc]init];
    lastPriceLabel.textAlignment=NSTextAlignmentRight;
    lastPriceLabel.text=[NSString stringWithFormat:@"%.1f元",[model.b129 floatValue]];
    lastPriceLabel.textColor=kUIColorFromRGB(0x737171);
    lastPriceLabel.font=MyFont(13);
    [self addSubview:lastPriceLabel];
    
}
-(void)layoutSubviews{
    productText.frame=CGRectMake(20, 30, (ScreenWidth-40)/2, 25);
    productLabel.frame=CGRectMake(CGRectGetMaxX(productText.frame),CGRectGetMinY(productText.frame), (ScreenWidth-40)/2, 25);
    
    discountText.frame=CGRectMake(20, CGRectGetMaxY(productText.frame)+5, (ScreenWidth-40)/2, 21);
    discountLabel.frame=CGRectMake(CGRectGetMaxX(discountText.frame), CGRectGetMinY(discountText.frame), (ScreenWidth-40)/2, 21);
    
    payStatusText.frame=CGRectMake(CGRectGetMidX([[UIScreen mainScreen] bounds])-50, CGRectGetMaxY(discountLabel.frame)+20, 100, 21);
    leftView.frame = CGRectMake(CGRectGetMinX(payStatusText.frame)-90, CGRectGetMinY(payStatusText.frame)+10, 80, 1);
    rightView.frame = CGRectMake(CGRectGetMaxX(payStatusText.frame)+10, CGRectGetMinY(payStatusText.frame)+10, 80, 1);
    
    priceLabel.frame=CGRectMake(CGRectGetMidX([[UIScreen mainScreen] bounds])-50, CGRectGetMaxY(payStatusText.frame), 100, 30);
    
    originalCost.frame =CGRectMake(20, CGRectGetMaxY(priceLabel.frame)+5, (ScreenWidth-40)/2, 25);
    originalCostLabel.frame = CGRectMake(CGRectGetMaxX(originalCost.frame), CGRectGetMinY(originalCost.frame), (ScreenWidth-40)/2, 25);
    
    discountPriceText.frame =CGRectMake(20, CGRectGetMaxY(originalCost.frame)+5, (ScreenWidth-40)/2, 25);
    discountPriceLabel.frame = CGRectMake(CGRectGetMaxX(discountPriceText.frame), CGRectGetMinY(discountPriceText.frame), (ScreenWidth-40)/2, 25);
    
    typeLabel.frame =CGRectMake(20, CGRectGetMaxY(discountPriceText.frame)+5, (ScreenWidth-40)/2, 25);
    lastPriceLabel.frame = CGRectMake(CGRectGetMaxX(typeLabel.frame), CGRectGetMinY(typeLabel.frame), (ScreenWidth-40)/2, 25);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
