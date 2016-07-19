//
//  MKAnnotationPin.h
//  MapKitDemo
//
//  Created by 众网合一 on 16/7/19.
//  Copyright © 2016年 GdZwhy. All rights reserved.
//
//  自定义大头针

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MKAnnotationPin : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

/** 类型 */
@property (nonatomic, assign) NSInteger type;

@end
