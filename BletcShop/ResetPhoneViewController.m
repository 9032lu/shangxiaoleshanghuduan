//
//  ResetPhoneViewController.m
//  BletcShop
//
//  Created by Bletc on 2017/2/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ResetPhoneViewController.h"
#import "ResetPhoneNextVC.h"

@interface ResetPhoneViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@end

@implementation ResetPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更换手机号";
    LEFTBACK
}
- (IBAction)nextBtn:(UIButton *)sender {
    
    [self.phoneTF resignFirstResponder];
    
    ResetPhoneNextVC *VC = [[ResetPhoneNextVC alloc]init];
    VC.phone = self.phoneTF.text;
    VC.whoPush = self.whoPush;
    [self.navigationController pushViewController:VC animated:YES];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
