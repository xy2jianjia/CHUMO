//
//  YS_BindingThirdViewController.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/4/26.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "YS_BindingThirdViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"

@interface YS_BindingThirdViewController ()<UITextFieldDelegate,TencentSessionDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *ThirdIconImageView;
@property (weak, nonatomic) IBOutlet UISwitch *openSwitch;//开发按钮
@property (weak, nonatomic) IBOutlet UIButton *updateButton;//绑定,更新按钮
@property (weak, nonatomic) IBOutlet UILabel *isBindingLabel;//QQ微信是否绑定
@property (weak, nonatomic) IBOutlet UILabel *bindFlagLabel;//绑定状态
@property (weak, nonatomic) IBOutlet UILabel *bingActionLabel;//账号
@property (weak, nonatomic) IBOutlet UITextField *setBindAccountField;//修改账号
@property (strong,nonatomic)TencentOAuth *tencentOAuth;
@property (strong,nonatomic)NSArray *permissions;
@property (strong,nonatomic)NSMutableDictionary *BindingDict;
@property (strong,nonatomic)NSMutableString *Account;
@property (strong,nonatomic)NSMutableString *AccountState;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdIconWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconBoomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTopSpace;

@end

@implementation YS_BindingThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttribute];
    //增加监听，当键盘出现或改变时收出消息
    if (iPhone4) {
        self.iconTopSpace.constant=20;
        self.iconBoomSpace.constant=20;
        self.thirdIconWidth.constant=60;
    }else if(iPhone5){
        self.iconTopSpace.constant=40;
        self.iconBoomSpace.constant=40;
        self.thirdIconWidth.constant=80;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //增加监听，当键退出时收出消息
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [Mynotification addObserver:self selector:@selector(userInfoOfWeiXin:) name:@"NoteBindWXAction" object:nil];
    
    [Mynotification addObserver:self selector:@selector(uploadIntro:) name:@"uploadIntro" object:nil];
    // Do any additional setup after loading the view from its nib.
}
- (void)uploadIntro:(NSNotification *)sender{
    NSNumber *msg=sender.object;
    if ([msg integerValue]==200) {
        [self showHint:@"保存成功"];
    }else{
        [self showHint:@"保存失败"];
    }
    
}
#pragma mark 键盘事件处理
//键盘出现
- (void)keyboardWillShow:(NSNotification *)aNotification{
    CGRect rect=self.view.frame;
    rect.origin.y=-100;
    if (iPhone4) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [UIView animateWithDuration:1 animations:^{
            
            self.view.frame=rect;
        }];
    }
    
    
}
//键盘消失
- (void)keyboardWillHide:(id)sender{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [UIView animateWithDuration:1 animations:^{
        self.view.frame=CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]));
    }];
}
-(void)dealloc{
    [Mynotification removeObserver:self];
}
- (void)setAttribute{
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"affirm"] style:(UIBarButtonItemStyleDone) target:self action:@selector(setUserContactInfo:)];
    
    self.updateButton.layer.masksToBounds=YES;
    self.updateButton.layer.cornerRadius=10;
    
    
    self.bindFlagLabel.text=@"未绑定";
    self.openSwitch.selected=YES;
    self.setBindAccountField.returnKeyType=UIReturnKeyDone;
    self.setBindAccountField.delegate=self;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.BindingDict=[NSMutableDictionary dictionary];
    self.Account = [NSMutableString string];
    self.AccountState = [NSMutableString string];
    
    switch (self.ThirdBindFlag) {
        case ThirdBindingEnumQQ:
        {
            self.BindingDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"QQBindingInfo"];
            self.Account = [[NSUserDefaults standardUserDefaults] objectForKey:@"QQBindedAccount"];
            self.AccountState = [[NSUserDefaults standardUserDefaults] objectForKey:@"QQBindedAccountState"];
            self.navigationItem.title=@"绑定QQ";
            self.ThirdIconImageView.image=[UIImage imageNamed:@"chatu"];
            self.isBindingLabel.text=@"QQ状态:";
            self.bingActionLabel.text=@"QQ号:";
            self.setBindAccountField.text=[userDefaults objectForKey:@"QQBindedAccount"];
            self.setBindAccountField.placeholder=@"输入QQ号,让别人更容易找到你!";
            self.setBindAccountField.text=self.Account;
            
        }
            break;
        case ThirdBindingEnumWX:
        {
            self.BindingDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"WXBindingInfo"];
            self.Account = [[NSUserDefaults standardUserDefaults] objectForKey:@"WXBindedAccount"];
            self.AccountState = [[NSUserDefaults standardUserDefaults] objectForKey:@"WXBindedAccountState"];
            self.navigationItem.title=@"绑定微信";
            self.ThirdIconImageView.image=[UIImage imageNamed:@"chahu"];
            self.isBindingLabel.text=@"微信状态:";
            self.bingActionLabel.text=@"微信号:";
            self.setBindAccountField.text=self.Account;
            self.setBindAccountField.placeholder=@"输入微信号,让别人更容易找到你!";
            
        }
            break;
            
        default:
            break;
    }
    if (nil!=self.BindingDict) {
        [self.updateButton setTitle:@"更新" forState:(UIControlStateNormal)];
        self.bindFlagLabel.text=@"已绑定";
    }else{
        [self.updateButton setTitle:@"绑定" forState:(UIControlStateNormal)];
        self.bindFlagLabel.text=@"未绑定";
    }
    if ([self.AccountState integerValue]==1) {
        self.openSwitch.selected=YES;
    }else{
        self.openSwitch.selected=NO;
    }
    [self.updateButton addTarget:self action:@selector(canEditAction:) forControlEvents:(UIControlEventTouchUpInside)];
}
//设置QQ,微信号
- (void) setUserContactInfo:(UIButton*)sender{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSMutableDictionary *dicts=[NSMutableDictionary dictionary];
    
    
    //@"a156",@"a158"QQ
    //@"a157",@"a159"微信
    NSString *isOpen=@"2";//显示
    if (self.openSwitch.isOn) {
        isOpen=@"1";//隐藏
    }
    switch (_ThirdBindFlag) {
        case ThirdBindingEnumQQ:
        {
            dicts[@"a156"]=self.setBindAccountField.text;
            dicts[@"a158"]=isOpen;
        }
            break;
        case ThirdBindingEnumWX:
        {
            dicts[@"a157"]=self.setBindAccountField.text;
            dicts[@"a159"]=isOpen;
            
        }
            break;
        default:
            break;
    }
    [NSURLObject addWithVariableDic:dicts];
    
    [NSURLObject addWithdict:dicts urlStr:[NSString stringWithFormat:@"%@f_108_11_2.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo]];  // 上传服务器
    //设置绑定账号
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    switch (_ThirdBindFlag) {
        case ThirdBindingEnumQQ:
        {
            [userDefaults setObject:self.setBindAccountField.text forKey:@"QQBindedAccount"];
            [userDefaults setObject:self.setBindAccountField.text forKey:@"QQBindedAccountState"];
        }
            break;
        case ThirdBindingEnumWX:
        {
            [userDefaults setObject:self.setBindAccountField.text forKey:@"WXBindedAccount"];
            [userDefaults setObject:self.setBindAccountField.text forKey:@"WXBindedAccountState"];
        }
            break;
            
        default:
            break;
    }
    
    [userDefaults synchronize];
}
//去授权
- (void)canEditAction:(UIButton *)sender{
    switch (_ThirdBindFlag) {
        case ThirdBindingEnumQQ:
        {
            self.tencentOAuth=[[TencentOAuth alloc]initWithAppId:@"1104937933"andDelegate:self];
            _permissions = [NSArray arrayWithObjects:@"get_user_info",@"get_simple_userinfo", @"add_t", nil];
            [self.tencentOAuth authorize:_permissions inSafari:NO];
        }
            break;
        case ThirdBindingEnumWX:
        {
            if ([WXApi isWXAppInstalled]) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setBool:YES forKey:@"WXisSendBinding"];
                [userDefaults synchronize];
                
                SendAuthReq *req =[[SendAuthReq alloc ] init];
                req.scope = @"snsapi_userinfo"; // 此处不能随意改
                req.state = @"123"; // 这个貌似没影响
                

                [WXApi sendReq:req];
            }else{
                [self alertViewOfTitle:@"未检测到微信客户端" msg:@"请尝试其他绑定" ispopToRoot:NO];
            }
            
        }
            break;
            
        default:
            break;
    }
    
    
}

