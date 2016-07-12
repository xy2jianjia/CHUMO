//
//  FriendController.m
//  StrangerChat
//
//  Created by zxs on 15/11/24.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "FriendController.h"
#import "FriendView.h"
@interface FriendController ()<UITextViewDelegate> {

    NSString *textViewStr;

}
@property (nonatomic,strong)FriendView *friend;
@end

@implementation FriendController

- (void)loadView {

    self.friend = [[FriendView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = self.friend;
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self n_barbutton];
//    [self setInputAccessory];
    [self sethideKeyBoardAccessoryView];
    self.view.backgroundColor = [UIColor colorWithRed:0.941 green:0.929 blue:0.949 alpha:1.000];
    self.friend.contentView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = false;  
    self.title = @"交友宣言";
    [self.friend addWithText:@"用心、真诚的独白,会获得大家的共鸣,容易打动TA的心"];
//    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"];
//    NSString *intro = [[userDict objectForKey:@"b112"] objectForKey:@"b17"];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
    NSString *intro = userInfo.b17;
    self.friend.contentView.text = intro;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    [Mynotification addObserver:self selector:@selector(uploadIntro:) name:@"uploadIntro" object:nil];
    
}
/**
 *  保存到服务器返回数据
 *
 *  @param notifi
 */
- (void)uploadIntro:(NSNotification *)notifi{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber *code = notifi.object;
        if ([code integerValue] == 200) {
            self.friend.contentView.text = textViewStr;
            [self showHint:[NSString stringWithFormat:@"提交成功，正在审核中.."]];
            NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
            DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
            userInfo.b17 = textViewStr;
            [DHUserInfoDao updateUserToDBWithItem:userInfo userId:userId];
        }else{
            
           [self showHint:[NSString stringWithFormat:@"提交失败,代码：%@",code]];
        }
        
        
    });
}
/**
 *  释放键盘
 */
- (void)sethideKeyBoardAccessoryView{
    UIView *accessoryView = [[UIView alloc]init];
    accessoryView.frame = CGRectMake(0, 0, ScreenWidth, 30);
    accessoryView.backgroundColor = [UIColor colorWithWhite:0.900 alpha:1];
    UIButton *doneBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    doneBtn.frame = CGRectMake(CGRectGetMaxX(accessoryView.bounds) - 50, CGRectGetMinY(accessoryView.bounds), 40,30);
    //    doneBtn.backgroundColor = [UIColor grayColor];
    [doneBtn setTitle:@"完成" forState:(UIControlStateNormal)];
    [doneBtn setTitleColor:[UIColor colorWithRed:236/255.0 green:49/255.0 blue:88/255.0 alpha:1] forState:(UIControlStateNormal)];
    [doneBtn addTarget:self action:@selector(resignKeyboard) forControlEvents:(UIControlEventTouchUpInside)];
    [accessoryView addSubview:doneBtn];
    self.friend.contentView.inputAccessoryView = accessoryView;
    //    self.userPassTextField.inputAccessoryView = accessoryView;
}
- (void)setInputAccessory {
    
    // 在键盘上添加一个隐藏的按钮
    UIToolbar *topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 30)];
    //设置style
    [topView
     setBarStyle:UIBarStyleBlack];
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    
    UIBarButtonItem
    * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem
    * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //定义完成按钮
    UIBarButtonItem
    * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成"style:UIBarButtonItemStyleDone
                                                  target:self action:@selector(resignKeyboard)];
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    
    [topView setItems:buttonsArray];
    [self.friend.contentView setInputAccessoryView:topView];

}

- (void)resignKeyboard
{
    
    [self.friend.contentView resignFirstResponder];
    
}

- (void)leftAction {
    
    [self.navigationController popToRootViewControllerAnimated:true];
}
- (void)n_barbutton {

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"affirm"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)rightAction {
    [self resignKeyboard];
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSMutableDictionary *allDict = [NSMutableDictionary dictionary];
    textViewStr = self.friend.contentView.text;
    [allDict setObject:textViewStr forKey:@"a17"];
    [NSURLObject addWithVariableDic:allDict];
    [NSURLObject addWithdict:allDict urlStr:[NSString stringWithFormat:@"%@f_108_11_2.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo]];  // 上传服务器
}

// 点击空白处隐藏按钮
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.friend.contentView resignFirstResponder];
}

//结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    textViewStr = textView.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
