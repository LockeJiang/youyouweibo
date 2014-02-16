//
//  NearbyStatusViewController.h
//  zjtSinaWeiboClient
//
//  Created by Jiang Jian on 14-2-15.
//
//

#import "StatusViewContrillerBase.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@protocol NearbyStatusViewControllerDelegate <NSObject>

@end

@interface NearbyStatusViewController: StatusViewContrillerBase<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    
    CLLocationCoordinate2D _coordinate;
    
    id<NearbyStatusViewControllerDelegate> _delegate;
}

@property (nonatomic,retain)CLLocationManager *locationManager;
@property (nonatomic,assign)CLLocationCoordinate2D coordinate;
@property (nonatomic,assign)id<NearbyStatusViewControllerDelegate> delegate;

@end