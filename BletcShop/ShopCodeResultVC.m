//
//  ShopCodeResultVC.m
//  BletcShop
//
//  Created by apple on 2017/9/25.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ShopCodeResultVC.h"

@interface ShopCodeResultVC ()
@property (weak, nonatomic) IBOutlet UILabel *cardType;
@property (weak, nonatomic) IBOutlet UILabel *payMoneyOrCounts;
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation ShopCodeResultVC
- (IBAction)confirmBtnClick:(id)sender {
    
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
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
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