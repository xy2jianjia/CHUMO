//
//  MyPhotoViewController.m
//  StrangerChat
//
//  Created by long on 15/10/29.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "MyPhotoViewController.h"
#import "ZLPhoto.h"
#import "PhotoCell.h"
#import "UIImageView+WebCache.h"
#import "DHAlbumModel.h"
@interface MyPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,ASIHTTPRequestDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic , strong) NSMutableArray *imageArr;
@property (weak,nonatomic) UICollectionView *collectionView;
@end

static NSString *kcellIdentifier = @"collectionCellID";
@implementation MyPhotoViewController


#pragma mark Get Data
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"相册";
    self.imageArr = [NSMutableArray array];
    [self getMyAlbums];
    [self setcollectio];
    [self rightNavigation];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    [Mynotification addObserver:self selector:@selector(NotificationUploadShowHudsever:) name:@"NotificationUploadShowHudsever" object:nil];
}
-(void)dealloc{
    [Mynotification removeObserver:self];
}
- (void)NotificationUploadShowHudsever:(NSNotification *)sender{
    NSString *str=sender.object;
    if ([str isEqualToString:@"YES"]) {
        [self showHudInView:self.view hint:@"请稍等..."];
    }else{
        [self hideHud];
    }
}
/**
 *  获取相册LP-file-msc/f_111_11_1.service？a78：1：眼缘大图、2：普通 (无参数，提取所有数据)，a95：分页参数，a110：1:提取、2：不提取(默认不提取)
 */
- (void)getMyAlbums{
    __weak typeof (*&self) weakSelf = self;
    
    NSString *count = [NSString stringWithFormat:@"%ld",(self.imageArr.count / 20)+1];
    
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sessonId = [NSGetTools getUserSessionId];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    NSString *url = [NSString stringWithFormat:@"%@f_111_11_1.service?a78=%@&a95=%@&a110=%@&p1=%@&p2=%@&%@",kServerAddressTest3, @"", count,@"1",sessonId,userId,appinfoStr];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum integerValue] == 200) {
            NSArray *arr = [infoDic objectForKey:@"body"];
//            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                // 保存点赞的记录id，为了取消点赞
                DHAlbumModel *item = [[DHAlbumModel alloc]init];
                [item setValuesForKeysWithDictionary:dic];
                [self.imageArr addObject:item];
            }
            // 存在下一页
            if ([[infoDic objectForKey:@"b96"] integerValue] == 1) {
                [weakSelf getMyAlbums];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.collectionView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)leftAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserInfosWhenUpdate" object:nil];
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark -- collection
- (void)setcollectio {
#pragma mark -- layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];  // item大小
    layout.itemSize = CGSizeMake((WIDTH-10*5)/4,(WIDTH-10*5)/4);  // w  h
    layout.minimumLineSpacing = 10;  //  上下间距
    layout.minimumInteritemSpacing = 10;  // 左右
    layout.scrollDirection = UICollectionViewScrollDirectionVertical; // 设置滚动方向
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);  // 上 左 下 右
    
    
#pragma mark -- collectionViews
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
#pragma mark -- 注册cell视图
    [collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:kcellIdentifier];
    
}



#pragma mark ---- 进入相机  btn-photo-n
- (void)rightNavigation {
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn-photo-n"] style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"我" style:(UIBarButtonItemStylePlain) target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
}

#pragma mark ----- 选择进入本地相册
- (void)rightAction {
    
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"本地相册",nil];
    [myActionSheet showInView:[UIApplication sharedApplication].keyWindow];
}


