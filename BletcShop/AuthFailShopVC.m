//
//  NewMiddleViewController.m
//  BletcShop
//
//  Created by apple on 16/9/22.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "AuthFailShopVC.h"
#import "NewLastViewController.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"

#import "JFAreaDataManager.h"
#import "ValuePickerView.h"

#import "ShopLandController.h"
#import "BaseNavigationController.h"
#import "ChooseTradeVC.h"
#import "UIButton+WebCache.h"
#import "BaiduMapManager.h"
#import "SingleModel.h"
#import "AddressEditVC.h"

@interface AuthFailShopVC ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    NSArray *nameArray;
    CGFloat totalHeight;
    UIScrollView *_scrollView;
    UITableView *_areaTableView;
    NSData *imageData;
    NSData *imageData2;
    
    NSMutableDictionary *shopInfoDic;
    
    NSMutableArray *array;//保存所有图片
    UIButton *sureBtn;
    UIView *add_more_view;
    
    
    NSMutableArray *eare_data;
    ValuePickerView *pickView;
    
}
@property(nonatomic,strong)NSArray *streetArray;
@property (nonatomic,strong)UITextField *idenCardText;//身份证
@property(nonatomic,retain)UITextField *realNameTF;//姓名
@property(nonatomic,strong)NSMutableArray *add_more_img_A;
@property(nonatomic,strong)SingleModel *s_model;
@property(nonatomic,strong)NSArray*selectAddress_A;//选择的省市区
@property(nonatomic,copy)NSString *real_log_lat;//拍照地经纬度

@end

@implementation AuthFailShopVC
-(NSMutableArray *)add_more_img_A{

    if (!_add_more_img_A) {
        _add_more_img_A = [NSMutableArray array];
    }
    return _add_more_img_A;
}

-(NSArray *)selectAddress_A{
    if (!_selectAddress_A) {
        _selectAddress_A=[NSArray array];
    }
    return _selectAddress_A;
}
-(NSMutableArray *)tradeArray{
    if (!_tradeArray) {
        _tradeArray = [NSMutableArray array];
    }
    return _tradeArray;
}

-(void)getIndustryArray{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/Source/tradeIconGet",BASEURL];
    [KKRequestDataService requestWithURL:url params:nil httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         
         
         [self.tradeArray removeAllObjects];
         for (NSDictionary *dic in result) {
             if (![dic[@"text"] isEqualToString:@"全部"]) {
                 [self.tradeArray addObject:dic[@"text"]];
             }
         }
         NSLog(@"-----%@",result);
         
         
         
         
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];
    
    
    
}
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status)
    {
        //读取本地数据
        NSString * isPositioning = [[NSUserDefaults standardUserDefaults] valueForKey:@"isPositioning"];
        if (isPositioning == nil)//提示
        {
            UIAlertView * positioningAlertivew = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"为了更好的体验,请到设置->隐私->定位服务中开启!【商消乐】定位服务,已便获取附近信息!" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            positioningAlertivew.tag = 999;
            [positioningAlertivew show];
        }
    }else//开启的
    {
        //需要删除本地字符
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"isPositioning"];
        [userDefaults synchronize];

        
        
        
    }
    

    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSDictionary *dic =[[NSUserDefaults standardUserDefaults]objectForKey:app.shopInfoDic[@"muid"]];
    
    shopInfoDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    
    if ([shopInfoDic[@"add_info"] count]!=0) {
        NSDictionary *add_info = shopInfoDic[@"add_info"][0];
        
        self.selectAddress_A= @[add_info[@"province"],add_info[@"city"],add_info[@"district"]];
        
    }
    
    
    NSLog(@"shopInfoDic-----%@",shopInfoDic);
    
    [self getIndustryArray];
//    [self getStreest];
    
    [self initTopView];
    [self initScrollView];
    self.indexTag=0;
    [self postRequestGetAddPictures];
    

//    SingleModel *s_model = [SingleModel sharedManager];
//    
//    [s_model addObserver:self forKeyPath:@"advertArea" options:
//     NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];

    
    
    
}

-(void)startLocation{
    
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    
        BaiduMapManager *manager = [BaiduMapManager shareBaiduMapManager];
        
        [manager startUserLocationService];
        
        manager.userAddressBlock = ^(BMKReverseGeoCodeResult *result) {
            

            app.addressInfo = result.address;
            app.addressDistrite = result.addressDetail.district;
            app.province =result.addressDetail.province;
            app.city =result.addressDetail.city;
            app.districtString =result.addressDetail.district;
            

            
            
        };
        
        manager.userLocationBlock = ^(BMKUserLocation *location) {
            
            app.userLocation = location;
            
            self.real_log_lat = [NSString stringWithFormat:@"%f,%f",location.location.coordinate.longitude,location.location.coordinate.latitude];


        };
        

    
}
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
//                       change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    NSLog(@"change+++++%@",change);
//
//    // 判断是否为self.myKVO的属性“num”:
//    if([keyPath isEqualToString:@"advertArea"]) {
//        // 响应变化处理：UI更新（label文本改变）
//        NSString *string=  [NSString stringWithFormat:@"当前的advertArea值为：%@",
//                            [change valueForKey:@"new"]];
//        NSLog(@"+++++%@",string);
//        //change的使用：上文注册时，枚举为2个，因此可以提取change字典中的新、旧值的这两个方法
//        NSLog(@"\\noldnum:%@ newadvertArea:%@",[change valueForKey:@"old"],
//              [change valueForKey:@"new"]);
//        
//        
//        
//        [self setaddressInfo];
//        
//
//        
//        
//    }
//}

//-(void)setaddressInfo{
//    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    
//    if (app.province==nil||[app.province isEqualToString:@"(null)"]) {
//        app.province = @"";
//    }if (app.city==nil||[app.city isEqualToString:@"(null)"]) {
//        app.city = @"";
//    }if (app.addressDistrite==nil||[app.addressDistrite isEqualToString:@"(null)"]) {
//        app.addressDistrite = @"";
//    }
//    _locationLab.text=[[NSString alloc] initWithFormat:@"%@%@%@",app.province,app.city,app.addressDistrite];
//    
//    NSString *detail_s =shopInfoDic[@"address"];
//    
//    if (detail_s.length>_locationLab.text.length) {
//        _detailAddressTF.text=[detail_s substringFromIndex:_locationLab.text.length];
//        
//    }else{
//        _detailAddressTF.text=detail_s;
//        
//    }
//    
//    
//    
//    
//    [self getStreest];
//    
//
//}

-(void)initTopView{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    navView.backgroundColor = NavBackGroundColor;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 18, 70, 44)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backRegist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navView];
    [navView addSubview:btn];
    //右边加一个保存按钮
