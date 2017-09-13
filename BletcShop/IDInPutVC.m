//
//  IDInPutVC.m
//  BletcShop
//
//  Created by apple on 2017/9/13.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "IDInPutVC.h"
#import "UserInfoEditVC.h"
@interface IDInPutVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@end

@implementation IDInPutVC
- (IBAction)accessCodeBtnClick:(id)sender {
     [_phoneTF resignFirstResponder];
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (_phoneTF.text.length==18) {
        if ([_phoneTF.text isEqualToString:[NSString getTheNoNullStr:delegate.shopInfoDic[@"id"] andRepalceStr:@"111111111111111111"]]) {
            UserInfoEditVC *VC = [[UserInfoEditVC alloc]init];
            VC.whoPush = @"商户";
            VC.leibie = @"银行卡号";
            [self.navigationController pushViewController:VC animated:YES];
        }else{
            [self showHint:@"身份证号码错误!"];
        }
    }else{
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"身份证号码长度不对!" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    LEFTBACK
    self.navigationItem.title=@"身份验证";
    _phoneTF.delegate=self;
    _phoneTF.returnKeyType=UIReturnKeyDone;
    _phoneTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self setTextFieldLeftImageView:_phoneTF leftImageName:@"推荐人"];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}
-(void)fingerTapped:(UITapGestureRecognizer *)tap{
    [tap.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)setTextFieldLeftImageView:(UITextField *)textField leftImageName:(NSString *)imageName
{
    // 设置左边图片
    UIImageView *leftView     = [[UIImageView alloc] init];
    leftView.image            = [UIImage imageNamed:imageName];
    leftView.bounds = CGRectMake(0, 0, 30, 30);
    //    leftView.height = 30;
    //    leftView.width = 30;
    
    // 设置leftView的内容居中
    leftView.contentMode      = UIViewContentModeCenter;
    textField.leftView        = leftView;
    
    // 设置左边的view永远显示
    textField.leftViewMode    = UITextFieldViewModeAlways;
    
    // 设置右边永远显示清除按钮
    textField.clearButtonMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
