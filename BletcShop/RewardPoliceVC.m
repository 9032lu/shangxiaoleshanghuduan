//
//  RewardPoliceVC.m
//  BletcShop
//
//  Created by Bletc on 2017/9/14.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "RewardPoliceVC.h"

@interface RewardPoliceVC ()
@property (strong, nonatomic) IBOutlet UILabel *rule1;
@property (strong, nonatomic) IBOutlet UILabel *rule2;

@end

@implementation RewardPoliceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    LEFTBACK
    self.navigationItem.title = @"奖励政策";

    self.rule1.text = @"1）推荐用户100人，奖励388元，单人成本3.88元；\n2）推荐用户300人，奖励1188元，单人成本3.88元；\n3）推荐用户600人，奖励2888元，单人成本4.81元；\n4）推荐用户1000人，奖励5888元，单人成本5.88元；\n5）推荐用户3000人，奖励18888元，单人成本6.30元；\n6）推荐用户6000人，奖励38888元，单人成本6.48元；\n7）推荐用户10000人，奖励68888元，单人成本6.88元；";
    self.rule2.text = @"1）随推荐人数增加逐级发放和补发奖金，例如当前推荐用户达到100人时奖励388元，当推荐人数上升至600人数，补发（2888元 - 388元=2500元）2500元奖金。\n2）推荐用户人数超过1万以上的按688元/100人奖励。\n3)用户未到额定人数时（例如推荐100人而未到达到100人）则不能获得奖励。";


}




@end
