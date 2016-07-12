//
//  UserGuidedTwo.m
//  CHUMO
//
//  Created by zxs on 16/2/19.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "UserGuidedTwo.h"
#import "UserView.h"
#import "ZLPhotoPickerViewController.h"
#import "ZLPhotoAssets.h"
#import "JYNavigationController.h"
@interface UserGuidedTwo ()<PhograpDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UserView *user;
//导航条
@property (nonatomic,strong)JYNavigationController *nav;
//透明度
@property (nonatomic,assign)CGFloat alphaNum;
@end

@implementation UserGuidedTwo
- (void)loadView {
    self.user = [[UserView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.user.phograpDelegate = self;
    self.view = self.user;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.nav setAlph:self.alphaNum];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    //导航条
    self.nav = (JYNavigationController *)self.navigationController;
    //透明度
    self.alphaNum=0.0;
    [self.nav setAlph:self.alphaNum];
    [self.nav setNavigationBarBackgroundImage:@"w_wo_grzy_xpmb"];
    [self navigationRequse];
    if ([self.sex isEqualToString:@"1"]) { // 男
        [self.user.poImage setImage:[UIImage imageNamed:@"Head portrait-man"]];
        [self.user.titlePi setText:@"妹子都喜欢有头像的帅哥"];
    }else if ([self.sex isEqualToString:@"2"]) { // 女
        [self.user.poImage setImage:[UIImage imageNamed:@"Head portrait-man-1"]];
        [self.user.titlePi setText:@"帅哥都喜欢有头像的妹子"];
    }else {
        NSLog(@"人妖");
    }
    
}
- (void)leftAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)navigationRequse { // 改变导航字体
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], UITextAttributeTextColor,
                                                                     [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1], UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                                     [UIFont fontWithName:@"Arial-Bold" size:0.0], UITextAttributeFont,
                                                                     nil]];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"jump ove-box@2x(1)"] style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction:)];
}
- (void)rightAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:true completion:^{
           }];
    if (_isFromRegister) {
        dispatch_async(dispatch_get_main_queue(), ^{
             
             [Mynotification postNotificationName:@"loginStateChange" object:nil];
        });
       
    }
}

- (void)setBut:(UserView *)phoBt btTag:(NSInteger)proTag {
    switch (proTag) {
        case 100:
            
            break;
        case 101:{
            [self openCamera];
//            UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil
//                                                                      delegate:self
//                                                             cancelButtonTitle:@"取消"
//                                                        destructiveButtonTitle:nil
//                                                             otherButtonTitles:@"打开照相机",@"从手机相册获取",nil];
//            
//            [myActionSheet showInView:[UIApplication sharedApplication].keyWindow];
        }
            break;
        case 102:{
            [self openLocalPhoto];
//            UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil
//                                                                      delegate:self
//                                                             cancelButtonTitle:@"取消"
//                                                        destructiveButtonTitle:nil
//                                                             otherButtonTitles:@"打开照相机",@"从手机相册获取",nil];
//            
//            [myActionSheet showInView:[UIApplication sharedApplication].keyWindow];
        }
            break;
        default:
            break;
    }
}

#pragma mark - ActionSheet Delegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    switch (buttonIndex)
//    {
//        case 0:  //打开照相机拍照
//            [self openCamera];
//            break;
//        case 1:  //打开本地相册
//           [self openLocalPhoto];
//            break;
//    }
//}


#pragma mark - 拍照
- (void)openCamera{
    NSUInteger sourceType = 0;
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    // 拍照
    sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    [picker dismissViewControllerAnimated:YES completion:^{}];
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    NSArray *arr = [NSArray arrayWithObject:image];
//    picker.allowsEditing = NO;
//    [self uploadImageTosever:arr];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSArray *arr = [NSArray arrayWithObject:image];
    picker.allowsEditing = YES;
    [Mynotification postNotificationName:@"NotificationUploadShowHudsever" object:@"YES"];
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self uploadImageTosever:arr];
        
    }];
}