//    UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-70, 18,70, 44)];
//    [btns setTitle:@"保存" forState:UIControlStateNormal];
//    [btns addTarget:self action:@selector(saveBtnlick:) forControlEvents:UIControlEventTouchUpInside];
//    btns.tag = 999;
//    [self.view addSubview:navView];
//    [navView addSubview:btns];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-50, 18, 100, 44)];
    label.font=[UIFont systemFontOfSize:19.0f];
    label.text=@"快速认证";
    label.textAlignment=1;
    label.textColor=[UIColor whiteColor];
    [navView addSubview:label];
    
}
//返回上一层
-(void)backRegist
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view endEditing:YES];
    [_scrollView endEditing:YES];
}



-(void)initScrollView{
    
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    _scrollView.showsVerticalScrollIndicator=NO;
    
    [self.view addSubview:_scrollView];
    
    UITapGestureRecognizer *tapClick=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAndHidden)];
    tapClick.delegate=self;
    [_scrollView addGestureRecognizer:tapClick];
    
    
    
    //姓名
    UILabel *xingmingLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
    xingmingLab.font=[UIFont systemFontOfSize:20.0f];
    xingmingLab.textColor=[UIColor redColor];
    xingmingLab.text=@"*";
    xingmingLab.textAlignment=1;
    [_scrollView addSubview:xingmingLab];
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 5, 110, 40)];
    label.font=[UIFont systemFontOfSize:15.0f];
    label.text=@"姓名";
    [_scrollView addSubview:label];
    
    _realNameTF=[[UITextField alloc]initWithFrame:CGRectMake(140, 5, SCREENWIDTH-140, 40)];
    _realNameTF.font=[UIFont systemFontOfSize:13.0f];
    _realNameTF.text=[NSString getTheNoNullStr:shopInfoDic[@"name"] andRepalceStr:@""];
    _realNameTF.placeholder=@"真实姓名";
    _realNameTF.returnKeyType=UIReturnKeyDone;
    _realNameTF.delegate=self;
    [_scrollView addSubview:_realNameTF];
    
    UIView *lineView_name=[[UIView alloc]initWithFrame:CGRectMake(10, label.bottom+5, SCREENWIDTH-20, 1)];
    lineView_name.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineView_name];
    

    
    
    //身份证
    UILabel *xing1=[[UILabel alloc]initWithFrame:CGRectMake(10, 15+lineView_name.bottom, 20, 20)];
    xing1.font=[UIFont systemFontOfSize:20.0f];
    xing1.textColor=[UIColor redColor];
    xing1.text=@"*";
    xing1.textAlignment=1;
    [_scrollView addSubview:xing1];
    
    UILabel *label_ident=[[UILabel alloc]initWithFrame:CGRectMake(30, 5+lineView_name.bottom, 110, 40)];
    label_ident.font=[UIFont systemFontOfSize:15.0f];
    label_ident.text=@"身份证";
    [_scrollView addSubview:label_ident];

    _idenCardText=[[UITextField alloc]initWithFrame:CGRectMake(140, label_ident.top, SCREENWIDTH-140, 40)];
    _idenCardText.font=[UIFont systemFontOfSize:13.0f];
    _idenCardText.text=[NSString getTheNoNullStr:shopInfoDic[@"id"] andRepalceStr:@""];
    _idenCardText.placeholder=@"身份证号码";
    _idenCardText.returnKeyType=UIReturnKeyDone;
    _idenCardText.delegate=self;
    [_scrollView addSubview:_idenCardText];

    
    UIView *lineView_ident=[[UIView alloc]initWithFrame:CGRectMake(10, label_ident.bottom+5, SCREENWIDTH-20, 1)];
    lineView_ident.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineView_ident];
    
    
    
    
//当前地区
    UILabel *xingLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 15+lineView_ident.bottom, 20, 20)];
    xingLab.font=[UIFont systemFontOfSize:20.0f];
    xingLab.textColor=[UIColor redColor];
    xingLab.text=@"*";
    xingLab.textAlignment=1;
    [_scrollView addSubview:xingLab];
    

    UILabel *label_local=[[UILabel alloc]initWithFrame:CGRectMake(30, 5+lineView_ident.bottom, 110, 40)];
    label_local.font=[UIFont systemFontOfSize:15.0f];
    label_local.text=@"当前地区";
    [_scrollView addSubview:label_local];

    _locationLab=[[UITextField alloc]initWithFrame:CGRectMake(140, label_local.top, SCREENWIDTH-140, 40)];
    _locationLab.font=[UIFont systemFontOfSize:15.0f];

    _locationLab.placeholder=@"省市区";

    _locationLab.delegate = self;
    [_scrollView addSubview:_locationLab];
    
//    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    if (appdelegate.province==nil||[appdelegate.province isEqualToString:@"(null)"]) {
//        appdelegate.province = @"";
//    }if (appdelegate.city==nil||[appdelegate.city isEqualToString:@"(null)"]) {
//        appdelegate.city = @"";
//    }if (appdelegate.addressDistrite==nil||[appdelegate.addressDistrite isEqualToString:@"(null)"]) {
//        appdelegate.addressDistrite = @"";
//    }
//    _locationLab.text=[[NSString alloc] initWithFormat:@"%@%@%@",appdelegate.province,appdelegate.city,appdelegate.addressDistrite];
    
    
    NSString *detail_s =shopInfoDic[@"address"];

    NSString *jiedao , *shengshiqu ,*xingxidizhi;
    
    
    if ([detail_s containsString:@"区"]&&![detail_s containsString:@"地区"]) {
       
        //包含区,但不包含地区,XX区
        jiedao = [[detail_s componentsSeparatedByString:@"区"] lastObject];
        
        
    }else if ([detail_s containsString:@"县"]){
        //XXX县
        jiedao = [[detail_s componentsSeparatedByString:@"区"] lastObject];

        
    }else{
        
        //XX市,如兴平市,杨凌市
        jiedao = [[detail_s componentsSeparatedByString:@"市"] lastObject];

    }
    shengshiqu = [detail_s substringToIndex:(detail_s.length-jiedao.length)];

    
    if ([shopInfoDic[@"add_info"] count]!=0) {
        
        NSDictionary *add_info = shopInfoDic[@"add_info"][0];
        
        shengshiqu = [NSString stringWithFormat:@"%@%@%@",add_info[@"province"],add_info[@"city"],add_info[@"district"]];
        jiedao = [NSString getTheNoNullStr:add_info[@"street"] andRepalceStr:@""] ;
        
        xingxidizhi =  [NSString getTheNoNullStr:add_info[@"location"] andRepalceStr:@""];
        
    }
    
    
    
    _locationLab.text = shengshiqu;
    
    if ([_locationLab.text containsString:@"全城"]) {
        _locationLab.text =@"";
    }

    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(10, _locationLab.bottom+5, SCREENWIDTH-20, 1)];
    lineView1.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineView1];
    
    
    //街道
    
    UILabel *xingLab2=[[UILabel alloc]initWithFrame:CGRectMake(10, 15+lineView1.bottom, 20, 20)];
    xingLab2.font=[UIFont systemFontOfSize:20.0f];
    xingLab2.textColor=[UIColor redColor];
    xingLab2.text=@"*";
    xingLab2.textAlignment=1;
    [_scrollView addSubview:xingLab2];
    

    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(30, 5+lineView1.bottom, 110, 40)];
    label2.font=[UIFont systemFontOfSize:15.0f];
    label2.text=@"街道";
    [_scrollView addSubview:label2];
    

    _detailAddressTF=[[UITextField alloc]initWithFrame:CGRectMake(140, 5+lineView1.bottom, SCREENWIDTH-140, 40)];
    _detailAddressTF.font=[UIFont systemFontOfSize:13.0f];
    _detailAddressTF.placeholder=@"所在街道";
    _detailAddressTF.delegate = self;
    
    _detailAddressTF.text = jiedao;
    