#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self openCamera];
            break;
        case 1:  //打开本地相册
            [self openLocalPhoto];
            break;
    }
}
#pragma mark - 拍照
- (void)openCamera{
//    ZLCameraViewController *cameraVc = [[ZLCameraViewController alloc] init];
//    // 拍照最多个数
//    cameraVc.maxCount = 6;
//    __weak typeof(self) weakSelf = self;
//    cameraVc.callback = ^(NSArray *cameras){
//        [self uploadImageTosever:cameras];
//    };
//    [cameraVc showPickerVc:self];
    
    NSUInteger sourceType = 0;
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    // 拍照
    sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSArray *arr = [NSArray arrayWithObject:image];
    picker.allowsEditing = NO;
    [Mynotification postNotificationName:@"NotificationUploadShowHudsever" object:@"YES"];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadImageTosever:arr];
    }];
    
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [Mynotification postNotificationName:@"NotificationUploadShowHudsever" object:@"NO"];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 本地相册
- (void)openLocalPhoto{
    [Mynotification postNotificationName:@"NotificationUploadShowHudsever" object:@"YES"];
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 最多能选9张图片
    if (self.imageArr.count > 9) {
        pickerVc.maxCount = 0;
    }else{
        pickerVc.maxCount = 9 - self.imageArr.count;
    }
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
/**
 *  上传图片
 *
 *  @param assets 图片数组 LP-file-msc/f_111_10_2.service？a78：分类1：眼缘大图、2：普通，a73：排序，a17:描述,a102:图片文件流(File)
 */
- (void)uploadImageTosever:(NSArray *)assets{
//    for (int i = 0;i <assets.count; i ++) {
//        if ([assets[i] isKindOfClass:[UIImage class]]) {
////            UIImage *originImage= [assets[i] photoImage];
//            [[DHTool shareTool] saveImage:assets[i] withName:[NSString stringWithFormat:@"uploadImage_%d.jpg",i+1]];
//        }else{
//            UIImage *originImage= [assets[i] originImage];
//            [[DHTool shareTool] saveImage:originImage withName:[NSString stringWithFormat:@"uploadImage_%d.jpg",i+1]];
//        }
//    }
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sessonId = [NSGetTools getUserSessionId];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    if ([userId length] == 0 || [userId isEqualToString:@"(null)"] || [sessonId length] == 0 || [sessonId isEqualToString:@"(null)"]) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
        userId = [dict objectForKey:@"userId"];
        sessonId = [dict objectForKey:@"sessionId"];
    }
    
//    NSString *url = 、[NSString stringWithFormat:@"http://115.236.55.163:9096/lp-file-msc.service?a78=%@&a73=%@&a17=%@&p1=%@&p2=%@&%@",@"2",@"0",@"来自触陌默认描述",sessonId,userId,appinfoStr];
    
    NSString *url = [NSString stringWithFormat:@"%@f_111_10_2.service?a78=%@&a73=%@&a17=%@&p1=%@&p2=%@&%@",kServerAddressTest3,@"2",@"0",@"来自触陌默认描述",sessonId,userId,appinfoStr];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    for (int i = 0; i < assets.count;  i ++) {
//        NSString *path = [[DHTool shareTool] getImagePathWithImageName:[NSString stringWithFormat:@"uploadImage_%d",i+1]];
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
        UIImage *image=[DHTool fixOrientation:assets[i]];
        NSData *data = UIImageJPEGRepresentation(image, 1);
        float index = 1;
//        if (data.length > 1024*500) {
//            index = (1024*500.0)/data.length;
//            NSLog(@"haha%f,",index);
//            data = UIImageJPEGRepresentation(image, index);
//        }
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
                //请求用户最新数据
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserInfosWhenUpdate" object:nil];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showHint:@"上传失败!"];
            });
        }
        [Mynotification postNotificationName:@"NotificationUploadShowHudsever" object:@"NO"];
        
    }
    [self.imageArr removeAllObjects];
    [self getMyAlbums];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//    });
}


