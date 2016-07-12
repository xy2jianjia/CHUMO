//
//  Agreement.m
//  StrangerChat
//
//  Created by zxs on 16/1/8.
//  Copyright © 2016年 long. All rights reserved.
//

#import "Agreement.h"
#import "AgreemCell.h"
@interface Agreement ()<UITableViewDelegate,UITableViewDataSource> {
    
    UITableView *wxPaytabel;
    NSString *contentStr;
    CGFloat heightAgreement;
    NSDictionary *serviceArr;
}

@end

@implementation Agreement

- (void)viewDidLoad {
    [super viewDidLoad];

    [self tableViewReques];
    [self agreementRequest];
    
}

- (void)agreementRequest {

    
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_116_10_1.service?a78=%@&p1=%@&p2=%@&%@",kServerAddressTest2,@"1001",p1,p2,appInfo];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            serviceArr=infoDic[@"body"];
        }
        NSLog(@"%@",infoDic);
        [wxPaytabel reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"系统参数请求失败--%@-",error);
    }];
}

- (void)tableViewReques {

    wxPaytabel = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:(UITableViewStylePlain)];
    wxPaytabel.separatorStyle = UITableViewCellSelectionStyleNone;
    wxPaytabel.delegate = self;
    wxPaytabel.dataSource = self;
    [wxPaytabel registerClass:[AgreemCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:wxPaytabel];

}

#pragma mark - UITabelView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AgreemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    contentStr=serviceArr[@"b14"];
    cell.contentLabel.text = contentStr;
    heightAgreement =[self hightForContent:contentStr fontSize:13.0f];
    CGRect temp = cell.contentLabel.frame;
    temp.size.height = heightAgreement;
    cell.contentLabel.frame = temp;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return heightAgreement;
}

#pragma mark ---- 自适应高度
- (CGFloat)hightForContent:(NSString *)content fontSize:(CGFloat)fontSize{
    CGSize size = [content boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
