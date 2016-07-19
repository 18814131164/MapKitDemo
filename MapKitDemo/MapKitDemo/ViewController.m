//
//  ViewController.m
//  MapKitDemo
//
//  Created by 众网合一 on 16/7/19.
//  Copyright © 2016年 GdZwhy. All rights reserved.
//
//  MapKit框架的基本使用

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<MKMapViewDelegate>
 
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *lm;

@end

@implementation ViewController
 
- (CLLocationManager *)lm
{
    if (!_lm) {
        _lm = [[CLLocationManager alloc]init];
        [_lm requestAlwaysAuthorization];
    }
    return _lm;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 如果不使用代码实例化，不会自动导入MapKit框架
//    MKMapView *mapView = [MKMapView new];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self lm];
    
//    MKMapTypeStandard = 0,
//    MKMapTypeSatellite,
//    MKMapTypeHybrid,
//    MKMapTypeSatelliteFlyover NS_ENUM_AVAILABLE(10_11, 9_0),
//    MKMapTypeHybridFlyover NS_ENUM_AVAILABLE(10_11, 9_0),
    // 设置地图类型
//    self.mapView.mapType = MKMapTypeHybridFlyover;
    // 设置缩放
//    self.mapView.zoomEnabled = NO;
    // 设置指南针
    self.mapView.showsCompass = YES;
//    self.mapView.showsScale = YES;
    // 设置用户位置
    self.mapView.showsUserLocation = YES;
    
    
//    MKUserTrackingModeNone = 0, // the user's location is not followed
//    MKUserTrackingModeFollow, // the map follows the user's location
//    MKUserTrackingModeFollowWithHeading __TVOS_PROHIBITED, // the map follows the user's location and heading

    // 跟踪用户位置
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
}

#pragma mark - MKMapViewDelegate

// 更新到位置
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    /**
        MKUserLocation (大头针模型)
     
     */
    userLocation.title = @"众网合一";
    userLocation.subtitle = @"保利中辰";
    
    // 设置地图显示中心
    [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.001, 0.001);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.location.coordinate, span);
 
    
    // 设置地图显示区域
    [self.mapView setRegion:region animated:YES];
}

// 区域改变时调用
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{

    NSLog(@"%f-----%f",mapView.region.span.latitudeDelta,mapView.region.span.longitudeDelta);
}


@end