///**
// *  上传头像
// *
// *  @param assets 图片数组LP-file-msc/f_107_10_2.service？a102：图片文件流
// */
//- (void)uploadImageTosever:(NSArray *)assets{
//    for (int i = 0;i <assets.count; i ++) {
//        if ([assets[i] isKindOfClass:[UIImage class]]) {
//            [[DHTool shareTool] saveImage:assets[i] withName:[NSString stringWithFormat:@"uploadHeaderImage_%d.jpg",i+1]];
//        }else{
//            UIImage *originImage= [assets[i] originImage];
//            [[DHTool shareTool] saveImage:originImage withName:[NSString stringWithFormat:@"uploadHeaderImage_%d.jpg",i+1]];
//        }
//    }
//    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
//    NSString *sessonId = [NSGetTools getUserSessionId];
//    NSString *appinfoStr = [NSGetTools getAppInfoString];
//    if ([userId length] == 0 || [userId isEqualToString:@"(null)"] || [sessonId length] == 0 || [sessonId isEqualToString:@"(null)"]) {
//        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
//        userId = [dict objectForKey:@"userId"];
//        sessonId = [dict objectForKey:@"sessionId"];
//    }
//    
//    NSString *url = [NSString stringWithFormat:@"%@f_107_10_2.service?p1=%@&p2=%@&%@",kServerAddressTest3,sessonId,userId,appinfoStr];
//    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//    for (int i = 0; i < assets.count;  i ++) {
//        NSString *path = [[DHTool shareTool] getImagePathWithImageName:[NSString stringWithFormat:@"uploadHeaderImage_%d",i+1]];
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
//        NSData *data = UIImageJPEGRepresentation(image, 1);
////        NSData *data = UIImageJPEGRepresentation(self.imageArr[i], 1);
//        float index = 1.0;
//        while (data.length > 1024*500) {
//            data = UIImageJPEGRepresentation(image, index);
//            index = index - 0.1;
//        }
//        NSMutableData *myRequestData=[NSMutableData data];
//        //分界线 --AaB03x
//        NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
//        NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
//        //结束符 AaB03x--
//        NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
//        //        //http body的字符串
//        NSMutableString *body=[[NSMutableString alloc]init];
//        ////添加分界线，换行
//        [body appendFormat:@"%@\r\n",MPboundary];
//        [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        NSMutableString *imgbody = [[NSMutableString alloc] init];
//        ////添加分界线，换行
//        [imgbody appendFormat:@"%@\r\n",MPboundary];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyyyMMddHHmmsssss";
//        NSString *str = [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@", str];
//        //声明pic字段，文件名为数字.png，方便后面使用
//        [imgbody appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n",@"a102",fileName];
//        //声明上传文件的格式
//        //            [imgbody appendFormat:@"Content-Type: image/png\r\n\r\n"];
//        [imgbody appendFormat:@"Content-Type: application/octet-stream; charset=utf-8\r\n\r\n"];
//        //声明myRequestData，用来放入http body
//        
//        //将body字符串转化为UTF8格式的二进制
//        [myRequestData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
//        //将image的data加入
//        [myRequestData appendData:data];
//        [myRequestData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        //声明结束符：--AaB03x--
//        NSString *end=[[NSString alloc]initWithFormat:@"%@\r\n",endMPboundary];
//        //加入结束符--AaB03x--
//        [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
//        //设置HTTPHeader中Content-Type的值
//        NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
//        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
//        [request addRequestHeader:@"Content-Type" value:content];
//        //设置http body
//        [request setPostBody:myRequestData];
//        [request setRequestMethod:@"POST"];
//        [request setTimeOutSeconds:1200];
//        [request setDelegate:self];
//        [request startSynchronous];
//        NSData *resultData = request.responseData;
//        NSInteger responseCode = [request responseStatusCode];
//        NSString *result = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
//        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
//        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
//        NSNumber *codeNum = infoDic[@"code"];
//        if (responseCode == 200 && [codeNum integerValue] == 200) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self showHint:@"上传成功!"];
//                self.otherSum=1;
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTotleHobby" object:nil];
//                [self dismissViewControllerAnimated:YES completion:nil];
//                 [Mynotification postNotificationName:@"loginStateChange" object:nil];
//
//                
//            });
//        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
////                [self showHint:[infoDic objectForKey:@"msg"]];
//                NSString *msg = [infoDic objectForKey:@"msg"];
//                if (msg) {
//                    [self showHint:msg];
//                }else{
//                    [self showHint:@"上传失败，请反馈给我们或者重新登录~"];
//                }
//            });
//        }
//        
//    }
//}
/**
 *  上传头像
 *
 *  @param assets 图片数组LP-file-msc/f_107_10_2.service？a102：图片文件流
 */
