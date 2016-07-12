//
//  NConditonModel.h
//  StrangerChat
//
//  Created by zxs on 15/12/29.
//  Copyright © 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NConditonModel : NSObject
@property (nonatomic,strong)NSNumber *id;         // b34
@property (nonatomic,strong)NSString *city;       // b9  市
@property (nonatomic,strong)NSString *proVince;   // b67 省
@property (nonatomic,strong)NSString *age;        // b1
@property (nonatomic,strong)NSString *wage;       // b85 收入范围
@property (nonatomic,strong)NSString *education;  // b19 学历
@property (nonatomic,strong)NSString *heights;    // b33 身高
@property (nonatomic,strong)NSString *userid;     // b80
@property (nonatomic,strong)NSString *marriage;   // b46 婚姻状态
@end
