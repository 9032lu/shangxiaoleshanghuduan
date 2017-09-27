//
//  ShopCodeResultVC.m
//  BletcShop
//
//  Created by apple on 2017/9/25.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ShopCodeResultVC.h"
#import "UIImageView+WebCache.h"
@interface ShopCodeResultVC ()
{
    MBProgressHUD *shophud;
}
@property (weak, nonatomic) IBOutlet UILabel *cardType;
@property (weak, nonatomic) IBOutlet UILabel *payMoneyOrCounts;
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation ShopCodeResultVC
- (IBAction)confirmBtnClick:(id)sender {
    [self postRequestPayForVipCards:self.postDic];
}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.confirmBtn.layer.borderColor = [RGB(9,192,132) CGColor];
    self.confirmBtn.layer.borderWidth=1;
    self.confirmBtn.layer.cornerRadius=6;
    self.confirmBtn.clipsToBounds=YES;
    if ([[NSString getTheNoNullStr:self.dic[@"operate"] andRepalceStr:@""] isEqualToString:@"count_card"]) {
        self.cardType.text=@"付款卡种：计次卡";
        self.payMoneyOrCounts.text=[NSString stringWithFormat:@"%@次",[NSString getTheNoNullStr:self.dic[@"num"] andRepalceStr:@"0.00"]];
    }else if ([[NSString getTheNoNullStr:self.dic[@"operate"] andRepalceStr:@""] isEqualToString:@"value_card"]){
        self.cardType.text=@"付款卡种：储值卡";
        self.payMoneyOrCounts.text=[NSString stringWithFormat:@"%@元",[NSString getTheNoNullStr:self.dic[@"sum"] andRepalceStr:@"0.00"]];
    }else if ([[NSString getTheNoNullStr:self.dic[@"operate"] andRepalceStr:@""] isEqualToString:@"exp_card"]){
        self.cardType.text=@"付款卡种：体验卡";
        self.payMoneyOrCounts.text=[NSString stringWithFormat:@"%@元",[NSString getTheNoNullStr:self.dic[@"sum"] andRepalceStr:@"0.00"]];
    }
    [self.head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,self.dic[@"headimage"]]] placeholderImage:[UIImage imageNamed:@"userHeader"]];
    self.nickName.text=self.dic[@"nickname"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}
-(void)postRequestPayForVipCards:(NSDictionary*)dic{
    //http://101.201.100.191/cnconsum/App/MerchantType/gather/commit
    NSString *url = [NSString stringWithFormat:@"%@MerchantType/gather/commit",BASEURL];
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    shophud =[MBProgressHUD showHUDAddedTo:window animated:YES];
    shophud.label.text = @"交易正在进行...";
    
    NSLog(@"%@",paramer);
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        printf("result====%s",[[NSString dictionaryToJson:result] UTF8String]);
        [shophud hideAnimated:YES];
        if ([result[@"result_code"] integerValue]==1) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收款成功！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [sureAction setValue:RGB(9,192,132) forKey:@"titleTextColor"];
            
            [alert addAction:sureAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else if([result[@"result_code"] integerValue]==-1){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"订单失效！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [sureAction setValue:RGB(9,192,132) forKey:@"titleTextColor"];
            
            [alert addAction:sureAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收款失败！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [sureAction setValue:RGB(9,192,132) forKey:@"titleTextColor"];
            
            [alert addAction:sureAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        shophud.label.text = @"接口出错404！";
        [shophud hideAnimated:YES afterDelay:0.3];
    }];
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