//    if ([detail_s containsString:@"全城"]) {
//        detail_s =@"";
//    }
//    if (detail_s.length>_locationLab.text.length) {
//        _detailAddressTF.text=[detail_s substringFromIndex:_locationLab.text.length];
//        
//    }else{
//        _detailAddressTF.text=detail_s;
//        
//    }
    
    
    [_scrollView addSubview:_detailAddressTF];
    
    UIView *lineView_detailaddress=[[UIView alloc]initWithFrame:CGRectMake(10, _detailAddressTF.bottom+5, SCREENWIDTH-20, 1)];
    lineView_detailaddress.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineView_detailaddress];

    
    //详细地址
    UILabel *xingLab_new=[[UILabel alloc]initWithFrame:CGRectMake(10, 15+lineView_detailaddress.bottom, 20, 20)];
    xingLab_new.font=[UIFont systemFontOfSize:20.0f];
    xingLab_new.textColor=[UIColor redColor];
    xingLab_new.text=@"*";
    xingLab_new.textAlignment=1;
    [_scrollView addSubview:xingLab_new];

    UILabel *labelnew3=[[UILabel alloc]initWithFrame:CGRectMake(30, lineView_detailaddress.bottom+5, 110, 40)];
    labelnew3.font=[UIFont systemFontOfSize:15.0f];
    labelnew3.text=@"详细地点";
    [_scrollView addSubview:labelnew3];
    
    _adddetailnewAddressTF=[[UITextField alloc]initWithFrame:CGRectMake(140, labelnew3.top, SCREENWIDTH-140, 40)];
    _adddetailnewAddressTF.font=[UIFont systemFontOfSize:13.0f];
    _adddetailnewAddressTF.text=xingxidizhi;
    _adddetailnewAddressTF.placeholder=@"详细地点";
    _adddetailnewAddressTF.delegate=self;
    _adddetailnewAddressTF.returnKeyType=UIReturnKeyDone;
    [_scrollView addSubview:_adddetailnewAddressTF];
    
    UIView *lineViewnew=[[UIView alloc]initWithFrame:CGRectMake(10, _adddetailnewAddressTF.bottom+5, SCREENWIDTH-20, 1)];
    lineViewnew.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineViewnew];
    
    
    //经纬度
    UILabel *xingLab_jing=[[UILabel alloc]initWithFrame:CGRectMake(10, 15+lineViewnew.bottom, 20, 20)];
    xingLab_jing.font=[UIFont systemFontOfSize:20.0f];
    xingLab_jing.textColor=[UIColor redColor];
    xingLab_jing.text=@"*";
    xingLab_jing.textAlignment=1;
    [_scrollView addSubview:xingLab_jing];
    
    UILabel *labelnewjing=[[UILabel alloc]initWithFrame:CGRectMake(30, lineViewnew.bottom+5, 110, 40)];
    labelnewjing.font=[UIFont systemFontOfSize:15.0f];
    labelnewjing.text=@"当前位置";
    [_scrollView addSubview:labelnewjing];
    
    _location_log_lat=[[UITextField alloc]initWithFrame:CGRectMake(140, labelnewjing.top, SCREENWIDTH-140, 40)];
    _location_log_lat.font=[UIFont systemFontOfSize:13.0f];
    _location_log_lat.text=[NSString stringWithFormat:@"%@,%@",[NSString getTheNoNullStr:shopInfoDic[@"longtitude"] andRepalceStr:@""],[NSString getTheNoNullStr:shopInfoDic[@"latitude"] andRepalceStr:@""]];
    _location_log_lat.placeholder=@"当前位置经纬度";
    _location_log_lat.delegate=self;
    _location_log_lat.returnKeyType=UIReturnKeyDone;
    [_scrollView addSubview:_location_log_lat];
    
    UIView *lineViewnewjing=[[UIView alloc]initWithFrame:CGRectMake(10, _location_log_lat.bottom+5, SCREENWIDTH-20, 1)];
    lineViewnewjing.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineViewnewjing];
    

    
    
    
    //店铺名称
    
    UILabel *xingLab3=[[UILabel alloc]initWithFrame:CGRectMake(10, 15+lineViewnewjing.bottom, 20, 20)];
    xingLab3.font=[UIFont systemFontOfSize:20.0f];
    xingLab3.textColor=[UIColor redColor];
    xingLab3.text=@"*";
    xingLab3.textAlignment=1;
    [_scrollView addSubview:xingLab3];
    

    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(30, 5+lineViewnewjing.bottom, 110, 40)];
    label3.font=[UIFont systemFontOfSize:15.0f];
    label3.text=@"店铺名称";
    [_scrollView addSubview:label3];

    _agencyNameTF=[[UITextField alloc]initWithFrame:CGRectMake(140, label3.top, SCREENWIDTH-140, 40)];
    _agencyNameTF.font=[UIFont systemFontOfSize:13.0f];
    _agencyNameTF.placeholder=@"店铺名称";
    _agencyNameTF.delegate=self;
    _agencyNameTF.returnKeyType=UIReturnKeyDone;
    _agencyNameTF.text=shopInfoDic[@"store"];
    
    [_scrollView addSubview:_agencyNameTF];
    
    UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(10, _agencyNameTF.bottom+5, SCREENWIDTH-20, 1)];
    lineView3.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineView3];
    
    //联系方式
    
    UILabel *xing_store=[[UILabel alloc]initWithFrame:CGRectMake(10, lineView3.bottom+15, 20, 20)];
    xing_store.font=[UIFont systemFontOfSize:20.0f];
    xing_store.textColor=[UIColor redColor];
    xing_store.text=@"*";
    xing_store.textAlignment=1;
    [_scrollView addSubview:xing_store];
    

    UILabel *store_number=[[UILabel alloc]initWithFrame:CGRectMake(30, lineView3.bottom+5, 110, 40)];
    store_number.font=[UIFont systemFontOfSize:15.0f];
    store_number.text=@"联系方式";
    [_scrollView addSubview:store_number];
 
    self.store_textf=[[UITextField alloc]initWithFrame:CGRectMake(140, store_number.top, SCREENWIDTH-140, 40)];
    self.store_textf.font=[UIFont systemFontOfSize:13.0f];
    self.store_textf.placeholder=@"联系方式";
    self.store_textf.text=shopInfoDic[@"store_number"];
    self.store_textf.delegate=self;
    self.store_textf.returnKeyType=UIReturnKeyDone;
    [_scrollView addSubview:self.store_textf];
    
    UIView *lineViewe=[[UIView alloc]initWithFrame:CGRectMake(10, _store_textf.bottom+5, SCREENWIDTH-20, 1)];
    lineViewe.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineViewe];
    
    
    //所属行业
    UILabel *xingLab4=[[UILabel alloc]initWithFrame:CGRectMake(10, lineViewe.bottom+15, 20, 20)];
    xingLab4.font=[UIFont systemFontOfSize:20.0f];
    xingLab4.textColor=[UIColor redColor];
    xingLab4.text=@"*";
    xingLab4.textAlignment=1;
    [_scrollView addSubview:xingLab4];
    

    UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(30, lineViewe.bottom+5, 110, 40)];
    label4.font=[UIFont systemFontOfSize:15.0f];
    label4.text=@"所属行业";
    [_scrollView addSubview:label4];
    
    UIView *lineView4=[[UIView alloc]initWithFrame:CGRectMake(10, label4.bottom+5, SCREENWIDTH-20, 1)];
    lineView4.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineView4];
    
 
    _kindLab=[[UILabel alloc]initWithFrame:CGRectMake(110, 10+lineViewe.bottom, SCREENWIDTH-110, 30)];
    _kindLab.text=@"请选择";
    _kindLab.font=[UIFont systemFontOfSize:13.0f];
    _kindLab.userInteractionEnabled=YES;
    [_scrollView addSubview:_kindLab];
    
    
    if ([shopInfoDic[@"trade"] length]!=0) {
        _kindLab.text=shopInfoDic[@"trade"];
        
    }
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapChooseClick:)];
    [_kindLab addGestureRecognizer:tap];
    UIImageView *zijieImage=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-20, 15+lineViewe.bottom+4, 6, 12)];
    zijieImage.image=[UIImage imageNamed:@"youjiantou"];
    
    [_scrollView addSubview:zijieImage];
    
    
    //营业执照
    UILabel *xingLab5=[[UILabel alloc]initWithFrame:CGRectMake(10, 15+lineView4.bottom, 20, 20)];
    xingLab5.font=[UIFont systemFontOfSize:20.0f];
    xingLab5.textColor=[UIColor redColor];
    xingLab5.text=@"*";
    xingLab5.textAlignment=1;
    [_scrollView addSubview:xingLab5];
 
    UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(30, 5+lineView4.bottom, 110, 40)];
    label5.font=[UIFont systemFontOfSize:15.0f];
    label5.text=@"营业执照";
    [_scrollView addSubview:label5];
    
    
    
    _imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(120+10+(SCREENWIDTH-150)/2, 15+lineView4.bottom, (SCREENWIDTH-150)/2, ((SCREENWIDTH-150)/2)*116/176)];
    _imageView1.userInteractionEnabled=YES;
    _imageView1.image=[UIImage imageNamed:@"mohu-09"];
    [_scrollView addSubview:_imageView1];
    
    UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_imageView1 addGestureRecognizer:tapGesture1];
    

    //
    UILabel *underLab=[[UILabel alloc]initWithFrame:CGRectMake(_imageView1.left, _imageView1.bottom, (SCREENWIDTH-150)/2, 40)];
    underLab.tag=900;
    underLab.text=@"营业执照照片";
    underLab.font=[UIFont systemFontOfSize:15.0f];
    underLab.textColor=NavBackGroundColor;
    underLab.textAlignment=1;
    [_scrollView addSubview:underLab];
    
    
    UIView *lineView5=[[UIView alloc]initWithFrame:CGRectMake(10, underLab.bottom, SCREENWIDTH-20, 1)];
    lineView5.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineView5];
    
   
    
    //经营场地照片
    UILabel *xingLab8=[[UILabel alloc]initWithFrame:CGRectMake(10, 15+lineView5.bottom, 20, 20)];
    xingLab8.font=[UIFont systemFontOfSize:20.0f];
    xingLab8.textColor=[UIColor redColor];
    xingLab8.textAlignment=1;
    xingLab8.text=@"*";
    [_scrollView addSubview:xingLab8];
    
    UILabel *label8=[[UILabel alloc]initWithFrame:CGRectMake(30, 5+lineView5.bottom, 110, 40)];
    label8.font=[UIFont systemFontOfSize:14.0f];
    label8.text=@"经营场地照片";
    [_scrollView addSubview:label8];
    
   
    _imageView5=[[UIImageView alloc]initWithFrame:CGRectMake(120+10+(SCREENWIDTH-150)/2, xingLab8.top, (SCREENWIDTH-150)/2, ((SCREENWIDTH-150)/2)*116/176)];
    _imageView5.image=[UIImage imageNamed:@"mohu-13"];
    _imageView5.userInteractionEnabled=YES;
    [_scrollView addSubview:_imageView5];
    UITapGestureRecognizer *tapGesture5=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_imageView5 addGestureRecognizer:tapGesture5];
    
    
    UILabel *under_red2 =[[UILabel alloc]initWithFrame:CGRectMake(_imageView5.left, _imageView5.bottom, (SCREENWIDTH-150)/2, 40)];
    under_red2.text=@"经营场地照片";
    under_red2.font=[UIFont systemFontOfSize:14.0f];
    under_red2.textAlignment=1;
    under_red2.textColor=NavBackGroundColor;
    [_scrollView addSubview:under_red2];
    
    UIView *lineView8=[[UIView alloc]initWithFrame:CGRectMake(10, under_red2.bottom, SCREENWIDTH-20, 0.6)];
    lineView8.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview: lineView8];
    
    
    //补充材料
    UILabel *xingLab9=[[UILabel alloc]initWithFrame:CGRectMake(10, 15+lineView8.bottom, 20, 20)];
    xingLab9.font=[UIFont systemFontOfSize:20.0f];
    xingLab9.textColor=[UIColor redColor];
    xingLab9.textAlignment=1;
    xingLab9.text=@"";
    [_scrollView addSubview:xingLab9];
    
    UILabel *label9=[[UILabel alloc]initWithFrame:CGRectMake(30, 5+lineView8.bottom, 110, 40)];
    label9.font=[UIFont systemFontOfSize:14.0f];
    label9.text=@"补充材料";
    [_scrollView addSubview:label9];

    UILabel *introduce_lab = [[ UILabel alloc]init];
    
    introduce_lab.text = @"(请以下行业和情况在此提交补充材料：餐饮业需卫生许可证和2张健康证，教育培训业需办学许可证；另外，申请过程中遇到所需资料无上传入口的情况，都可在此处上传。)";
    
    introduce_lab.textColor = RGB(119,119,119);
    introduce_lab.font = [UIFont systemFontOfSize:12];
    introduce_lab.numberOfLines = 0;
    
    
    CGFloat  hh_lab = [introduce_lab.text getTextHeightWithShowWidth:SCREENWIDTH-91-13 AndTextFont:introduce_lab.font AndInsets:12];
    
    
    introduce_lab.frame  = CGRectMake(91, label9.top, SCREENWIDTH-91-13, hh_lab);
    [_scrollView addSubview:introduce_lab];
    

    
     add_more_view = [[UIView alloc]initWithFrame:CGRectMake(0, introduce_lab.bottom, SCREENWIDTH, ((SCREENWIDTH-150)/2)*116/176)];
    
    
    [_scrollView addSubview:add_more_view];
    
    
    
    
    
    
    
    _scrollView.contentSize=CGSizeMake(SCREENWIDTH, add_more_view.bottom+100);

    
    //完成
    
     sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame=CGRectMake(SCREENWIDTH/2-50, _scrollView.contentSize.height-60, 100, 40);
    sureBtn.backgroundColor=NavBackGroundColor;
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius=8.0f;
   
    [sureBtn addTarget:self action:@selector(sureBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:sureBtn];

    
    
      [NSThread detachNewThreadSelector:@selector(downLoadImageAndSeeIfExists) toTarget:self withObject:nil];
    
    
    [self refreshAddMoreView];
    
   
    
}


