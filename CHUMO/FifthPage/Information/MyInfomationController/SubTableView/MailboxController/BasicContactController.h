//
//  BasicContactController.h
//  CHUMO
//
//  Created by 朱瀦潴 on 16/2/22.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ContactBlock) (NSString *,NSString *);
@interface BasicContactController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;//联系方式
@property (weak, nonatomic) IBOutlet UISwitch *openSwitch;//是否开放
@property (nonatomic,strong)NSString *contactText;//内容
@property (nonatomic,assign)NSString *openFlag;//开放标志
@property (nonatomic,copy)ContactBlock CBlock;//回传
@property (nonatomic,strong)NSString *titleItem;//标题
@end
