//
//  AddressEditVC.m
//  BletcShop
//
//  Created by Bletc on 2017/9/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AddressEditVC.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
@interface AddressEditVC ()<BMKMapViewDelegate,BMKLocationServiceDelegate,UITextFieldDelegate,BMKGeoCodeSearchDelegate>

@property(nonatomic,strong)BMKMapView* mapView;
@property(nonatomic,strong)BMKLocationService* locService;
@property (nonatomic,strong)BMKUserLocation *userLocation; //定位功能
@property (nonatomic, strong)BMKGeoCodeSearch* searchAddress;

@property (nonatomic, strong)BMKReverseGeoCodeOption *reverseGeoOption;//反检索
@property (nonatomic, strong)BMKReverseGeoCodeResult *reverseGeoCodeResult;//反检索结果

@property (nonatomic, strong)BMKGeoCodeSearchOption*geoCodeSearchOption;//检索


@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;//中心经纬度

@property(nonatomic,strong)UIImageView *centerAnnotion;//中心的大头针
@property (strong, nonatomic) IBOutlet UILabel *coordinate_lab;
@property (strong, nonatomic) IBOutlet UITextField *detailAddress;
@property (strong, nonatomic) IBOutlet UILabel *province_city;
@end

@implementation AddressEditVC



- (IBAction)goback:(UIButton *)sender {
    
    NSArray *arr = [self.coordinate_lab.text componentsSeparatedByString:@","];
    
    self.log_latBlock(arr[0], arr[1]);
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    LEFTBACK
    self.navigationItem.title = @"编辑地址";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
    
    self.detailAddress.layer.BorderColorFromUIColor = [UIColor clearColor];
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0,64+145, SCREENWIDTH, SCREENHEIGHT-145-64)];
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.showMapScaleBar = YES;//显示比例尺
    _mapView.zoomLevel=18;//地图显示的级别
    _mapView.rotateEnabled=YES;//允许旋转
    _mapView.mapType=BMKMapTypeStandard;
    [self.view addSubview:_mapView];

    _centerAnnotion = [[UIImageView alloc]init];
    _centerAnnotion.bounds = CGRectMake(0, 0, 30, 30);
    _centerAnnotion.center = CGPointMake(_mapView.center.x, _mapView.center.y-30/2);
    _centerAnnotion.image = [UIImage imageNamed:@"大头针"];

    [self.view addSubview:_centerAnnotion];
    
    
       //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    
    //启动LocationService
    [_locService startUserLocationService];
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _searchAddress = [[BMKGeoCodeSearch alloc] init];

    
    
    
}

-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    NSLog(@"mapView.region.center=%lf=%lf",mapView.region.center.longitude,mapView.region.center.latitude);

        _reverseGeoOption.reverseGeoPoint = self.centerCoordinate;
        
        BOOL flag = [_searchAddress reverseGeoCode:_reverseGeoOption];
        if(flag){
            NSLog(@"regionDidChangeAnimated反geo检索发送成功");
        }else{
            NSLog(@"regionDidChangeAnimated反geo检索发送失败");
        }


 
   
    
    
}
-(void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status{
    [_detailAddress resignFirstResponder];
    
    self.coordinate_lab.text = [NSString stringWithFormat:@"%lf,%lf",status.targetGeoPt.longitude,status.targetGeoPt.latitude];


    
    self.centerCoordinate =status.targetGeoPt;
    
    
    NSLog(@"targetGeoPt=%lf=%lf",status.targetGeoPt.longitude,status.targetGeoPt.latitude);
    
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"当前位置%f,%f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    
    self.coordinate_lab.text = [NSString stringWithFormat:@"%lf,%lf",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude];

  

    self.centerCoordinate = userLocation.location.coordinate;
    
    
    

    
    _userLocation=userLocation;
    [_mapView updateLocationData:userLocation];
    
    _mapView.centerCoordinate = userLocation.location.coordinate;
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    _reverseGeoOption = [[BMKReverseGeoCodeOption alloc]init];
    _reverseGeoOption.reverseGeoPoint = pt;
    
    BOOL flag = [_searchAddress reverseGeoCode:_reverseGeoOption];
    if(flag){
        NSLog(@"反geo检索发送成功");
    }else{
        NSLog(@"反geo检索发送失败");
    }
    
    
    
    [_mapView updateLocationData:userLocation];
    [_locService stopUserLocationService];//取消定位
}

//具体地址的打印
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    self.reverseGeoCodeResult = result;
    
    self.province_city.text=[NSString stringWithFormat:@"%@%@%@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district];
    

    
        self.detailAddress.text = [NSString stringWithFormat:@"%@%@",result.addressDetail.streetName,result.addressDetail.streetNumber];

    
    
    
    NSLog(@"onGetReverseGeoCodeResult=%@",result.address);

    
   
    
    
}

//正向检索

-(void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    NSLog(@"onGetGeoCodeResult=%@=%lf=%lf==%d",result.address,result.location.longitude,result.location.latitude,error);
    
    if (error ==BMK_SEARCH_NO_ERROR) {

        self.centerCoordinate = result.location;
        _mapView.centerCoordinate = result.location;

    }else if (error ==BMK_SEARCH_RESULT_NOT_FOUND){
        [self showHint:@"该城市没找到相关地址"];
    }else {
        [self showHint:@"检索错误"];
    }
    
    
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    
    if (textField.text.length==0) {
        [self showHint:@"请输入详细地址"];
    }else{
        if (!self.geoCodeSearchOption) {
            self.geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
            
        }
        _geoCodeSearchOption.city =self.reverseGeoCodeResult.addressDetail.city;
        _geoCodeSearchOption.address  = self.detailAddress.text;
        
        
        BOOL flag = [_searchAddress geoCode:_geoCodeSearchOption];
        
        if(flag){
            NSLog(@"geo检索发送成功");
        }else{
            NSLog(@"geo检索发送失败");
        }
        

    }
    
    
    return YES;
}

-(void)sureClick{
    
    
    POP
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [ _mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate=self;
    _searchAddress.delegate=self;

    
    
    BMKLocationViewDisplayParam* testParam = [[BMKLocationViewDisplayParam alloc] init];
    testParam.isRotateAngleValid = false;// 跟随态旋转角度是否生效
    testParam.isAccuracyCircleShow = false;// 精度圈是否显示
    
    [_mapView updateLocationViewWithParam:testParam];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [ _mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate=nil;
    _searchAddress.delegate=nil;

}

@end