#pragma mark --界面完结
//模态消失，返回上级界面
-(void)missSelf:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sureBtnClcik{
    if ([self.realNameTF.text isEqualToString:@""]||[self.idenCardText.text isEqualToString:@""]||[self.locationLab.text isEqualToString:@""]||[self.detailAddressTF.text isEqualToString:@""]||[self.adddetailnewAddressTF.text isEqualToString:@""]||[self.store_textf.text isEqualToString:@""]||[self.agencyNameTF.text isEqualToString:@""]||[self.kindLab.text isEqualToString:@""]) {
//        ||self.ifImageView1==NO||self.ifImageView5==NO
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"至少有一项信息填写不完成", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        [hud hideAnimated:YES afterDelay:2.f];
    }else{
        
        
        [self postRequest];
    }
    
    
}


-(void)postRequest{
    
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //开始发起请求,请求成功，显示一下信息
    //地点问题
    
    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/register/auth_quick_v2",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    [params setValue:_realNameTF.text forKey:@"name"];//真实姓名
    [params setValue:_idenCardText.text forKey:@"id"];//身份证号
    

    [params setObject:shopInfoDic[@"muid"] forKey:@"muid"];
    
    [params setObject:shopInfoDic[@"phone"] forKey:@"phone"];//商铺注册手机号
    
    NSString *newStr=[[NSString alloc]initWithFormat:@"%@%@",self.locationLab.text,self.detailAddressTF.text];
    NSLog(@"%@",newStr);
    [params setObject:newStr forKey:@"address"];//市区街道地点
    
//    float lat = appdelegate.userLocation.location.coordinate.latitude;
//    NSString *latitude =[[NSString alloc]initWithFormat:@"%f",lat];
//    float longti = appdelegate.userLocation.location.coordinate.longitude;
//    NSString *longtitude =[[NSString alloc]initWithFormat:@"%f",longti];

    
    NSArray *log_lat_A = [_location_log_lat.text componentsSeparatedByString:@","];
    
    NSString *latitude = log_lat_A[1];
    NSString *longtitude = log_lat_A[0];

    
    
    [params setObject:latitude forKey:@"latitude"];//纬度
     [params setObject:longtitude forKey:@"longtitude"];//经度
    
    
    [params setObject:_adddetailnewAddressTF.text forKey:@"full_add"];

   
    [params setObject:self.agencyNameTF.text forKey:@"store"];//店铺名称
   
    
   
        [params setObject:self.kindLab.text forKey:@"trade"];//行业
    
    
    NSString *imgUrl = [[NSString alloc]initWithFormat:@"%@.png",shopInfoDic[@"muid"]];
    
    [params setObject:imgUrl forKey:@"image_url"];
    

  
        [params setObject:self.store_textf.text forKey:@"store_number"];//联系方式
    
    [params setObject:self.selectAddress_A[0] forKey:@"province"];
    [params setObject:self.selectAddress_A[1] forKey:@"city"];
    [params setObject:self.selectAddress_A[2] forKey:@"district"];
    [params setObject:_detailAddressTF.text forKey:@"street"];
    [params setObject:_adddetailnewAddressTF.text forKey:@"location"];

    
    
    
    DebugLog(@"url==%@ parame ==%@",url,params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {

        NSLog(@" KKRequestDataService ==%@", result);




        if ([result[@"result_code"] isEqualToString:@"access"]) {
            UIAlertView *altView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您已提交成功,请重新登录!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [altView show];
        }else if([result[@"result_code"] isEqualToString:@"check_fail"] || [result[@"result_code"] isEqualToString:@"fail"]){

            [self showHint:[NSString stringWithFormat:@"%@",result[@"tip"]]];


         }else{

             [self showHint:@"请求失败..."];
         }







    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {


        NSLog(@"%@", error);
    }];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag ==999) {
       
        if (buttonIndex == 0)//确认跳转设置
        {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }

            
            
        }
        
        
    }else{
            
            
            AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
            
            [app loginOutBletcShop];
            
            
            ShopLandController *shopvc = [[ShopLandController alloc]init];
            
            BaseNavigationController *NAVVC = [[BaseNavigationController alloc]initWithRootViewController:shopvc];
            
//            self.window.rootViewController = NAVVC;
//            ShopLandController *shopvc = [[ShopLandController alloc]init];
            
            app.window.rootViewController = NAVVC;
            
            
            
    
  
    }
}



