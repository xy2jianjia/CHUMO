//
//  DHDomainModel.h
//  CHUMO
//
//  Created by xy2 on 16/3/9.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHDomainModel : NSObject

/**
 *  apiId
 */
@property (nonatomic,copy) NSString *apiId;
/**
 *  api
 */
@property (nonatomic,copy) NSString *api;
/**
 *  api别名
 */
@property (nonatomic,copy) NSString *apiName;
/**
 *  api类型：194：内网测试；195：内网测试；115：外网测试；1：外网域名；0：备用域名
 */
@property (nonatomic,copy) NSString *apiType;

@end
