//
//  PushAdverViewController.m
//  BletcShop
//
//  Created by Bletc on 2017/2/23.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "PushAdverViewController.h"

#import "AdvertisementHomeVC.h"
#import "AdverListViewController.h"
#import "AdverShowViewController.h"

@interface PushAdverViewController ()

@property (weak, nonatomic) IBOutlet UIButton *listBtn;
@property (weak, nonatomic) IBOutlet UIButton *pushBtn;

@end

@implementation PushAdverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"广告投放";
    
    
LEFTBACK
    
    
    LZDButton *button=[LZDButton creatLZDButton];
    button.frame=CGRectMake(0, 0, 40, 20);
    [button setTitle:@"说明" forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    
    button.block = ^(LZDButton *sender) {
      PUSH(AdverShowViewController)
    };
    
}
- (IBAction)pushAdverBtn:(UITapGestureRecognizer *)sender {
    
    AdverListViewController *advertisementHomeVC=[[AdverListViewController alloc]init];
    [self.navigationController pushViewController:advertisementHomeVC animated:YES];
    
}
- (IBAction)adverListBtn:(UITapGestureRecognizer*)sender {
    
    AdvertisementHomeVC *advertisementHomeVC=[[AdvertisementHomeVC alloc]init];
    [self.navigationController pushViewController:advertisementHomeVC animated:YES];
   
}





@end
