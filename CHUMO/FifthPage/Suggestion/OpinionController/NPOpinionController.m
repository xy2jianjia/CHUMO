//
//  NPOpinionController.m
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "NPOpinionController.h"
#import "OpinionView.h"
@interface NPOpinionController ()<UITextViewDelegate> {
    
    NSString *textViewStr;
    UILabel *placeHolderLabel;
} 
@property (nonatomic,strong)OpinionView *pv;
@end

@implementation NPOpinionController
- (void)loadView {
    
    self.pv = [[OpinionView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = self.pv;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SEL sel = @selector(didCommit:);
    [Mynotification addObserver:self selector:sel name:@"didCommit" object:nil];
    
    [self sethideKeyBoardAccessoryView];
    [self placeholder];
    [self n_button];
//    [self setInputAccessory];
    self.pv.feedback.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.pv addDataWithtitle:@"客服电话:400-9011-190  客服QQ:3350977469"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-arrow"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
}
- (void)didCommit:(NSNotification *)notifi{
    NSNumber *code = notifi.object;
    if ([code integerValue] == 200) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showHint:@"意见已经提交，感谢对触陌的支持和监督~"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showHint:@"提交失败，请确保网络通畅~"];
        });
    }
}
- (void)sethideKeyBoardAccessoryView{
    UIView *accessoryView = [[UIView alloc]init];
    accessoryView.frame = CGRectMake(0, 0, ScreenWidth, 30);
    accessoryView.backgroundColor = [UIColor colorWithWhite:0.900 alpha:1];
    UIButton *doneBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    doneBtn.frame = CGRectMake(CGRectGetMaxX(accessoryView.bounds) - 50, CGRectGetMinY(accessoryView.bounds), 40,30);
    //    doneBtn.backgroundColor = [UIColor grayColor];
    [doneBtn setTitle:@"完成" forState:(UIControlStateNormal)];
    [doneBtn setTitleColor:[UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000] forState:(UIControlStateNormal)];
    [doneBtn addTarget:self action:@selector(hideKeyboard) forControlEvents:(UIControlEventTouchUpInside)];
    [accessoryView addSubview:doneBtn];
    self.pv.feedback.inputAccessoryView = accessoryView;
//    self.nv.verification.inputAccessoryView = accessoryView;
}
- (void)leftAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:true];
}
#pragma mark ---- button
- (void)n_button {
    
    [self.pv.submit setTitle:@"提交" forState:(UIControlStateNormal)];
    [self.pv.submit addTarget:self action:@selector(submitAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)submitAction:(UIButton *)sender {
    [self hideKeyboard];
    NSString *m11 = [NSGetTools getCurrentDevice];// 手机型号
    NSString *m5 = [NSGetTools getAppVersion];// 应用版本号
    NSString *m8 = [[UIDevice currentDevice] systemVersion];// 系统版本号
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSMutableDictionary *allDict = [NSMutableDictionary dictionary];
    if ([textViewStr length] == 0 || textViewStr == nil || [textViewStr isEqualToString:@"(null)"]) {
        [self showHint:@"请输入您需要反馈的问题~"];
        return;
    }
    if (MyJudgeNull(self.pv.contactInfo.text)) {
        [self showHint:@"请输入您的联系方式~"];
        return;
    }
    [allDict setObject:textViewStr forKey:@"a14"];
    [allDict setObject:@"2" forKey:@"a61"];  // 2 ---IOS
    [allDict setObject:m5 forKey:@"a2"];
    [allDict setObject:m11 forKey:@"a49"];
    [allDict setObject:m8 forKey:@"a68"];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"];
    NSString *b81 =  [[dict objectForKey:@"b112"] objectForKey:@"b81"];
    if (b81) {
        [allDict setObject:b81 forKey:@"a81"];
    }
    [NSURLObject addWithdict:allDict urlStr:[NSString stringWithFormat:@"%@f_103_10_2.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo]];  // 上传服务器
}

- (void)placeholder {

    //TextView占位符
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 7, 400/2, 20)];
    placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    placeHolderLabel.font = [UIFont systemFontOfSize:15.0f];
    placeHolderLabel.textColor = kUIColorFromRGB(0xaaaaaa);
    placeHolderLabel.alpha = 0;
    placeHolderLabel.tag = 999;
    placeHolderLabel.text = @"请输入您需要反馈的问题";
    [self.pv.feedback addSubview:placeHolderLabel];
    if ([[self.pv.feedback text] length] == 0) {
        [[self.pv.feedback viewWithTag:999] setAlpha:1];
    }
    
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
                                                  target:self action:@selector(hideKeyboard)];
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    [self.pv.feedback
     setInputAccessoryView:topView];
    
}
- (void)hideKeyboard
{
    [self.pv.feedback resignFirstResponder];
    [self.pv.contactInfo resignFirstResponder];
}

//结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    textViewStr = textView.text;
}


//输入框要编辑的时候
- (void)textChanged:(NSNotification *)notification
{
    if ([[self.pv.feedback text] length] == 0) {
        [[self.pv.feedback viewWithTag:999] setAlpha:1];
    }
    else {
        
//        NSString * toBeString = [self.pv.feedback text];
//        if ([toBeString length]>5 ) {
//            self.pv.feedback.text=[toBeString substringWithRange:NSMakeRange(0, 5)];
//        }
        UITextView * textView = (UITextView *)notification.object;
        NSString * toBeString = textView.text;
        NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];//键盘输入模式
        if ([lang isEqualToString:@"zh-Hans"]) {//中文输入,五笔,拼音等..
            UITextRange *range = [textView markedTextRange];
            //获取高亮部分
            UITextPosition *postion = [textView positionFromPosition:range.start offset:0];
            if (!postion) {//没有高亮
                if ([toBeString length]>100) {
                    self.pv.feedback.text = [toBeString substringWithRange:NSMakeRange(0, 100)];
                }
            }else{//有高亮
                
            }
        }else{
            if ([toBeString length]>100) {
                self.pv.feedback.text = [toBeString substringWithRange:NSMakeRange(0, 100)];
            }
        }
        [[self.pv.feedback viewWithTag:999] setAlpha:0];
    }
}

// 点击空白处隐藏按钮
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.pv.feedback resignFirstResponder];
    [self.pv.contactInfo resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    [Mynotification removeObserver:self];
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