//授权
- (void)tencentDidLogin
{

    if (self.tencentOAuth.accessToken && 0 != [self.tencentOAuth.accessToken length])
    {
        [self.tencentOAuth getUserInfo];//这个方法返回BOOL
    }
    else
    {
        NSLog(@"登录不成功 没有获取accesstoken");
        
    }
    
}
//QQ信息url
-(void)getUserInfoResponse:(APIResponse *)response
{
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
    NSString *userId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]];
    NSString *sessionId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"sessionId"]];
    NSString *userName= [NSString stringWithFormat:@"%@",[dict objectForKey:@"userName"]];
    NSString *password= [NSString stringWithFormat:@"%@",[dict objectForKey:@"password"]];
    
    NSString *type=[NSString stringWithFormat:@"%ld",_ThirdBindFlag];
    
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    NSString *sex = nil;
    if ([[response.jsonResponse objectForKey:@"gender"] isEqualToString:@"男"]) {
        sex=@"1";
    }else if([[response.jsonResponse objectForKey:@"gender"] isEqualToString:@"女"]){
        sex=@"2";
    }else{
        sex=@"0";
    }
    
    NSString *url = nil;
    if (nil!=self.BindingDict) {
        //
        url = [NSString stringWithFormat:@"%@f_132_14_1.service?a162=%@&a167=%@&a34=%@&p2=%@&p1=%@&%@",kServerAddressTest4,type,self.tencentOAuth.openId,[self.BindingDict objectForKey:@"b34"],userId,sessionId,appinfoStr];
    }else{
        url = [NSString stringWithFormat:@"%@f_132_11_1.service?a162=%@&a167=%@&a163=%@&a56=%@&a164=%@&a165=%@&a166=%@&p2=%@&p1=%@&%@",kServerAddressTest4,type,self.tencentOAuth.openId,userName,password,[response.jsonResponse objectForKey:@"nickname"],sex,[response.jsonResponse objectForKey:@"figureurl_qq_1"],userId,sessionId,appinfoStr];
        
        
    }
    
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [self requestLicence:url];
    
}

