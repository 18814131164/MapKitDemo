  //
//  MapKitAPinViewController.m
//  MapKitDemo
//
//  Created by 众网合一 on 16/7/19.
//  Copyright © 2016年 GdZwhy. All rights reserved.
//
//  1.大头针的使用
//  2.自定义大头针

#import "MapKitAPinViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MKAnnotationPin.h"

@interface MapKitAPinViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) CLGeocoder *geoC;

@end

@implementation MapKitAPinViewController

- (CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc]init];
    }
    return _geoC;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //1.获取当前触摸点
    CGPoint point = [[touches anyObject]locationInView:self.mapView];
    //2.转换成经纬度
    CLLocationCoordinate2D pt = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];

    //3.添加大头针
    [self addAnnotationWithPT:pt];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 移除大头针（模型）
//    [self.mapView removeAnnotations:self.mapView.annotations];

}

- (void)addAnnotationWithPT:(CLLocationCoordinate2D)pt{
    
    __block MKAnnotationPin *anno = [[MKAnnotationPin alloc]init];
    anno.coordinate = pt;
    anno.title = @"众网合一";
    anno.subtitle = @"保利中辰";
    anno.type = arc4random_uniform(5);
    [self.mapView addAnnotation:anno];
    
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:pt.latitude longitude:pt.longitude];
    
    [self.geoC reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *pl = [placemarks firstObject];
        anno.title = pl.locality;
        anno.subtitle = pl.thoroughfare;
        
    }];
}

// 当我们添加大头针模型时
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
//    MKAnnotationView可自定义图片
//    MKPinAnnotationView不可自定义图片
 
    static NSString *indentifier = @"indentifier";
    MKAnnotationView *pin = [mapView dequeueReusableAnnotationViewWithIdentifier:indentifier];
    
    if (pin == nil) {
        pin = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:indentifier];
    }
    
    pin.annotation = annotation;
    // 设置是否弹出标注
    pin.canShowCallout = YES;

    // 设置大头针图片(系统大头针无效)
    NSString *imageName = [NSString stringWithFormat:@"category_%zd",[(MKAnnotationPin *)annotation type] + 1];
    pin.image = [UIImage imageNamed:imageName];
    // 设置大头针可拖拽
    pin.draggable = YES;
    
    pin.calloutOffset = CGPointMake(10, 15);
    
    // 设置左右视图
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    imageView.image = [UIImage imageNamed:@"htl"];
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    imageView1.image = [UIImage imageNamed:@"htl"];
    pin.leftCalloutAccessoryView = imageView;
    pin.rightCalloutAccessoryView = imageView1;
    
    
    
    pin.detailCalloutAccessoryView = [UISwitch new];
    
    return pin;
}

// 系统大头针
- (MKPinAnnotationView *)systemAnnoWithMapView:(MKMapView *)mapView andAnno:(id<MKAnnotation>)annotation{
    
    static NSString *indentifier = @"indentifier";
    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:indentifier];
    
    if (pin == nil) {
        pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:indentifier];
    }
    
    pin.annotation = annotation;
    // 设置是否弹出标注
    pin.canShowCallout = YES;
    // 设置大头针颜色
    pin.pinTintColor = [UIColor blackColor];
    // 从天而降
    pin.animatesDrop = YES;
    // 设置大头针图片(系统大头针无效)
    //    pin.image = [UIImage imageNamed:@"category_5"];
    // 设置大头针可拖拽
    pin.draggable = YES;
    
    return pin;
}

// 选中大头针
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"选中");
    NSLog(@"%@",view.annotation);
}

// 不选中
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"不选中");
}


@end
