//
//  HttpOperation.h
//  RobotMechanism
//
//  Created by xy2 on 16/4/11.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "HZApi.h"
@interface RobotHttpOperation : NSObject
- (AFHTTPRequestOperationManager *)configOperation;
- (id)asyncparseJSONDataToNSDictionary:(NSData *)jsonData;

@end