//非网络错误导致登录失败：

-(void)tencentDidNotLogin:(BOOL)cancelled
{
    
    NSLog(@"tencentDidNotLogin");
    if (cancelled)
    {
        NSLog(@"取消登陆");
    }else{
        NSLog(@"取消登陆");
    }
    
}
// 网络错误导致登录失败：

-(void)tencentDidNotNetWork

{
    NSLog(@"无网络连接，请设置网络");

}
//微信信息URL
- (void) userInfoOfWeiXin:(NSNotification *)sender{
    NSDictionary *dict=sender.object;
    NSDictionary *userdict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
    NSString *userId= [NSString stringWithFormat:@"%@",[userdict objectForKey:@"userId"]];
    NSString *sessionId= [NSString stringWithFormat:@"%@",[userdict objectForKey:@"sessionId"]];
    NSString *userName= [NSString stringWithFormat:@"%@",[userdict objectForKey:@"userName"]];
    NSString *password= [NSString stringWithFormat:@"%@",[userdict objectForKey:@"password"]];
    
    NSString *type=[NSString stringWithFormat:@"%ld",_ThirdBindFlag];
    
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    NSString *url = nil;
    if (nil!=self.BindingDict) {

        url = [NSString stringWithFormat:@"%@f_132_14_1.service?a162=%@&a167=%@&a34=%@&p2=%@&p1=%@&%@",kServerAddressTest4,type,[dict objectForKey:@"openid"],[self.BindingDict objectForKey:@"b34"],userId,sessionId,appinfoStr];
    }else{
        url = [NSString stringWithFormat:@"%@f_132_11_1.service?a162=%@&a167=%@&a163=%@&a56=%@&a164=%@&a165=%@&a166=%@&p2=%@&p1=%@&%@",kServerAddressTest4,type,[dict objectForKey:@"openid"],userName,password,[dict objectForKey:@"nickname"],[dict objectForKey:@"sex"],[dict objectForKey:@"headimgurl"],userId,sessionId,appinfoStr];
        
        
    }
    
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [self requestLicence:url];
}
#pragma mark 请求信息
- (void)requestLicence:(NSString *)url{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    __weak YS_BindingThirdViewController *BingVC=self;
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum=infoDic[@"code"];
        if ([codeNum integerValue]==200) {
            
            BingVC.bindFlagLabel.text=@"已绑定";
            [BingVC.updateButton setTitle:@"更新" forState:(UIControlStateNormal)];
            [BingVC alertViewOfTitle:@"绑定成功" msg:@"可以使用该账号了!" ispopToRoot:YES];
        }else{
            [BingVC alertViewOfTitle:@"绑定失败" msg:infoDic[@"msg"] ispopToRoot:NO];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.setBindAccountField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.setBindAccountField resignFirstResponder];
}
- (void) alertViewOfTitle:(NSString *)title msg:(NSString *)msg ispopToRoot:(BOOL)isPop{
    UIAlertController *alertC=[UIAlertController alertControllerWithTitle:title message:msg preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *yesAction=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        if (isPop) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    [alertC addAction:yesAction];
    [self presentViewController:alertC animated:YES completion:nil];
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
