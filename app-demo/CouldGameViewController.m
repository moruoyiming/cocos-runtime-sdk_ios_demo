//
//  CouldGameViewController.m
//  app-demo
//
//  Created by 菅瑞霖 on 2021/2/4.
//

#import <Foundation/Foundation.h>
#import "CouldGameViewController.h"

@interface CouldGameViewController ()

@end

@implementation CouldGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self setButton];
}

- (void)setButton {
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(100, 100, 100, 50);
    button.backgroundColor = [UIColor blackColor];
    [button setTitle:@"pop" forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(popVC) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button1.frame = CGRectMake(100, 200, 100, 50);
    button1.backgroundColor = [UIColor blackColor];
    [button1 setTitle:_text forState:(UIControlStateNormal)];
    [button1 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [button1 addTarget:self action:@selector(presentVC) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button1];
    
}

- (void)popVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentVC {
    [self presentViewController:[CouldGameViewController new] animated:YES completion:nil];
}

@end
