//
//  BankCardChangeVC.m
//  BletcShop
//
//  Created by apple on 2017/9/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "BankCardChangeVC.h"

@interface BankCardChangeVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *idCardNumTF;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTF;
@property (weak, nonatomic) IBOutlet UITextField *bankCardNum;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation BankCardChangeVC
- (IBAction)changeCardNumClick:(id)sender {
    [_nameTF resignFirstResponder];
    [_idCardNumTF resignFirstResponder];
    [_bankNameTF resignFirstResponder];
    [_bankCardNum resignFirstResponder];
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([_nameTF.text isEqualToString:@""]) {
        [self showHint:@"请输入您的姓名"];
    }else if ([_idCardNumTF.text isEqualToString:@""]){
        [self showHint:@"请输入您的身份证号"];
    }else if ([_bankNameTF.text isEqualToString:@""]){
        [self showHint:@"请输入您的开户行"];
    }else if ([_bankCardNum.text isEqualToString:@""]){
        [self showHint:@"请输入您的银行卡号"];
    }else if (_idCardNumTF.text.length!=18){
        [self showHint:@"身份证号长度有误！"];
    }else if (![_idCardNumTF.text isEqualToString:[NSString getTheNoNullStr:delegate.shopInfoDic[@"id"] andRepalceStr:@"!!!"]]){
        [self showHint:@"身份证号不对"];
    }else if (_bankCardNum.text.length!=16&&_bankCardNum.text.length!=19){
        [self showHint:@"银行卡号长度有误"];
    }else{
        //去修改account
        [self postRequestAddress];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"修改银行卡号";
    LEFTBACK
    self.confirmButton.layer.cornerRadius=10;
    self.confirmButton.clipsToBounds=YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认修改前，请务必检查您输入的卡号是否有误，以免提现时给您带来不必要的麻烦！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [sureAction setValue:NavBackGroundColor forKey:@"titleTextColor"];
    
    [alert addAction:sureAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)postRequestAddress
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/accountSet",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    [params setObject:@"account" forKey:@"type"];
    [params setObject:self.bankCardNum.text forKey:@"para"];
    NSLog(@"%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         
         NSLog(@"%@", result);
         
         
         if ([result[@"result_code"] intValue]==1) {
             [self showHint:@"修改成功"];
            
             AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
             
             NSMutableDictionary *mutab_dic = [NSMutableDictionary dictionaryWithDictionary:appdelegate.shopInfoDic];
            [mutab_dic setObject:self.bankCardNum.text forKey:@"account"];
             appdelegate.shopInfoDic = mutab_dic;
             [self performSelector:@selector(popVC) withObject:nil afterDelay:1.5];
             
         }else
         {
              [self showHint:@"请求失败 请重试"];
         }
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"%@", error);
         
     }];
    
}

-(void)popVC{
   
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
