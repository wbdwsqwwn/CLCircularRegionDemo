//
//  ViewController.m
//  地理围栏
//
//  Created by wanbd on 16/7/22.
//  Copyright © 2016年 ES. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(readonly, nonatomic)CLLocation *mylocation; //我的位置


@end

@implementation ViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //关闭定位
    [self.locationManager stopUpdatingLocation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 30);
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitle:@"开启定位" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonOnClick) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view, typically from a nib.
}

-(CLLocationManager*)locationManager
{
    if (_locationManager == nil) {
        //1.创建位置管理器（定位用户的位置
        self.locationManager = [[CLLocationManager alloc] init];
        //2.设置代理
        self.locationManager.delegate=self;
        //始终允许访问位置信息
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    
    return _locationManager;
}
- (void)buttonOnClick
{
    //判断用户定位服务是否开启
    if ([CLLocationManager locationServicesEnabled]) {
        CLCircularRegion  *region = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(40.042757,116.274822) radius:10 identifier:@"coreLocation"];
        NSLog(@"%@",region);
        //开始定位用户的位置
        [self.locationManager startUpdatingLocation];
        [self.locationManager startMonitoringForRegion:region];
        //每隔多少米定位一次（这里的设置为任何的移动）
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置定位的精准度，一般精准度越高，越耗电（这里设置为精准度最高的，适用于导航应用）
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }else {
        //不能定位用户的位
        //1.提醒用户检查当前的网络状况
        //2.提醒用户打开定位开关
        NSLog(@"定位没有开启或者网络不好");
    }
    
}

#pragma mark CLLocationManagerDelegate
//用户改变当前的授权权限的时候
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"用户改变授权权限 %d", status);
}
//当定位到用户的位置时，就会调用（调用的频率比较频繁）
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //locations数组里边存放的是CLLocation对象，一个CLLocation对象就代表着一个位置
    _mylocation = [locations firstObject];
    NSLog(@"纬度=%f，经度=%f",_mylocation.coordinate.latitude, _mylocation.coordinate.longitude);
    //停止更新位置（如果定位服务不需要实时更新的话，那么应该停止位置的更新）
    
}

#pragma mark - 监控设备进出区域方法
/**
 *  设备进入指定区域
 *
 *  @param manager <#manager description#>
 *  @param region  <#region description#>
 */
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"我进来了");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"区域检测提示" message:@"您已经进入亚信研发大厦!"preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了确定按钮");
    }]];
    [self presentViewController:alertController animated:YES completion:nil];

}

/**
 *  设备离开指定区域
 *
 *  @param manager <#manager description#>
 *  @param region  <#region description#>
 */
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"我出去了");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"区域检测提示" message:@"您已经离开亚信研发大厦!"preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了确定按钮");
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  定位失败调用
 *
 *  @param manager <#manager description#>
 *  @param error   <#error description#>
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败: %@",error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning  %s", __FUNCTION__);
}

@end
