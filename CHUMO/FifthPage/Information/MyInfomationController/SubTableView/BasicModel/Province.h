//
//  Province.h
//  StrangerChat
//
//  Created by zxs on 15/12/11.
//  Copyright © 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Province : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)NSArray *cities;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)provinceWithDict:(NSDictionary *)dict;
@end
