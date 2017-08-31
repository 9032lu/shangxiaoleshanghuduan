//
//  ChatForAllDatasVC.m
//  BletcShop
//
//  Created by apple on 2017/8/31.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ChatForAllDatasVC.h"

@interface ChatForAllDatasVC ()

@end

@implementation ChatForAllDatasVC

- (void)viewDidLoad {
    [super viewDidLoad];
    LEFTBACK
    self.navigationItem.title=@"数据报表";
    UIWebView *web=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    [self.view addSubview:web];
    [web loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:self.url]]];
    
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
