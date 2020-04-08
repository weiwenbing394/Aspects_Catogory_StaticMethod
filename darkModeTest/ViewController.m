//
//  ViewController.m
//  darkModeTest
//
//  Created by 魏文彬 on 2020/3/24.
//  Copyright © 2020 XW. All rights reserved.
//

#import "ViewController.h"
#import "AspectsApiTest.h"
#import "Aspects.h"

#import "CAShapeLayer+XYColorOC.h"
#import "UIView+XYLayerColor.h"
#import "DarkModeLoadFile.h"

#import "XYZQBaseWKWebView.h"

@interface ViewController ()

@end

@implementation ViewController

+ (void)load{
    [super load];
    [[AspectsApiTest alloc] aspect_hookStaticSelector:@selector(testStaticMethod) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo)
    {
        NSLog(@"hook住了");
    } error:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)dialPhoneNumber:(NSString *)numStr
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",numStr]];
    XYZQBaseWKWebView *phoneCallWebView = (XYZQBaseWKWebView *)[self.view viewWithTag:661];
    if ( phoneCallWebView==nil ) {
        phoneCallWebView = [[XYZQBaseWKWebView alloc] initWithFrame:CGRectZero];
        phoneCallWebView.tag = 661;
        [self.view addSubview:phoneCallWebView];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

- (void)test{
//    AspectsApiTest *test = [[AspectsApiTest alloc]init];
//    [test testInstanceMethod];
    [AspectsApiTest testStaticMethod];
}


@end
