//
//  ReportController.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/2/19.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "ReportController.h"
#import "ReportImageTableViewCell.h"
#import "ReportResultController.h"
#import "ZLPhotoPickerViewController.h"
#import "ZLPhoto.h"
#define ReportCELL @"reportCell"
#define ReportImageCELL @"reportImageCell"
@interface ReportController ()<UIActionSheetDelegate,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)NSArray *dataKeyArray; //举报原因
@property (nonatomic,strong)NSMutableArray *dataArray; //举报原因编号
@property (nonatomic,strong)NSString *currentReportNo;  //当前举报原因编号
@property (nonatomic,assign)NSInteger selectFlag;//选中标志
@property (nonatomic,assign)BOOL imageFlag;//图片标志
@property (nonatomic , strong) NSMutableArray *imageArr;
@property (nonatomic,strong)NSMutableArray *imageUrlArr;

@property (nonatomic,strong)NSDictionary *dicts;
@end

@implementation ReportController
-(void)loadView{
    self.tableView=[[UITableView alloc]initWithFrame:[[UIScreen mainScreen]bounds] style:(UITableViewStyleGrouped)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"举报";
    self.imageUrlArr = [NSMutableArray array];
    self.dataArray=[[NSMutableArray alloc]init];
    NSDictionary *dict=[NSGetSystemTools getreport1];
    if (dict!=nil&&dict.count>0) {
        
        self.dataKeyArray=[[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        NSLog(@"%@",self.dataKeyArray);
        self.currentReportNo=[dict objectForKey:_dataKeyArray[0]];
        for (int i=0; i<_dataKeyArray.count; i++) {
            [self.dataArray addObject:[dict objectForKey:_dataKeyArray[i]]];
        }
    }
    self.dicts = [NSGetTools getAppInfoDict];
    
    
    self.selectFlag=0;
    self.imageFlag=NO;
    self.imageArr=[NSMutableArray array];
    
    self.tableView.backgroundColor=[UIColor colorWithWhite:0.949 alpha:1.000];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor=[UIColor colorWithWhite:0.902 alpha:1.000];
    self.tableView.tintColor= MainBarBackGroundColor;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ReportCELL];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReportImageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ReportImageCELL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return self.dataArray.count;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:ReportCELL forIndexPath:indexPath];
        cell.textLabel.text=self.dataArray[indexPath.row];
        cell.textLabel.textColor=[UIColor colorWithWhite:0.141 alpha:1.000];
        cell.textLabel.font=[UIFont systemFontOfSize:15.0];
        if (indexPath.section==0&&indexPath.row==_selectFlag) {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }else if(indexPath.section==0&&indexPath.row!=_selectFlag){
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        return cell;
    }else{
        ReportImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ReportImageCELL forIndexPath:indexPath];
        UIColor* color=[[UIColor alloc]initWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];//通过RGB来定义颜色
        cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor=color;
        if (self.imageFlag) {
            cell.reportImageView.hidden=NO;
            switch (self.imageArr.count) {
                case 3:
                    cell.thirdImageView.image=self.imageArr[2];
                case 2:
                    cell.secondImageView.image=self.imageArr[1];
                case 1:
                    cell.fristImageView.image=self.imageArr[0];
                default:
                    break;
            }
            
        }else{
            cell.reportImageView.hidden=YES;
        }
//        UIColor *bgcolor=[[UIColor alloc]initWithRed:0.0 green:0.0 blue:0.0 alpha:0];//通过RGB来定义颜色
//        cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
//        cell.selectedBackgroundView.backgroundColor=bgcolor;
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        return cell;
    }
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (self.selectFlag!=indexPath.row) {
            NSInteger flag=_selectFlag;
            NSIndexPath *ind1=[NSIndexPath indexPathForRow:flag inSection:indexPath.section];
            self.selectFlag=indexPath.row;
            NSIndexPath *ind2=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            [self.tableView reloadRowsAtIndexPaths:@[ind1,ind2] withRowAnimation:(UITableViewRowAnimationNone)];
        }
        
        
    }else if(indexPath.section==1){
        UIActionSheet *alert=[[UIActionSheet alloc]initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本地相册",@"相机", nil];
        
        [alert showInView:[UIApplication sharedApplication].keyWindow];
        
    }
    
}
#pragma mark actionSheet 代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self openLocalPhoto];
            break;
        case 1:
            [self openCamera];
        default:
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 35;
    }else{
        return 20;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=nil;
    if (section==0) {
        view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, 35)];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 7, ScreenWidth-40, 20)];
        label.text=@"请选择举报原因";
        label.textColor=[UIColor colorWithWhite:0.482 alpha:1.000];
        label.backgroundColor=[UIColor clearColor];
        label.font=[UIFont systemFontOfSize:12.0];
        [view addSubview:label];
    }else{
        
        view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, 20)];
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return 200;
    }
        
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=nil;
    if (section==0) {
        view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, 1)];
        
    }else{
        view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, 200)];
        UIButton *button=[UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        button.frame=CGRectMake(20, 38, [[UIScreen mainScreen] bounds].size.width-20-20, 45);
        button.backgroundColor=MainBarBackGroundColor;
        [button setTitle:@"提交" forState:(UIControlStateNormal)];
        [button setTintColor:[UIColor whiteColor]];
        button.layer.cornerRadius=45/2;
        button.layer.masksToBounds=YES;
        [button addTarget:self action:@selector(submitAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [view addSubview:button];
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 35;
    }else {
        
        if (_imageFlag) {
            return 137;
        }else{
            return 35;
        }
        
    }
    
}
- (void)submitAction:(UIButton *)sender{

    NSString *userId = [self.dicts objectForKey:@"p2"];
    NSString *sessionId = [self.dicts objectForKey:@"p1"];

    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    

    NSDictionary *parameters = @{@"a171":self.dataKeyArray[_selectFlag],@"a170":userId,@"p2":[NSNumber numberWithLong:[self.touchP2 integerValue]],@"p1":sessionId};
    [manger POST:[[NSString stringWithFormat:@"%@f_133_10_1.service",kServerAddressTest2]stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        if ([[infoDic objectForKey:@"code"] integerValue] == 200) {
            [self updateImage:[infoDic[@"body"] objectForKey:@"b172"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                ReportResultController *RRVc=[[ReportResultController alloc]init];
                [self.navigationController pushViewController:RRVc animated:YES];
            });
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"非常抱歉",nil] message:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"msg"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
 
    
}

#pragma mark 相机
-(void)openCamera{
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
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@",info);
    
    NSInteger lastNum = self.imageArr.count;
    if (lastNum<3) {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self.imageArr addObject:image];
        NSArray *arr = [NSArray arrayWithObject:image];
        [self uploadImageTosever:arr];
    }else{
        return;
    }
    
}
#pragma  mark 相册
- (void)openLocalPhoto{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 最多能选3张图片
    if (self.imageArr.count >= 3) {
        pickerVc.maxCount = 0;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"上传图片" message:@"最多3张" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else{
        pickerVc.maxCount = 3 - self.imageArr.count;
        pickerVc.status = PickerViewShowStatusCameraRoll;
        [pickerVc showPickerVc:self];
        
        __weak typeof(self) weakSelf = self;
        pickerVc.callBack = ^(NSArray *assets){
            NSInteger lastNum = weakSelf.imageArr.count;
            for (int i = 0;i <assets.count; i ++) {
                UIImage *originImage= [assets[i] originImage];
                weakSelf.imageArr[lastNum+i]=originImage;
            }
            [weakSelf uploadImageTosever:assets];
            
        };
    }
    
}

- (void)uploadImageTosever:(NSArray *)assets{
    //更新cell
    NSInteger Num=self.imageArr.count;
    if (Num>0) {
        self.imageFlag=YES;
        NSIndexPath *ind2=[NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[ind2] withRowAnimation:(UITableViewRowAnimationNone)];
    }else{
        self.imageFlag=NO;
        NSIndexPath *ind2=[NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[ind2] withRowAnimation:(UITableViewRowAnimationNone)];
    }
    
    
    
    
}

- (void)updateImage:(NSString *)report_id{
    //上传 图片
    
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sessonId = [NSGetTools getUserSessionId];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    if ([userId length] == 0 || [userId isEqualToString:@"(null)"] || [sessonId length] == 0 || [sessonId isEqualToString:@"(null)"]) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
        userId = [dict objectForKey:@"userId"];
        sessonId = [dict objectForKey:@"sessionId"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@f_134_10_1.service?a172=%@&p1=%@&p2=%@&%@",kServerAddressTest3,report_id,sessonId,userId,appinfoStr];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    
    //图片
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmsssss";

    for (int i=0; i<self.imageArr.count; i++) {
        
//        NSData *data = UIImageJPEGRepresentation(self.imageArr[i], 0.75);
        NSData *data = UIImageJPEGRepresentation(self.imageArr[i], 1);
        float index = 1.0;
        while (data.length > 1024*500) {
            data = UIImageJPEGRepresentation(self.imageArr[i], index);
            index = index - 0.1;
        }
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
//                [self.imageUrlArr addObject:[infoDic[@"body"] objectForKey:@"b57"]];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showHint:@"上传失败!"];
            });
        }
        
        
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