-(void)tapChooseClick:(UITapGestureRecognizer *)tap{
    for (UITextField *tf in _scrollView.subviews) {
        [tf resignFirstResponder];
    }
    
    ChooseTradeVC *tradeVC=[[ChooseTradeVC alloc]init];
    tradeVC.resultBlock = ^(NSString *string) {
        self.kindLab.text=string;
    };
    [self presentViewController:tradeVC animated:YES completion:nil];
    
//    pickView.dataSource=self.tradeArray;
//    __weak AuthFailShopVC *wealSelf=self;
//    pickView.valueDidSelect = ^(NSString *value) {
//        
//        wealSelf.kindLab.text =  [[value componentsSeparatedByString:@"/"] firstObject];
//        
//    };
//    [pickView show];
    

    
}

-(void)downLoadImageAndSeeIfExists{
    
    array=[NSMutableArray array];
    NSString *name = [[[NSString alloc]initWithFormat:@"%@licenseImage/%@.png",IMG_URL,shopInfoDic[@"muid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"-----%@",name);
    UIImage *image= [self getImageFromURL:name];
    if (image) {
        self.ifImageView1=YES;
        [array addObject:image];
    }else{
        image=[UIImage imageNamed:@"mohu-09"];
        [array addObject:image];
    }
    NSString *name2;
    NSString *name3;
    
    NSMutableArray *muta_arr_house= [NSMutableArray array];
    
    NSMutableArray *muta_arr_tenancy= [NSMutableArray array];
    
    //添加房产证明
    {
        name2 = [[[NSString alloc]initWithFormat:@"%@houseImage/%@_01.png",IMG_URL,shopInfoDic[@"muid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        UIImage *image2= [self getImageFromURL:name2];
        
        if (image2 ) {
            if ([shopInfoDic[@"house_contact"] isEqualToString:@"房产证明"]) {
                self.ifImageView2=YES;
                
            }
            
            [muta_arr_house addObject:image2];
        }else{
            image2=[UIImage imageNamed:@"mohu-10"];
            [muta_arr_house addObject:image2];
        }
        
        
        name3 = [[[NSString alloc]initWithFormat:@"%@houseImage/%@_02.png",IMG_URL,shopInfoDic[@"muid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        UIImage *image3= [self getImageFromURL:name3];
        if (image3 ) {
            if ([shopInfoDic[@"house_contact"] isEqualToString:@"房产证明"]) {
                self.ifImageView3=YES;
                
            }
            
            [muta_arr_house addObject:image3];
        }else{
            image3=[UIImage imageNamed:@"mohu-11"];
            [muta_arr_house addObject:image3];
        }
        
        [array addObject:muta_arr_house];
        
        
    }
    
    //添加租赁合同图片
    
    {
        name2 = [[[NSString alloc]initWithFormat:@"%@tenancyImage/%@_01.png",IMG_URL,shopInfoDic[@"muid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        name3 = [[[NSString alloc]initWithFormat:@"%@tenancyImage/%@_02.png",IMG_URL,shopInfoDic[@"muid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        UIImage *image2= [self getImageFromURL:name2];
        
        if (image2 ) {
            
            if ([shopInfoDic[@"house_contact"] isEqualToString:@"租赁合同"]) {
                self.ifImageView2=YES;
                
            }
            
            [muta_arr_tenancy addObject:image2];
        }else{
            image2=[UIImage imageNamed:@"mohu-10"];
            [muta_arr_tenancy addObject:image2];
        }
        
        UIImage *image3= [self getImageFromURL:name3];
        if (image3 ) {
            if ([shopInfoDic[@"house_contact"] isEqualToString:@"租赁合同"]) {
                self.ifImageView3=YES;
                
            }
            [muta_arr_tenancy addObject:image3];
        }else{
            image3=[UIImage imageNamed:@"mohu-11"];
            [muta_arr_tenancy addObject:image3];
        }
        
        [array addObject:muta_arr_tenancy];
        
    }
    
    
    
    
    NSString *name4 = [[[NSString alloc]initWithFormat:@"%@lpImage/%@.png",IMG_URL,shopInfoDic[@"muid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImage *image4= [self getImageFromURL:name4];
    if (image4) {
        self.ifImageView4=YES;
        [array addObject:image4];
    }else{
        image4=[UIImage imageNamed:@"mohu-12"];
        [array addObject:image4];
    }
    
    NSString *name5 = [[[NSString alloc]initWithFormat:@"%@addImage/%@.png",IMG_URL,shopInfoDic[@"muid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImage *image5= [self getImageFromURL:name5];
    if (image5) {
        self.ifImageView5=YES;
        [array addObject:image5];
    }else{
        image5=[UIImage imageNamed:@"mohu-13"];
        [array addObject:image5];
    }
    
    NSString *name6 = [[[NSString alloc]initWithFormat:@"%@wepImage/%@.png",IMG_URL,shopInfoDic[@"muid"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImage *image6= [self getImageFromURL:name6];
    if (image6) {
        self.ifImageView6=YES;
        [array addObject:image6];
    }else{
        image6=[UIImage imageNamed:@"mohu-14"];
        [array addObject:image6];
    }
    
    //    DebugLog(@"array===%@",array);
    [self performSelectorOnMainThread:@selector(refreshUI:) withObject:array waitUntilDone:NO];
}
-(void)refreshUI:(NSMutableArray *)arr{
    if (self.ifImageView1==YES) {
            self.imageView1.image=arr[0];
    }
    if ([shopInfoDic[@"house_contact"] isEqualToString:@"房产证明"]) {
        if (self.ifImageView2==YES) {
            self.imageView2.image=arr[1][0];
        }
        if (self.ifImageView3==YES) {
            self.imageView3.image=arr[1][1];
        }
        
    }else{
        if (self.ifImageView2==YES) {
            self.imageView2.image=arr[2][0];
        }
        if (self.ifImageView3==YES) {
            self.imageView3.image=arr[2][1];
        }
        
    }
    if (self.ifImageView4==YES) {
        self.imageView4.image=arr[3];
    }
    if (self.ifImageView5==YES) {
        self.imageView5.image=arr[4];
    }
    if (self.ifImageView6==YES) {
        self.imageView6.image=arr[5];
    }
}
#pragma mark --上传图片点击事件
-(void)tapClick:(UITapGestureRecognizer *)tap{
    
    UIImageView *imageViews=(UIImageView *)[tap view];

    
        
        [self.view endEditing:YES];
        UIActionSheet *sheet;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            
        {
            
      
            if (imageViews==self.imageView5){
                sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", nil];

                [self  startLocation];
                
            
            
            }else{
                sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];

            }
            
        }
        
        else {
            
            sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
            
        }
        
        sheet.tag = 255;
        
        [sheet showInView:self.view];
        
        
        
        
    if (imageViews==self.imageView1) {
        self.indexTag=1;
    }else
        if (imageViews==self.imageView2){
            self.indexTag=2;
            
            
        }else if (imageViews==self.imageView3){
            self.indexTag=3;
            
        }else if (imageViews==self.imageView4){
            self.indexTag=4;
            
            
        }else if (imageViews==self.imageView5){
            self.indexTag=5;
            
            
            
        }else if (imageViews==self.imageView6){
            self.indexTag=6;
            
        }
        
    
    
    NSLog(@"-----%ld",_indexTag);
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}
//点击选取按钮触发事件
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // 保存图片至本地，方法见下文
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    NSData *img_Data = [NSData dataWithContentsOfFile:fullPath];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
   
    
    
    if (_indexTag ==333) {
       
        [self postRequestAddPicturesToServer:img_Data];
        
        return;
    }
    
    
     NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/RegisterUpload/upload",BASEURL];
    
    NSString *name = [[NSString alloc]initWithFormat:@"%@",shopInfoDic[@"muid"]];
    
    NSMutableDictionary *parmer = [NSMutableDictionary dictionary];
    [parmer setValue:name forKey:@"muid"];

    [parmer setValue:name forKey:@"name"];
    
    if (_indexTag==1) {
        [parmer setValue:@"license" forKey:@"type"];
        
        
    }else if(_indexTag==2)
    {
        
        
        NSString *name1 = [[NSString alloc]initWithFormat:@"%@_01",shopInfoDic[@"muid"]];
        
        
        
        [parmer setValue:name1 forKey:@"name"];
        
        
        if (self.agreeBtn1.selected==YES) {
            [parmer setValue:@"tenancy" forKey:@"type"];
            
            [array[2] insertObject:savedImage atIndex:0];
            
            
        }else{
            [parmer setValue:@"house" forKey:@"type"];
            
            [array[1] insertObject:savedImage atIndex:0];
            
            [self.imageView2 setImage:array[1][0]];
            
            
        }
        
    }else if(_indexTag==3)
    {
        NSString *name2 = [[NSString alloc]initWithFormat:@"%@_02",shopInfoDic[@"muid"]];
        
        [parmer setValue:name2 forKey:@"name"];
        
        if (self.agreeBtn1.selected==YES) {
            [parmer setValue:@"tenancy" forKey:@"type"];
            
            [array[2] insertObject:savedImage atIndex:1];
            
            
            
        }else{
            [parmer setValue:@"house" forKey:@"type"];
            [array[1] insertObject:savedImage atIndex:1];
            
            
        }
        
        
        
    }else if (_indexTag==4){
        [parmer setValue:@"lp" forKey:@"type"];
        
    }else if (_indexTag==5){
       
        NSArray *arr = [_real_log_lat componentsSeparatedByString:@","];
        
        [parmer setValue:arr[1] forKey:@"latitude"];
        [parmer setValue:arr[0] forKey:@"longtitude"];
        
        

        
        [parmer setValue:@"address" forKey:@"type"];
    }else if (_indexTag==6){
        [parmer setValue:@"wep" forKey:@"type"];
    }
    
    
    
    [parmer setObject:img_Data forKey:@"file1"];
    
    
    [self showHudInView:self.view hint:@""];
    
    [KKRequestDataService requestWithURL:url params:parmer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        [parmer setObject:@"file1" forKey:@"file1"];
        
        NSLog(@"parmer----%@",parmer);
        [self hideHud];
        
        if ([result[@"result_code"] isEqualToString:@"access"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            
            hud.label.text = NSLocalizedString(@"上传成功", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
            [hud hideAnimated:YES afterDelay:3.f];
            
            if (self.indexTag==1)
            {
                [self.imageView1 setImage:savedImage];

                self.ifImageView1=YES;
            }else if (self.indexTag==2)
            {

                if (self.agreeBtn1.selected==YES) {
                    [self.imageView2 setImage:array[2][0]];

                    
                }else{
                    
                    [self.imageView2 setImage:array[1][0]];
                    
                    
                }

                
                self.ifImageView2=YES;
            }else if (self.indexTag==3)
            {
                if (self.agreeBtn1.selected==YES) {
                    
                    [self.imageView3 setImage:array[2][1]];
                    
                    
                }else{
                    [self.imageView3 setImage:array[1][1]];
                    
                }

                self.ifImageView3=YES;
            }else if (self.indexTag==4){
                [self.imageView4 setImage:savedImage];

                self.ifImageView4=YES;
            }else if (self.indexTag==5){
                [self.imageView5 setImage:savedImage];

                self.ifImageView5=YES;
            }else if (self.indexTag==6){
                [self.imageView6 setImage:savedImage];

                self.ifImageView6=YES;
                
            }
            
        }
        NSLog(@"result===%@", result);
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        DebugLog(@"error-----%@",error.description);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"图片太大,上传失败", @"HUD message title");
        hud.label.font = [UIFont systemFontOfSize:13];
        hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
        [hud hideAnimated:YES afterDelay:4.f];
        
    }];
    
}
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    imageData2=[NSData data];
    imageData = UIImageJPEGRepresentation(currentImage, 1.0);
    while ([imageData length]/1000>400) {
        if (imageData.length==imageData2.length) {
            break;
        }
        imageData2=imageData;
        UIImage *image=[[UIImage alloc]initWithData:imageData];
        imageData = UIImageJPEGRepresentation(image, 0.2);
    }
    NSLog(@"+++++++=++++=+++=+%lu",(unsigned long)imageData.length);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField ==_locationLab) {
        for (UITextField *tf in _scrollView.subviews) {
            [tf resignFirstResponder];
        }
        __weak typeof(self) weskSelf = self;

        [FYLCityPickView showPickViewWithComplete:^(NSArray *arr) {
            
            weskSelf.selectAddress_A = arr;
            
            
            weskSelf.locationLab.text = [NSString stringWithFormat:@"%@%@%@",[arr[0] containsString:arr[1]]?@"":arr[0],arr[1],arr[2]];
            
//            [[NSUserDefaults standardUserDefaults]setObject:arr forKey:SELECTADDRESS];
//
//            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }];
        
        return NO;
    }
    if (textField==self.reasonTF) {
        if (self.haveBtn.selected) {
            return NO;
        }
    }
    
    if (textField ==self.detailAddressTF) {
        
        for (UITextField *tf in _scrollView.subviews) {
            [tf resignFirstResponder];
        }
        
        
        if (self.selectAddress_A.count==0) {
            
            if ([shopInfoDic[@"add_info"] count]!=0) {
                NSDictionary *add_info = shopInfoDic[@"add_info"][0];

                self.selectAddress_A= @[add_info[@"province"],add_info[@"city"],add_info[@"district"]];

            }
//            else{
//                self.selectAddress_A = [[NSUserDefaults standardUserDefaults]objectForKey:SELECTADDRESS];

//            }
            
            
            NSLog(@"_selectAddress_A-----%@",_selectAddress_A);
            
            
            if (self.selectAddress_A.count==0) {
                
                
                [self showHint:@"请选择省市区"];
            }else{
                
                [self getStreest];
            }
        }else{
            [self getStreest];
            
        }
       
        
        
        
        
        
        return NO;
    }
    
    if (textField ==_location_log_lat) {

        
    AddressEditVC *vc = [[AddressEditVC alloc]init];
        
        [self presentViewController:vc animated:YES completion:nil];
        
        vc.log_latBlock = ^(NSString *log, NSString *lat) {
          
            _location_log_lat.text = [NSString stringWithFormat:@"%@,%@",log,lat];
            
        };
        
        
        return NO;
    }
    
    
    if (textField ==self.company_styleTF) {
        pickView.dataSource=@[@"国有企业",@"集体企业",@"联营企业",@"股份合作制企业",@"私营企业",@"个体户",@"合作企业",@"有限责任公司",@"股份有限公司"];
        __weak AuthFailShopVC *wealSelf=self;
        pickView.valueDidSelect = ^(NSString *value) {
            
            wealSelf.company_styleTF.text =  [[value componentsSeparatedByString:@"/"] firstObject];
        };
        [pickView show];
        
        return NO;
    }
    
    return YES;
}
-(void)tapAndHidden{
    [_scrollView endEditing:YES];
    [self.view endEditing:YES];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //Tip:我们可以通过打印touch.view来看看具体点击的view是具体是什么名称,像点击UITableViewCell时响应的View则是UITableViewCellContentView.
//    NSLog(@"%@",touch.view);
    if (gestureRecognizer.view == _scrollView) {
        
        if ([NSStringFromClass([touch.view class])    isEqualToString:@"UITableViewCellContentView"]) {
            //返回为NO则屏蔽手势事件
            return NO;
        }
    }
    
    return YES;
}

-(void)getStreest{
    

    
    
    __block typeof(self)  bloskSelf = self;
    
    
    
    NSString *city =[NSString getTheNoNullStr:self.selectAddress_A[1] andRepalceStr:@""];
   city = city.length!=0 ? city :self.selectAddress_A[0];
    
    

      NSLog(@"-app.city-----%@",city);

    [[JFAreaDataManager shareManager] currentCityDic:city currentCityDic:^(NSDictionary *dic) {
        
        
        NSLog(@"-dic-----%@",dic);
        [[JFAreaDataManager shareManager]areaData:dic[@"code"] areaData:^(NSMutableArray *areaData) {
            
            if (areaData.count==0) {
             
                [self showHint:@"当前地区暂无街道数据"];
                
                return ;
            }
            
//            NSLog(@"-areaData-----%@",areaData);
            
            for (NSDictionary *dic in areaData) {
                NSString *name = dic[@"name"];
                
                
                NSString*town = [NSString getTheNoNullStr:self.selectAddress_A[2] andRepalceStr:@""];
                
                town = town.length!=0 ? town :self.selectAddress_A[1];

                town = town.length!=0 ? town :self.selectAddress_A[0];

                
                if ([name isEqualToString:town]) {
                    
                    
                    NSString *url = [NSString stringWithFormat:@"%@Extra/address/getStreet",BASEURL];;
                    
                    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
                    [parame setValue:dic[@"code"] forKey:@"district_id"];
                    
                    NSLog(@"url====+%@=====%@",url,parame);
                    [KKRequestDataService requestWithURL:url params:parame httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
                        
//                        NSLog(@"-areaData-----%@",areaData);
                        
                        
                
                        eare_data = [NSMutableArray arrayWithArray:result];
                        
                        
                        NSMutableArray *arr = [NSMutableArray array];
                        for (NSDictionary *dic_eare in result) {
                            [arr addObject:dic_eare[@"name"]];
                            
                        }
                        
                        
                        self.streetArray=[[NSArray alloc]initWithArray:arr];
                        pickView= [[ValuePickerView alloc]init];
                        
//                        NSLog(@"--------------%@",arr);
                        pickView.dataSource = arr;
                        pickView.valueDidSelect = ^(NSString *value) {
                            
                            
                            bloskSelf.detailAddressTF.text =  [[value componentsSeparatedByString:@"/"] firstObject];
                            
                        };
                        
                        [pickView show];
                        
                    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                    }];
                    
                    
                    
                    
                    
                    
                    break;
                    
                    
                }
            }
            
        }];
    }];
    

}

-(void)refreshAddMoreView{
    
    [add_more_view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    for (int i = 0; i <=self.add_more_img_A.count; i++) {
        
        LZDButton *img_btn = [LZDButton creatLZDButton];
        int X  = i%3;
        int Y = i/3;
        int w =(SCREENWIDTH-26-20)/3;
        int h =(SCREENWIDTH-26-20)/3*116/176;

        
        img_btn.frame = CGRectMake(13+X*(w+10), Y*(h+10), w, h);
        [add_more_view addSubview:img_btn];
        
        if (i==_add_more_img_A.count) {
            
            [img_btn setImage:[UIImage imageNamed:@"补充+"] forState:UIControlStateNormal];
            [img_btn setImage:[UIImage imageNamed:@"补充+"] forState:UIControlStateHighlighted];

            
            
            
            img_btn.block = ^(LZDButton *sender) {
                
                self.indexTag=333;

                [self.view endEditing:YES];
                UIActionSheet *sheet;
                // 判断是否支持相机
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                    
                {
                    sheet  = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
                    
                }
                
                else {
                    
                    sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
                    
                }
                
                sheet.tag = 255;
                
                [sheet showInView:self.view];
                

                
                
            };
            

        }else{
            
            [img_btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ADDFILEIMAGES,self.add_more_img_A[i][@"image_url"]]] forState: UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon3.png"]];
            
            [img_btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ADDFILEIMAGES,self.add_more_img_A[i][@"image_url"]]] forState: UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"icon3.png"]];
            
            LZDButton *deletBtn = [LZDButton creatLZDButton];
            deletBtn.frame = CGRectMake(img_btn.width-50, 0, 50, 50);
            deletBtn.backgroundColor = [UIColor clearColor];
        
            [deletBtn setImage:[UIImage imageNamed:@"删除图标LD"] forState:UIControlStateNormal];
            [deletBtn setImage:[UIImage imageNamed:@"删除图标LD"] forState:UIControlStateHighlighted];

            deletBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 30, 30, 0);
            
            deletBtn.block = ^(LZDButton *sender) {
              
                [self postRequestDeleteAddPictures:self.add_more_img_A[i]];
                
            };
            
            [img_btn addSubview:deletBtn];
            
            

        }
        

        CGRect frame =  add_more_view.frame;
        frame.size.height = img_btn.bottom;
        add_more_view.frame = frame;
        
    }
   
    
    _scrollView.contentSize=CGSizeMake(SCREENWIDTH, add_more_view.bottom+100);
    sureBtn.frame=CGRectMake(SCREENWIDTH/2-50, _scrollView.contentSize.height-60, 100, 40);

    
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];//取消第一响应者
    
    return YES;
}
//获取补充材料
-(void)postRequestGetAddPictures{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/register/getExtra",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:shopInfoDic[@"muid"] forKey:@"muid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        if (result) {
            self.add_more_img_A=[NSMutableArray arrayWithArray:result[@"extra_list"]];
            [self refreshAddMoreView];
        }
        NSLog(@" KKRequestDataService ==%@", result);
 
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"%@", error);
    }];

}
-(void)postRequestAddPicturesToServer:(NSData *)file{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/RegisterUpload/upload_extra",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:shopInfoDic[@"muid"] forKey:@"muid"];//file1
    [params setObject:file forKey:@"file1"];
    NSLog(@"%@",shopInfoDic[@"muid"]);
    
    [self showHudInView:self.view hint:@""];

    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [self hideHud];
        NSLog(@" KKRequestDataService ==%@", result);
        if (result) {
            if ([[NSString getTheNoNullStr:result[@"result_code"] andRepalceStr:@"123"] isEqualToString:@"access"]) {
                 [self postRequestGetAddPictures];
            }
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"%@", error);
    }];

}
-(void)postRequestDeleteAddPictures:(NSDictionary *)dic{
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/RegisterUpload/delete_extra",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:dic[@"muid"] forKey:@"muid"];//file1
    [params setObject:dic[@"image_url"] forKey:@"image_url"];
    NSLog(@"%@",shopInfoDic[@"muid"]);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@" KKRequestDataService ==%@", result);
        if (result) {
            if ([result[@"result_code"] integerValue]==1) {
                 [self postRequestGetAddPictures];
            }
        }
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        NSLog(@"%@", error);
    }];

}
@end
