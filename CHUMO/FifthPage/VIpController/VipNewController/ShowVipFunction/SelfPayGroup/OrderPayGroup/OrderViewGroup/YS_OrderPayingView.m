//
//  YS_OrderPayingView.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/6.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "YS_OrderPayingView.h"
@interface YS_OrderPayingView ()
{
    UILabel *productLabel;//产品名称
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
    //时间条
    UIView *timeView;
    UILabel *titleLabel;
    UILabel *timeDisplayLabel;
    //分割线
    UIView *allView;
    
    //按钮
    UIButton *payButton;
}
@end
@implementation YS_OrderPayingView

+(instancetype)orderOverInfoWithFrame:(CGRect)frame AndInfoModel:(YS_HistoryOrderModel *)model{
    YS_OrderPayingView *view=[[YS_OrderPayingView alloc]initWithFrame:[[UIScreen mainScreen] bounds] withInfoModel:model];
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
    //时间条
    timeView=[[UIView alloc]init];
    timeView.backgroundColor=kUIColorFromRGB(0xf0ebf2);
    titleLabel=[[UILabel alloc]init];
    
    titleLabel.font=MyFont(14);
    titleLabel.textColor=kUIColorFromRGB(0x323232);
    titleLabel.text=@"订单剩余支付时间";
    timeDisplayLabel=[[UILabel alloc]init];
    
    NSTimeZone *zone=[NSTimeZone localTimeZone];
    NSInteger offset=[zone secondsFromGMT];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateover=[dateFormatter dateFromString:model.b136];
    NSDate *dateNew=[[NSDate alloc] init];
    
    NSTimeInterval timeee=[dateover timeIntervalSinceDate:dateNew];
    
    __block int timeout = timeee;
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (timeout<0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                timeDisplayLabel.text=[NSString stringWithFormat:@"0:0:0",nil];
                if (nil!=_delegate&& [_delegate respondsToSelector:@selector(noticeInvalid)]) {
                    [_delegate noticeInvalid];//订单无效
                }
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                timeDisplayLabel.text=[NSString stringWithFormat:@"%d:%d:%d",timeout/3600,(timeout/60)%60,timeout%60,nil];
            });
            
            timeout--;
        }
    });
    dispatch_resume(timer);
    timeDisplayLabel.textAlignment=NSTextAlignmentCenter;
    timeDisplayLabel.textColor=kUIColorFromRGB(0xe62739);
    [titleLabel addSubview:timeDisplayLabel];
    [timeView addSubview:titleLabel];
    [self addSubview:timeView];
    
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
    discountLabel.text=[NSString stringWithFormat:@"%@ 折",model.b128,nil] ;
    discountLabel.textColor=kUIColorFromRGB(0xe62739);
    discountLabel.font=MyFont(13);
    [self addSubview:discountLabel];
    
    //分割线
    allView=[[UIView alloc]init];
    allView.backgroundColor=kUIColorFromRGB(0xebe8ed);
    [self addSubview:allView];
    //分割线
    leftView=[[UIView alloc]init];
    leftView.backgroundColor=kUIColorFromRGB(0xebe8ed);
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
        case 3:
        {
            payStatusText.text=@"待支付";
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
    rightView.backgroundColor=kUIColorFromRGB(0xebe8ed);
    [self addSubview:rightView];
    
    
    
    //价格
    originalCost=[[UILabel alloc]init];
    originalCost.text=@"原价";
    originalCost.font=MyFont(13);
    originalCost.textColor=kUIColorFromRGB(0x737171);
    [self addSubview:originalCost];
    
    originalCostLabel=[[UILabel alloc]init];
    originalCostLabel.textAlignment=NSTextAlignmentRight;
    originalCostLabel.text=[NSString stringWithFormat:@"%.1f元",[model.b129 floatValue],nil];
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
    discountPriceLabel.text=[NSString stringWithFormat:@"-%.1f元",[model.b123 floatValue]*(10-[model.b128 floatValue]),nil];
    discountPriceLabel.textColor=kUIColorFromRGB(0xe62739);
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
    lastPriceLabel.text=[NSString stringWithFormat:@"%.1f元",[model.b129 floatValue],nil];
    lastPriceLabel.textColor=kUIColorFromRGB(0x737171);
    lastPriceLabel.font=MyFont(13);
    [self addSubview:lastPriceLabel];
    
    payButton=[[UIButton alloc]init];
    [payButton setTintColor:[UIColor whiteColor]];
    [payButton setTitle:[NSString stringWithFormat:@"确认支付%.1f元",[model.b129 floatValue],nil] forState:(UIControlStateNormal)];
    payButton.layer.cornerRadius=20;
    payButton.layer.masksToBounds=YES;
    payButton.backgroundColor=kUIColorFromRGB(0x934de6);
    [payButton addTarget:self action:@selector(PayAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:payButton];
    
}
- (void)PayAction{
    if (nil!=_delegate&& [_delegate respondsToSelector:@selector(noticeToPay)]) {
        [_delegate noticeToPay];//支付
    }
}
-(void)layoutSubviews{
    timeView.frame=CGRectMake(0, 20, ScreenWidth, 40);
    titleLabel.frame=CGRectMake(10, 10, CGRectGetWidth(timeView.frame)-100, 20);
    timeDisplayLabel.frame=CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, 80, 20);
    
    payStatusText.frame=CGRectMake(CGRectGetMidX([[UIScreen mainScreen] bounds])-50, CGRectGetMaxY(timeView.frame)+30, 100, 21);
    leftView.frame = CGRectMake(CGRectGetMinX(payStatusText.frame)-90, CGRectGetMinY(payStatusText.frame)+10, 80, 1);
    rightView.frame = CGRectMake(CGRectGetMaxX(payStatusText.frame)+10, CGRectGetMinY(payStatusText.frame)+10, 80, 1);
    
    
    productText.frame=CGRectMake(20, CGRectGetMaxY(payStatusText.frame)+20, (ScreenWidth-40)/2, 25);
    productLabel.frame=CGRectMake(CGRectGetMaxX(productText.frame),CGRectGetMinY(productText.frame), (ScreenWidth-40)/2, 25);
    
    discountText.frame=CGRectMake(20, CGRectGetMaxY(productText.frame)+5, (ScreenWidth-40)/2, 21);
    discountLabel.frame=CGRectMake(CGRectGetMaxX(discountText.frame), CGRectGetMinY(discountText.frame), (ScreenWidth-40)/2, 21);
    
    //分割
    allView.frame=CGRectMake(0, CGRectGetMaxY(discountText.frame)+10, ScreenWidth, 1);
    
    originalCost.frame =CGRectMake(20, CGRectGetMaxY(allView.frame)+20, (ScreenWidth-40)/2, 25);
    originalCostLabel.frame = CGRectMake(CGRectGetMaxX(originalCost.frame), CGRectGetMinY(originalCost.frame), (ScreenWidth-40)/2, 25);
    
    discountPriceText.frame =CGRectMake(20, CGRectGetMaxY(originalCost.frame)+5, (ScreenWidth-40)/2, 25);
    discountPriceLabel.frame = CGRectMake(CGRectGetMaxX(discountPriceText.frame), CGRectGetMinY(discountPriceText.frame), (ScreenWidth-40)/2, 25);
    
    typeLabel.frame =CGRectMake(20, CGRectGetMaxY(discountPriceText.frame)+5, (ScreenWidth-40)/2, 25);
    lastPriceLabel.frame = CGRectMake(CGRectGetMaxX(typeLabel.frame), CGRectGetMinY(typeLabel.frame), (ScreenWidth-40)/2, 25);
    
    payButton.frame =CGRectMake(CGRectGetMidX([[UIScreen mainScreen] bounds])-150, CGRectGetMaxY(typeLabel.frame)+35, 300, 40);
    
}

@end
