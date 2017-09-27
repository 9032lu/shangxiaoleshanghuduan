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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"二维码";
    LEFTBACK
    self.QRView = [[UIView alloc]initWithFrame:CGRectMake(20, 50, SCREENWIDTH-40, SCREENWIDTH-40)];
    [self.view addSubview:_QRView];
    

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressClcik:)];
    
    [self.QRView addGestureRecognizer:longPress];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, self.QRView.bottom+30, SCREENWIDTH, 50)];
    label.numberOfLines=0;
    label.text=@"提示：用户扫描此二维码，可进行会员结算、购买会员卡等";
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=RGB(51, 51, 51);
    label.font=[UIFont systemFontOfSize:13.0f];
    [self.view addSubview:label];
    
    [self postRequesQrcode];
    
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
            
            [HGDQQRCodeView creatQRCodeWithURLString:codeString superView:self.QRView logoImage:[UIImage imageNamed:@"app_icon3"] logoImageSize:CGSizeMake(SCREENWIDTH*0.2, SCREENWIDTH*0.2) logoImageWithCornerRadius:0];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        shophud.label.text = @"接口出错404！";
        [shophud hideAnimated:YES afterDelay:0.8];
    }];
}

@end
