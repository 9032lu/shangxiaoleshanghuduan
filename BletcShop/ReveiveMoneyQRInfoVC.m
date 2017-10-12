//
//  ReveiveMoneyQRInfoVC.m
//  BletcShop
//
//  Created by Bletc on 2016/12/5.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "ReveiveMoneyQRInfoVC.h"
#import "HGDQQRCodeView.h"

@interface ReveiveMoneyQRInfoVC ()<UIActionSheetDelegate>
{
    MBProgressHUD *shophud;
}
@property (nonatomic,strong)  UIView *QRView;
@property (strong, nonatomic)  UILabel *msglabel;

@end

@implementation ReveiveMoneyQRInfoVC


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = NavBackGroundColor;
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    topView.backgroundColor =NavBackGroundColor;
    [self.view addSubview:topView];
    
    
     LZDButton *back =[LZDButton creatLZDButton];
    back.frame = CGRectMake(0, 24, 30, 40);
    back.imageEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 0);
    [back setImage:[UIImage imageNamed:@"返回（白）"] forState:0];
    back.block = ^(LZDButton *sender) {
        POP
        
    };
    [topView addSubview:back];
    
    UILabel*titlelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, +20, SCREENWIDTH, 44)];
    titlelabel.text=@"收款";
    titlelabel.font=[UIFont systemFontOfSize:19];
    titlelabel.textAlignment=NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    [topView addSubview:titlelabel];
    
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(22, topView.bottom+6, SCREENWIDTH-44, 467)];
    
    whiteView.layer.cornerRadius = 12;
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    
    UILabel*title_label=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, whiteView.width, 15)];
    title_label.text=@"二维码收款";
    title_label.font=[UIFont systemFontOfSize:16];
    title_label.textAlignment=NSTextAlignmentCenter;
    title_label.textColor = RGB(51,51,51);
    [whiteView addSubview:title_label];
    
    
    self.QRView = [[UIView alloc]initWithFrame:CGRectMake(38, 95, whiteView.width-38*2, whiteView.width-38*2)];
    [whiteView addSubview:_QRView];
    

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressClcik:)];
    
    [self.QRView addGestureRecognizer:longPress];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, self.QRView.bottom+30, whiteView.width, 50)];
    label.numberOfLines=0;
    label.text=@"提示：用户扫描此二维码\n\n可进行会员结算、购买会员卡等";
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=RGB(119,119,119);
    label.font=[UIFont systemFontOfSize:13.0f];
    [whiteView addSubview:label];
    
    [self postRequesQrcode];
    
    
    CGRect fram = whiteView.frame ;
    fram.size.height = label.bottom+41;
    whiteView.frame = fram;
    
}

-(void)longPressClcik:(UILongPressGestureRecognizer*)longPress{
    
    NSLog(@"longPressClcik");

    if (longPress.state ==UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到相册", nil];
        
        [actionSheet showInView:self.view];

    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    NSLog(@"----_%ld",(long)buttonIndex);
    if (buttonIndex==0) {
        UIImage *image = [HGDQQRCodeView screenShotFormView:self.QRView];
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void*)self);

    }
    
  }


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.userInteractionEnabled = YES;
    
    [hud hideAnimated:YES afterDelay:2.f];
    if (error) {
        hud.label.text = NSLocalizedString(@"保存失败", @"HUD message title");
    }else{
        hud.label.text = NSLocalizedString(@"保存成功", @"HUD message title");
    }

}
-(void)postRequesQrcode{
   // http://101.201.100.191/cnconsum/App/MerchantType/gather/genQrcode
    NSString *url = [NSString stringWithFormat:@"%@MerchantType/gather/genQrcode",BASEURL];
     AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    shophud =[MBProgressHUD showHUDAddedTo:window animated:YES];
    shophud.label.text = @"";
    
    NSLog(@"%@",paramer);
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        printf("result====%s",[[NSString dictionaryToJson:result] UTF8String]);
        [shophud hideAnimated:YES];
        if (result) {

            NSString *codeString =result[@"qrcode"];
            
            [HGDQQRCodeView creatQRCodeWithURLString:codeString superView:self.QRView logoImage:[UIImage imageNamed:@""] logoImageSize:CGSizeMake(SCREENWIDTH*0.2, SCREENWIDTH*0.2) logoImageWithCornerRadius:0];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        shophud.label.text = @"接口出错404！";
        [shophud hideAnimated:YES afterDelay:0.8];
    }];
}

@end
