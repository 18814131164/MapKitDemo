//
//  MKDrawNavigationViewController.m
//  MapKitDemo
//
//  Created by 众网合一 on 16/7/20.
//  Copyright © 2016年 GdZwhy. All rights reserved.
//

#import "MKDrawNavigationViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MKDrawNavigationViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic , strong) CLGeocoder *geoC;

@end

@implementation MKDrawNavigationViewController

- (CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc]init];
    }
    return _geoC;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.geoC geocodeAddressString:@"广州" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *gzP = [placemarks firstObject];
        
        [self.geoC geocodeAddressString:@"上海" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            CLPlacemark *shP = [placemarks firstObject];
            
            [self getRuuteWithBeginPL:gzP andEndPL:shP];
            
        }];
        
    }];

}


- (void)getRuuteWithBeginPL:(CLPlacemark *)beginP andEndPL:(CLPlacemark *)endPL
{
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:beginP.location.coordinate radius:10000];
    [self.mapView addOverlay:circle];
    
    
    MKCircle *circle2 = [MKCircle circleWithCenterCoordinate:endPL.location.coordinate radius:10000];
    [self.mapView addOverlay:circle2];
    
    
    
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    // 起点
    CLPlacemark *clP = beginP;
    MKPlacemark *mkP = [[MKPlacemark alloc]initWithPlacemark:clP];
    MKMapItem *sourceItem = [[MKMapItem alloc]initWithPlacemark:mkP];
    request.source = sourceItem;
    
    // 终点
    CLPlacemark *clP2 = endPL;
    MKPlacemark *mkP2 = [[MKPlacemark alloc]initWithPlacemark:clP2];
    MKMapItem *endItem = [[MKMapItem alloc]initWithPlacemark:mkP2];
    request.destination = endItem;
    
    MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
    
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        /**
         *  MKDirectionsResponse
            routes : 路线数组
         */
        /**
            MKRoute 
            name : 路线名称
            distance : 距离
            expectedTravelTime : 预期时间
            polyline : 折线（数据模型）
         */
        /**
            steps<MKRouteStep>
            instructions : 行走提示
         */
  
        [response.routes enumerateObjectsUsingBlock:^(MKRoute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"---- %@ ,----- %zd, ----- %f",obj.name,obj.expectedTravelTime,obj.distance);
           
            MKPolyline *polyline = obj.polyline;
            // 添加一个覆盖层数据模型
            [self.mapView addOverlay:polyline];
            
//            [obj.steps enumerateObjectsUsingBlock:^(MKRouteStep * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                NSLog(@"%@",obj.instructions);;
//            }];
        }];
    }];
}

/**
    获取对应的图层渲染
 */
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{

    if ([overlay isKindOfClass:[MKCircle class]]) {
        
        MKCircleRenderer *circleR = [[MKCircleRenderer alloc]initWithOverlay:overlay];
        circleR.fillColor = [UIColor cyanColor];
        circleR.alpha = 0.5;
        
        return circleR;
    } else {
        
        MKPolylineRenderer *render = [[MKPolylineRenderer alloc]initWithOverlay:overlay];
        // 设置线宽
        render.lineWidth = 5;
        render.strokeColor = [UIColor purpleColor];
        return render;

    }
 
}


@end
