//
//  BuyMessagesVC.m
//  BletcShop
//
//  Created by apple on 2017/10/16.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "BuyMessagesVC.h"

@interface BuyMessagesVC ()
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;

@end

@implementation BuyMessagesVC
- (IBAction)btnPayClick:(id)sender {
    
}
- (IBAction)btnClick:(UIButton *)sender {
    for (UIView *view in sender.superview.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button=(UIButton *)view;
            if (button.tag==sender.tag) {
                button.layer.borderColor=RGB(58,174,218).CGColor;
                [button setTitleColor:RGB(58,174,218) forState:UIControlStateNormal];
            }else{
                view.layer.borderColor=RGB(155,156,156).CGColor;
                [button setTitleColor:RGB(155,156,156) forState:UIControlStateNormal];
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btn1.layer.borderWidth=1;
    self.btn2.layer.borderWidth=1;
    self.btn3.layer.borderWidth=1;
    self.btn4.layer.borderWidth=1;
    self.btn1.layer.borderColor=RGB(58,174,218).CGColor;
    self.btn2.layer.borderColor=RGB(155,156,156).CGColor;
    self.btn3.layer.borderColor=RGB(155,156,156).CGColor;
    self.btn4.layer.borderColor=RGB(155,156,156).CGColor;
    LEFTBACK
    self.navigationItem.title=@"购买群发";
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"应付金额：¥100"];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:RGB(241,122,18) range:NSMakeRange(6, 3)];
    
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0] range:NSMakeRange(6, 3)];
    self.payMoney.attributedText=AttributedStr;
    
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
