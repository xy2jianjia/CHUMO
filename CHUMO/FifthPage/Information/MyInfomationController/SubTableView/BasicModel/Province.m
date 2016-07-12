//
//  Province.m
//  StrangerChat
//
//  Created by zxs on 15/12/11.
//  Copyright © 2015年 long. All rights reserved.
//

#import "Province.h"

@implementation Province
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}
+(instancetype)provinceWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
