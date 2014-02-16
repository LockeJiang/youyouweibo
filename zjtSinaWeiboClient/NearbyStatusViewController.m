//
//  NearbyStatusViewController.m
//  zjtSinaWeiboClient
//
//  Created by Jiang Jian on 14-2-15.
//
//

#import "NearbyStatusViewController.h"
#import "SHKActivityIndicator.h"

@interface NearbyStatusViewController ()

@end

@implementation NearbyStatusViewController

@synthesize locationManager = _locationManager;
@synthesize coordinate = _coordinate;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // _manager = [WeiBoMessageManager getInstance];
    }
    return self;
    NSLog(@"NearbyStatusVC: init");
}

- (void)dealloc
{
    self.locationManager = nil;
    [super dealloc];
     NSLog(@"NearbyStatusVC: dealloc");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"附近的微博";
    [defaultNotifCenter addObserver:self selector:@selector(didGetNearbyStatus:)    name:MMSinaGotNearbyStatuses   object:nil];
    
    //解决tableview被导航栏遮挡的问题
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
     NSLog(@"NearbyStatusVC: viewDidLoad:%i", statuesArr.count);
}

- (void)viewDidUnload
{
    [defaultNotifCenter removeObserver:self name:MMSinaGotNearbyStatuses object:nil];
    [super viewDidUnload];
     NSLog(@"NearbyStatusVC: viewDidUnload:%i", statuesArr.count);
}

-(void)viewDidAppear:(BOOL)animated
{
    if (self.statuesArr != nil) {
        return;
    }
    
    /*
    if (_locationManager) {
        _locationManager.delegate = nil;
        [_locationManager release];
        _locationManager = nil;
    }
     */
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetNearbyStatus:) name:MMSinaGotNearbyStatuses object:nil];
    
    [manager getNearbyStatuses:_locationManager.location.coordinate];
    [self.tableView reloadData];
    
    [[SHKActivityIndicator currentIndicator] displayActivity:@"正在定位..." inView:self.view];
    
    NSLog(@"NearbyStatusVC: viewDidAppear:%f,%f,statusArr: %i",_locationManager.location.coordinate.latitude,_locationManager.location.coordinate.longitude,statuesArr.count);
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (_locationManager) {
        [_locationManager stopUpdatingLocation];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



-(void)didGetNearbyStatus:(NSNotification*)sender
{
    [self stopLoading];
    [self doneLoadingTableViewData];
    
    [statuesArr removeAllObjects];
    self.statuesArr = sender.object;
    [self.tableView reloadData];
    [[SHKActivityIndicator currentIndicator] hide];
    //    [[ZJTStatusBarAlertWindow getInstance] hide];
    [self refreshVisibleCellsImages];
    
     NSLog(@"NearbyStatusVC: didGetNearbyStatus:%i", statuesArr.count);
}

#pragma mark - location Delegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位出错");
    [[SHKActivityIndicator currentIndicator] hide];
}

- (void)locationManager:(CLLocationManager *)managerr
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{

    [manager getNearbyStatuses:newLocation.coordinate];
    [_locationManager stopUpdatingLocation];
    
    // NSLog(@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
  
    //[_manager getNearbyStatuses:newLocation.coordinate];
    
    [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view];
    
     NSLog(@"NearbyStatusVC: didUpdateToLocation:%i", statuesArr.count);
}

@end
