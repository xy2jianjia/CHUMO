//
//  NewPasswrodController.m
//  StrangerChat
//
//  Created by zxs on 15/11/28.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "NewPasswrodController.h"
#import "NResetController.h"
#import "AccountController.h"
#import "PassView.h"
#define kAlphaNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kAlpha      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define kNumbers     @"0123456789"
#define kNumbersPeriod  @"0123456789."

@interface NewPasswrodController ()<UITextFieldDelegate>
@property (nonatomic,strong)PassView *pv;
@property (nonatomic,strong)NSString *photoNumContent;
@property (nonatomic,strong)NSString *verificationContent;
@end

@implementation NewPasswrodController

- (void)loadView {

    self.pv = [[PassView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.pv.backgroundColor=[UIColor whiteColor];
    self.view = self.pv;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationLR];
    self.pv.photoNum.delegate = self;
    self.pv.verification.delegate = self;
    [self.pv addWithphoto:@"新密码" verificat:@"确认新密码"];
    [self.pv.photoNum addTarget:self action:@selector(photoNumEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.pv.verification addTarget:self action:@selector(verificationEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.pv.submitButton addTarget:self action:@selector(rightAction:) forControlEvents:(UIControlEventTouchUpInside)];
}



#pragma mark -- 获取photoNum输入内容
- (void)photoNumEditChanged:(UITextField *)textField{
    self.photoNumContent = textField.text;
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    NSString *filtered =
    [[textField.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    if ([textField.text isEqualToString:filtered]) {
        NSLog(@"不是中文请继续");
        // 长度大于6 <16的数字和字母
    }else {
        NSLog(@"请不要输入中文");
        textField.text = @"";
    }
}

#pragma mark -- 获取verification输入内容
- (void)verificationEditChanged:(UITextField *)textField

{
    self.verificationContent = textField.text;

}


#pragma mark -- navigationLR
- (void)navigationLR {
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
}

#pragma mark -- left
- (void)leftAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction:(UIBarButtonItem *)sender {
    [self.pv.photoNum resignFirstResponder];
    [self.pv.verification resignFirstResponder];
    if (self.verificationContent.length < 6) {
        [self showHint:@"您输入的密码小于6位数"];
    }else if (self.verificationContent.length > 16){
        [self showHint:@"您输入的密码大于16位数"];
    }else { // 判断是否为同一账号密码
        if ([self.verificationContent isEqualToString:self.photoNumContent]) { // 确认两次的密码相同
            
            [self updatePassword];
        }else {
            [self showHint:@"输入的密码不相符"];
        }
    }
    
}
/**
 *  修改密码 LP-file-msc/f_120_15_1.service?a81电话号码,a56密码,a115确认密码;a93短信验证码;p2,p1
 *
 */
- (void)updatePassword{
    NSString *AccountId = [NSString stringWithFormat:@"%@",[NSGetTools getUserAccount]];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sessonId = [NSGetTools getUserSessionId];
    __block NSString *password = self.pv.photoNum.text;
    NSString *repassword = self.pv.verification.text;
    if ([password length] == 0 || [repassword length] == 0) {
        [self showHint:@"请输入密码和确认密码!"];
        return;
    }
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    NSString *url = [NSString stringWithFormat:@"%@f_120_15_1.service?a81=%@&a56=%@&a115=%@&a93=%@&p1=%@&p2=%@&%@",kServerAddressTest, _phoneNumber, password,repassword,_verifyCode,sessonId,userId,appinfoStr];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];

        if ([codeNum integerValue] == 200) {
            [self showHint:@"密码已修改，请重新登录"];
            [NSGetTools updateUserPassWord:password];
            dispatch_async(dispatch_get_main_queue(), ^{
                DHLoginUserForListModel *model =[[DHLoginUserForListModel alloc]init];
                model.passWord=password;
                model.userId=userId;
                model.sessionId=sessonId;
                model.userName=AccountId;
                [DHLoginUserDao updateLoginUserToDbWithPassWord:model];
            });
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loaded"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [Mynotification postNotificationName:@"loginStateChange" object:nil];

            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showHint:[NSString stringWithFormat:@"密码修改失败：%@" ,[infoDic objectForKey:@"msg"]]];
            });
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [NSGetTools showAlert:@"系统出错，请反馈给我们，谢谢！"];
        });
        
    }];
    
    
    
    
    
}

#pragma mark --- 当用户全部清空的时候的时候 会调用
-(BOOL)textFieldShouldClear:(UITextField *)textField {
    
    self.pv.photoNum.placeholder = @"密码长度6~16位,由数字和字母组成";
    self.pv.verification.placeholder = @"再次输入密码";
    return true;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