#pragma mark - <ZLPhotoPickerBrowserViewControllerDelegate>
#pragma mark 返回自定义View
- (ZLPhotoPickerCustomToolBarView *)photoBrowserShowToolBarViewWithphotoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser{
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [customBtn setTitle:@"实现代理自定义ToolBar" forState:UIControlStateNormal];
    customBtn.frame = CGRectMake(10, 0, 200, 44);
    return (ZLPhotoPickerCustomToolBarView *)customBtn;
}

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > [self.imageArr count]) return;
    DHAlbumModel *item = [self.imageArr objectAtIndex:indexPath.item];
    [self removePhotoWithAlbumItem:item];
//    [self.imageArr removeObject:item];
//    [self.collectionView reloadData];
}

- (void)removePhotoWithAlbumItem:(DHAlbumModel *)item{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sessionId = [NSString stringWithFormat:@"%@",[NSGetTools getUserSessionId]];
    NSString *url = [NSString stringWithFormat:@"%@f_111_12_3.service?a34=%@&p1=%@&p2=%@",kServerAddressTest3,item.b34,sessionId,userId];
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
        if ([infoDic[@"code"] integerValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imageArr removeObject:item];
                [self.collectionView reloadData];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showHint:[NSString stringWithFormat:@"删除失败:code->%@",infoDic[@"code"]]];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}
#pragma mark dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imageArr count]+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    if (indexPath.item==0) {
        cell.bgTitleView.hidden=YES;
        [cell.simage setImage:[UIImage imageNamed:@"w_wo_xc_tianjia"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightAction)];
        cell.simage.userInteractionEnabled=YES;
        [cell.simage addGestureRecognizer:tap];
    }else{
        DHAlbumModel *item = self.imageArr[indexPath.item-1];
        NSString *url = item.b58;
        cell.simage.userInteractionEnabled=NO;
        [cell.simage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"list_item_icon"]];
        if ([item.b75 integerValue]!=1) {
            cell.bgTitleView.hidden=NO;
            if ([item.b75 integerValue]==2) {
                cell.titleLabel.text=@"审核中";
            }else{
                cell.titleLabel.text=@"审核未通过";
            }
        }else{
            cell.bgTitleView.hidden=YES;
        }
        cell.simage.clipsToBounds = YES;
        cell.simage.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 数据源/delegate
    // 动画方式
    /*
     *
     UIViewAnimationAnimationStatusZoom = 0, // 放大缩小
     UIViewAnimationAnimationStatusFade , // 淡入淡出
     UIViewAnimationAnimationStatusRotate // 旋转
     pickerBrowser.status = UIViewAnimationAnimationStatusFade;
     */
    NSInteger index = indexPath.item - 1;
    
    if (index < 0) {
        index = 0;
    }else if (index > self.imageArr.count - 1){
        index = self.imageArr.count - 1;
    }
    NSIndexPath *indexpath = [NSIndexPath indexPathForItem:index inSection:indexPath.section];
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    // 是否可以删除照片
    pickerBrowser.editing = YES;
    // 传入组
    pickerBrowser.currentIndexPath = indexpath;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}
#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
    return 1;
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return [self.imageArr count];
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.item ;
    
    if (index < 0) {
        index = 0;
    }else if (index > self.imageArr.count - 1){
        index = self.imageArr.count - 1;
    }
    
    id imageObj = [[self.imageArr objectAtIndex:index] b58];
//    NSIndexPath *indexpath = [NSIndexPath indexPathForItem:index inSection:indexPath.section];
    DHAlbumModel *item = [self.imageArr objectAtIndex:index];
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    PhotoCell *cell = (PhotoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    // 缩略图
    if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
        photo.asset = imageObj;
    }
    photo.toView = cell.simage;
    photo.thumbImage = cell.simage.image;
    photo.b34 = item.b34;
    photo.b17 = item.b17;
    photo.b52 = item.b52;
    photo.b58 = item.b58;
    photo.b59 = item.b59;
    photo.b60 = item.b60;
    photo.b73 = item.b73;
    photo.b75 = item.b75;
    photo.b78 = item.b78;
    photo.b80 = item.b80;
    photo.b108 = item.b108;
    photo.b109 = item.b109;
    return photo;
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
