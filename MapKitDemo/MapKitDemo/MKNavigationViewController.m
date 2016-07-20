//
//  MKNavigationViewController.m
//  MapKitDemo
//
//  Created by 众网合一 on 16/7/19.
//  Copyright © 2016年 GdZwhy. All rights reserved.
//
//  利用系统app导航_3d视角

#import "MKNavigationViewController.h"
#import <MapKit/MapKit.h>

@interface MKNavigationViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic , strong) CLGeocoder *geoC;

@end

@implementation MKNavigationViewController

- (CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc]init];
    }
    return _geoC;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    // 3D视角
//  MKMapCamera *camer = [MKMapCamera cameraLookingAtCenterCoordinate:(CLLocationCoordinate2DMake(23.132931, 113.375924)) fromEyeCoordinate:(CLLocationCoordinate2DMake(23.135921, 113.375924)) eyeAltitude:10];  
//    self.mapView.camera = camer;
    
    // 地图快照截图
    MKMapSnapshotOptions *option = [[MKMapSnapshotOptions alloc]init];
    
    // 针对地图
    option.region = self.mapView.region;
    option.showsBuildings = YES;
    
    // 输出图片
    option.size = CGSizeMake(1000, 2000);
    option.scale = [UIScreen mainScreen].scale;
    
 
    
    MKMapSnapshotter *snap = [[MKMapSnapshotter alloc]initWithOptions:option];
    
    [snap startWithCompletionHandler:^(MKMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        
        if (error == nil) {
            
            UIImage *image = snapshot.image;
            
            NSData *data = UIImagePNGRepresentation(image);
            
            [data writeToFile:@"/Users/zhongwangheyi/Desktop/map.png" atomically:YES];
            
        }else{
            
            NSLog(@"%@",error);
        }
 
    }];
}

- (void)beginNav{
    
    [self.geoC geocodeAddressString:@"广州" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        // 广州地标
        CLPlacemark *gzP = [placemarks firstObject];
        
        
        [self.geoC geocodeAddressString:@"上海" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            // 上海地标
            CLPlacemark *shP = [placemarks firstObject];
            
            [self beginNavWithBpl:gzP andEndP:shP];
        }];
    }];
}

- (void)beginNavWithBpl:(CLPlacemark *)beginP andEndP:(CLPlacemark *)endP
{
    // 创建开始的地图项
    CLPlacemark *clPB = beginP;
    MKPlacemark *mkPB = [[MKPlacemark alloc]initWithPlacemark:clPB];
    MKMapItem *beginI = [[MKMapItem alloc]initWithPlacemark:mkPB];
    
    // 创建结束的地图项
    CLPlacemark *clP = endP;
    MKPlacemark *mkP = [[MKPlacemark alloc]initWithPlacemark:clP];
    MKMapItem *endI = [[MKMapItem alloc]initWithPlacemark:mkP];
    
    // 地图项数组
    NSArray *items = @[beginI,endI];
    
    // 启动字典
    NSDictionary *dic = @{
                          // 导航方式
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          // 地图类型
                          MKLaunchOptionsMapTypeKey : @(MKMapTypeHybrid),
                          // 是否显示交通
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };
    
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}
 
@end
