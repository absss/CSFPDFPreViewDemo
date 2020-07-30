//
//  ViewController.m
//  CSFPDFPreViewDemo
//
//  Created by hehaichi on 2020/7/30.
//  Copyright © 2020 hehaichi. All rights reserved.
//


#import "ViewController.h"
#import "CSFPDFPreViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button1];
    [button1 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [button1 setTitle:@"查看pdf" forState:UIControlStateNormal];
    button1.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2 - 60, 80, 120, 44);
    [button1 addTarget:self action:@selector(action1) forControlEvents:UIControlEventTouchUpInside];
  
}

- (void)action1 {
    NSString * path = [[NSBundle mainBundle] pathForResource:@"阿里巴巴java开发手册.pdf" ofType:nil];
    NSURL * url = [NSURL fileURLWithPath:path];
    CSFPDFPreViewController *vc = [CSFPDFPreViewController new];
    vc.srcURL = url;
    [self presentViewController:vc animated:YES completion:nil];
}


@end
