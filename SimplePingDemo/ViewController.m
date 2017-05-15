//
//  ViewController.m
//  SimplePingDemo
//
//  Created by wanghe on 2017/5/15.
//  Copyright © 2017年 wanghe. All rights reserved.
//

#import "ViewController.h"

#import "WHPingTester.h"

@interface ViewController ()<WHPingDelegate>
{
    UILabel* _pingLabel;
}
@property(nonatomic, strong) WHPingTester* pingTester;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    _pingLabel.textColor = [UIColor blackColor];
    _pingLabel.textAlignment = NSTextAlignmentCenter;
    _pingLabel.center = self.view.center;
    [self.view addSubview:_pingLabel];


    //ping
    self.pingTester = [[WHPingTester alloc] initWithHostName:@"www.baidu.com"];
    self.pingTester.delegate = self;
    [self.pingTester startPing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark ping的回调
- (void) didPingSucccessWithTime:(float)time withError:(NSError *)error
{
    if(error){
        NSLog(@"网络有问题");
    }else{
        _pingLabel.text = [[NSString stringWithFormat:@"%d", (int)time] stringByAppendingString:@"ms"];
    }
}


@end