- (void)uploadImageTosever:(NSArray *)assets{
    
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sessonId = [NSGetTools getUserSessionId];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    if ([userId length] == 0 || [userId isEqualToString:@"(null)"] || [sessonId length] == 0 || [sessonId isEqualToString:@"(null)"]) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
        userId = [dict objectForKey:@"userId"];
        sessonId = [dict objectForKey:@"sessionId"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@f_107_10_2.service?p1=%@&p2=%@&%@",kServerAddressTest3,sessonId,userId,appinfoStr];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    for (int i = 0; i < assets.count;  i ++) {
        
        UIImage *image=[DHTool fixOrientation:assets[i]];
        NSData *data = UIImageJPEGRepresentation(image, 1);
        float index = 1.0;
        NSInteger dataLength=data.length;
        while (dataLength > 1024*500) {
            index = index - 0.1;
            dataLength*=index;
        }
        
        data = UIImageJPEGRepresentation(image, index);
        NSMutableData *myRequestData=[NSMutableData data];
        //分界线 --AaB03x
        NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
        NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
        //结束符 AaB03x--
        NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
        //        //http body的字符串
        NSMutableString *body=[[NSMutableString alloc]init];
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableString *imgbody = [[NSMutableString alloc] init];
        ////添加分界线，换行
        [imgbody appendFormat:@"%@\r\n",MPboundary];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmsssss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@", str];
        //声明pic字段，文件名为数字.png，方便后面使用
        [imgbody appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n",@"a102",fileName];
        //声明上传文件的格式
        //            [imgbody appendFormat:@"Content-Type: image/png\r\n\r\n"];
        [imgbody appendFormat:@"Content-Type: application/octet-stream; charset=utf-8\r\n\r\n"];
        //声明myRequestData，用来放入http body
        
        //将body字符串转化为UTF8格式的二进制
        [myRequestData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
        //将image的data加入
        [myRequestData appendData:data];
        [myRequestData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        //声明结束符：--AaB03x--
        NSString *end=[[NSString alloc]initWithFormat:@"%@\r\n",endMPboundary];
        //加入结束符--AaB03x--
        [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        //设置HTTPHeader中Content-Type的值
        NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request addRequestHeader:@"Content-Type" value:content];
        //设置http body
        [request setPostBody:myRequestData];
        [request setRequestMethod:@"POST"];
        [request setTimeOutSeconds:1200];
        [request setDelegate:self];
        [request startSynchronous];
        NSData *resultData = request.responseData;
        NSInteger responseCode = [request responseStatusCode];
        NSString *result = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        if (responseCode == 200 && [codeNum integerValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showHint:@"上传成功!"];
                self.otherSum=1;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTotleHobby" object:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
                [Mynotification postNotificationName:@"loginStateChange" object:nil];
                
                
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *msg = [infoDic objectForKey:@"msg"];
                if (msg) {
                    [self showHint:msg];
                }else{
                    [self showHint:@"上传失败，请反馈给我们或者重新登录~"];
                }
                
            });
        }
        [Mynotification postNotificationName:@"NotificationUploadShowHudsever" object:@"NO"];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 本地相册
- (void)openLocalPhoto{
//    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
//    // 最多能选9张图片
//    pickerVc.maxCount = 1;
//    pickerVc.status = PickerViewShowStatusCameraRoll;
//    [pickerVc showPickerVc:self];
//    
//    __weak typeof(self) weakSelf = self;
//    pickerVc.callBack = ^(NSArray *assets){
        //        [weakSelf.imageArr addObjectsFromArray:assets];
//        [self uploadImageTosever:assets];
        //        [weakSelf.collectionView reloadData];
//    };
    
    
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 最多能选9张图片
    pickerVc.maxCount = 1;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    [pickerVc showPickerVc:self];
    
    __weak typeof(self) weakSelf = self;

    pickerVc.callBack = ^(NSArray *assets){
        //        [weakSelf.imageArr addObjectsFromArray:assets];
        NSMutableArray *imageArr=[NSMutableArray array];
        for (int i = 0;i <assets.count; i ++) {
            UIImage *originImage= [assets[i] originImage];
            [imageArr addObject:originImage];
        }
        [self uploadImageTosever:imageArr];
        //        [weakSelf.collectionView reloadData];
    };
}

@end
