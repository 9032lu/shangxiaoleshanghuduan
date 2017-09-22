//
//  SendCouponCompleteVC.m
//  BletcShop
//
//  Created by apple on 2017/9/22.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "SendCouponCompleteVC.h"

@interface SendCouponCompleteVC ()

@end

@implementation SendCouponCompleteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"推送完成";
    LEFTBACK
   
}
- (IBAction)backToRootVC:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
