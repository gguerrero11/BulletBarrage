//
//  ViewController.m
//  Snipey
//
//  Created by Gabriel Guerrero on 3/23/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "MapViewController.h"
#import "Target.h"
#import <CoreMotion/CoreMotion.h>
#import "CustomLoginViewController.h"
#import "CustomSignUpViewController.h"
#import <Parse/Parse.h>
#import "UserController.h"

#import "Weapon.h"
#import "WeaponController.h"
#import "UserController.h"

@import SceneKit;

////////////////////////////////////////////////////////// POLYLines
@interface GMSPolyline (length)

@property(nonatomic, readonly) double length;

@end

@implementation GMSPolyline (length)

- (double)length {
    GMSLengthKind kind = [self geodesic] ? kGMSLengthGeodesic : kGMSLengthRhumb;
    return [[self path] lengthOfKind:kind];
}

@end
//////////////////////////////////////////////////////////


//static const NSInteger handicap = 1;
static const NSInteger gravityStatic = 9.8;

// Polyline Static
static bool kAnimate = true;

@interface MapViewController () <PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate>
{
    CMMotionManager *_motionManager;
    GMSMapView *gmMapView;
    GMSCameraPosition *gmCamera;
    
    // Polyline properties
    NSArray *_styles;
    NSArray *_lengths;
    NSArray *_polys;
    double _pos, _step;
    
}

@property (nonatomic,strong) CLLocation *myLocation;
@property (nonatomic,strong) MKMapCamera *targetCamera;
@property (strong, nonatomic) UIButton *fireButton;
@property (nonatomic,strong) MKPolyline *polyline;
@property (nonatomic, strong) UILabel *pitchLabelData;

// SceneKit Properties
@property (strong, nonatomic) SCNView *sceneView;
@property (nonatomic, strong) SCNNode *pyramidNode;
@property (nonatomic, strong) SCNPyramid *pyramid;
@property (nonatomic, strong) SCNBox *ground;
@property (nonatomic, strong) SCNNode *cameraNode;
@property (nonatomic, strong) SCNNode *cameraSceneKitHeadingRotationNode;
@property (nonatomic, strong) SCNNode *cameraPitchRotationNode;
@property (nonatomic, strong) SCNNode *cameraTargetNode;

// GMS Map
@property (nonatomic,assign) NSInteger zoomSelection;
@property (nonatomic,assign) double pitchWithLimit;
@property (nonatomic,strong) NSMutableArray *arrayOfCraters;
@property (nonatomic,strong) CLLocation *hitLocation;

// CMDevice motion
@property (nonatomic,strong) CMAttitude *attitude;
@property (nonatomic) double deviceYaw;

@end

@implementation MapViewController


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        CustomLoginViewController *logInViewController = [[CustomLoginViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        
        // Create the sign up view controller
        CustomSignUpViewController *signUpViewController = [[CustomSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}


- (void) viewDidLoad {
    [super viewDidLoad];
    
    
    [UserController setWeaponForUser:cannon];
    
    [self setUpMotionManager];
    [self setUpLocationManagerAndHeading];
    [self showMainMapView];
    [UserController queryUsersNearCurrentUser:self.locationManager.location.coordinate withinMileRadius:10];
    //[self setupSceneKitView];
    [self setUpDataViewFireButton];
    [self setUpPOVButton];
    
    [self createDummyTargets];
    
    self.arrayOfCraters = [NSMutableArray new];
}

- (void) createDummyTargets {
    // Create Dummy Data
    CLLocation *dummyLocale1 = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(40.764, -111.896)
                                                             altitude:0 horizontalAccuracy:25
                                                     verticalAccuracy:25
                                                            timestamp:[NSDate date]];
    
    CLLocation *dummyLocale2 = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(40.8, -111.9)
                                                             altitude:0 horizontalAccuracy:25
                                                     verticalAccuracy:25
                                                            timestamp:[NSDate date]];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = dummyLocale1.coordinate;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = gmMapView;
    
    GMSMarker *marker2 = [[GMSMarker alloc] init];
    marker2.position = dummyLocale2.coordinate;
    marker2.appearAnimation = kGMSMarkerAnimationPop;
    marker2.map = gmMapView;
    

}

- (void) setUpMotionManager {
    _motionManager = [CMMotionManager new];
    
    if (_motionManager.isGyroAvailable) {
        //tell maanger to start pulling gyroscope info
        
        [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            
            // attitude what its 3d orientation is (pitch, roll, yaw)
            self.attitude = motion.attitude;
            self.deviceYaw = motion.attitude.yaw + 1.55;
            
            self.pitchLabelData.text = [NSString stringWithFormat:@"%.1f",[self convertToDegrees:self.pitchWithLimit]];
            
            [gmMapView animateToBearing:-[self convertToDegrees:self.deviceYaw]];
            [gmMapView animateToViewingAngle:45];
            //[gmMapView animateToLocation:self.myLocation.coordinate];
            // NSLog(@"%f", gmMapView.camera.viewingAngle);
            
            // Set pitch limit for map camera
            if (self.attitude.pitch <= 0){
                self.pitchWithLimit = 0;
            } else {
                self.pitchWithLimit = self.attitude.pitch;
            }
            self.cameraPitchRotationNode.rotation = SCNVector4Make(1, 0, 0, (gmMapView.camera.viewingAngle) * (M_PI/180) );
            
            self.cameraNode.position = SCNVector3Make(0, -((double)gmMapView.camera.zoom - 22) * 5  ,0);
            //NSLog(@"%f", -((double)gmMapView.camera.zoom - 22) * 5);
            
            // NSLog(@"%f", [self convertToDegrees:attitude.yaw]);
            
            //            // Set pitch limit for map camera
            //                        if ([self convertToDegrees:self.attitude.pitch] > 75){
            //                            self.mapView.camera.pitch = 75;
            //                        } else {
            //                        self.mapView.camera.pitch = [self convertToDegrees:self.attitude.pitch];
            //                        }
            
            
            
        }];
    }
}

- (void) setUpLocationManagerAndHeading {
    if (!self.locationManager) {
        
        // Retain the object in a property.
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
    }
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
        
    }
    
    // Start location services to get the true heading.
    self.locationManager.distanceFilter = 1000;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager startUpdatingLocation];
    
    // Start heading updates.
    if([CLLocationManager headingAvailable] == YES){
        NSLog(@"Heading is available");
        self.locationManager.headingFilter = 0.001;
        [self.locationManager startUpdatingHeading];
    } else {
        NSLog(@"Heading isn’t available");
    }
    
    self.myLocation = self.locationManager.location;
}

- (void) showMainMapView {
    
    
    gmCamera = [GMSCameraPosition cameraWithTarget:self.myLocation.coordinate zoom:15 bearing:32 viewingAngle:17];
    //    gmCamera = [GMSCameraPosition cameraWithLatitude:40.11 longitude:-111.01 zoom:6];
    
    gmMapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 250) camera:gmCamera];
    gmMapView.myLocationEnabled = YES;
    gmMapView.settings.scrollGestures = NO;
    gmMapView.delegate = self;
    
    [self.view addSubview:gmMapView];
    
    GMSMarker *marker = [GMSMarker new];
    marker.position = CLLocationCoordinate2DMake(40.12, -111.1);
    marker.title = @"Target";
    marker.snippet = @"HIT";
    marker.map = gmMapView;
    
    // Apple Maps
    //    // create scroll view
    //    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    //    [self.view addSubview:scrollView];
    //
    //    // attach the mapview to the scroll view so we can move the center for the map visually lower on the screen
    //    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 950)];
    //    self.mapView.backgroundColor = [UIColor redColor];
    //    self.mapView.mapType = MKMapTypeStandard;
    //    self.mapView.delegate = self;
    //    self.mapView.rotateEnabled = NO;
    //    self.mapView.scrollEnabled = NO;
    //    self.mapView.zoomEnabled = NO;
    //    self.mapView.showsPointsOfInterest = NO;
    //    self.mapView.showsBuildings = NO;
    //    self.mapView.showsUserLocation = YES; // Must be YES in order for the MKMapView protocol to fire.
    //    //[self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    //    [scrollView addSubview:self.mapView];
    //
    //
    //    MKCoordinateSpan span = MKCoordinateSpanMake(0.14, 0.14);
    //    MKCoordinateRegion region = MKCoordinateRegionMake(self.myLocation.coordinate, span);
    //
    //    [self.mapView setRegion:region animated:YES];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {

    return YES;
}

#pragma mark SceneKit methods
- (void) setupSceneKitView {
    // Init the scene and default lighting
    self.sceneView = [[SCNView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height + 250)];
    self.sceneView.backgroundColor = [UIColor clearColor];
    self.sceneView.userInteractionEnabled = NO;
    self.sceneView.autoenablesDefaultLighting = YES;
    
    //create a scene
    SCNScene *scene = [SCNScene scene];
    
    //self.sceneView.allowsCameraControl = true;
    
    SCNCamera *camera = [SCNCamera camera];
    camera.xFov = 10;
    camera.yFov = 10;
    
    // Init our nodes
    self.cameraTargetNode = [SCNNode new];
    self.cameraNode = [SCNNode node];
    self.cameraSceneKitHeadingRotationNode = [SCNNode node];
    self.cameraPitchRotationNode = [SCNNode node];
    
    // Setup heading rotation node
    self.cameraSceneKitHeadingRotationNode.position = SCNVector3Make(0, 0, 0);
    [self.cameraSceneKitHeadingRotationNode addChildNode: self.cameraPitchRotationNode];
    
    // setup pitch rotation node
    [self.cameraPitchRotationNode addChildNode:self.cameraNode];
    
    // Setup camera node
    self.cameraNode.position = SCNVector3Make(0, 5, 0);
    self.cameraNode.rotation = SCNVector4Make(1, 0, 0, 270 * (M_PI / 180));
    self.cameraNode.camera = camera;
    
    [scene.rootNode addChildNode:self.cameraSceneKitHeadingRotationNode];
    
    // Create cube
    self.pyramid = [SCNPyramid pyramidWithWidth:.2 height:.5 length:.5];
    self.pyramid.firstMaterial.diffuse.contents = [UIColor colorWithRed:0.149 green:0.604 blue:0.859 alpha:1.000];
    
    // Create ground
    self.ground = [SCNBox boxWithWidth:.24 height:0 length:.24 chamferRadius:0];
    self.ground.firstMaterial.diffuse.contents = [UIColor brownColor];
    
    //SCNFloor use later
    
    SCNNode *pyramidNode = [SCNNode nodeWithGeometry:self.pyramid];
    pyramidNode.position = SCNVector3Make(0, .03, 0);
    pyramidNode.eulerAngles = SCNVector3Make(-1.54, 0, 1.5);
    
    SCNNode *groundNode = [SCNNode nodeWithGeometry:self.ground];
    
    [scene.rootNode addChildNode:pyramidNode];
    //[scene.rootNode addChildNode:groundNode];
    self.pyramidNode = pyramidNode;
    
    // Add scene to SceneView
    self.sceneView.scene = scene;
    [self.view addSubview:self.sceneView];
    
    
}

- (void) setUpDataViewFireButton {
    
    // Set up grey box
    double widthOfStatView = self.view.frame.size.width *0.3;
    double heightOfStatView = self.view.frame.size.height *0.1;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(30, self.view.frame.size.height - (60 + heightOfStatView), widthOfStatView, heightOfStatView)];
    view.backgroundColor = [UIColor grayColor];
    view.alpha = .65;
    [self.view addSubview:view];
    
    // Set up Pitch Label
    UILabel *pitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 50)];
    [view addSubview:pitchLabel];
    pitchLabel.textAlignment = NSTextAlignmentCenter;
    pitchLabel.text = @"Pitch";
    pitchLabel.textColor = [UIColor blackColor];
    
    // Set up Pitch Label Data
    self.pitchLabelData = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, view.frame.size.width, 50)];
    [view addSubview:self.pitchLabelData];
    
    self.pitchLabelData.textAlignment = NSTextAlignmentCenter;
    self.pitchLabelData.textColor = [UIColor blackColor];
    
    // Set up fire button
    self.fireButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 30, self.view.frame.size.height - 130, 80, 80)];
    self.fireButton.layer.cornerRadius = 40;
    self.fireButton.backgroundColor = [UIColor redColor];
    [self.fireButton setTitle:@"Fire!" forState:UIControlStateNormal];
    [self.fireButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.fireButton addTarget:self action:@selector(fireButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.fireButton];
    
}

- (void) setUpPOVButton {
    UIButton *zoom = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    zoom.layer.cornerRadius = 25;
    zoom.frame = CGRectMake(self.view.frame.size.width - 65, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - 80, 50, 50);
    UIImageView *homeIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"homelocation"]];
    homeIcon.frame = CGRectMake(zoom.frame.size.width / 2 - zoom.frame.size.width * 0.75 / 2, zoom.frame.size.height / 2 - zoom.frame.size.height * 0.75 / 2 , zoom.frame.size.width * 0.75, zoom.frame.size.height * 0.75);
    [zoom addSubview:homeIcon];
    zoom.tintColor = [UIColor whiteColor];
    zoom.backgroundColor = [UIColor blueColor];
    [self.view addSubview:zoom];
    [zoom addTarget:self action:@selector(changeZoom) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) changeZoom {
    
    switch (self.zoomSelection) {
        case 0:
            [gmMapView animateToZoom:18];
            self.zoomSelection = 1;
            break;
        case 1:
            [gmMapView animateToZoom:17];
            self.zoomSelection = 2;
            break;
        case 2:
            [gmMapView animateToZoom:14];
            self.zoomSelection = 0;
            break;
    }
}

#pragma mark Firing/Projectile methods

- (double) convertToDegrees:(double)pitch {
    return pitch * (180/M_PI);
}

- (double) calculateDistanceFromUserWeapon {
    Weapon *currentWeapon = [Weapon new];
    NSNumber *velocityOfProjectile = currentWeapon.velocity;
    
    double range = ( powl([velocityOfProjectile doubleValue], 2 ) * sinl(2 * self.pitchWithLimit) ) / gravityStatic;
    return range;
}

- (CLLocationCoordinate2D) calculateHitLocation {
    
    // using laws of cosine/sine to calculate a / b sides of a right triangle based on the hypotenuse (distance of projectile)
    // - 1.5 is a hardcoded offset from "true north". North was intially 90 degrees to the left.
    double meterOffsetLongitude = [self calculateDistanceFromUserWeapon] * sin(-self.deviceYaw);
    double meterOffsetLatitude = [self calculateDistanceFromUserWeapon] * cos(-self.deviceYaw);
    
    // convert meter offsets to degrees, ("dirty caluclation" of 111,111m = 1 degree)
    double degreeOffsetLongitude = meterOffsetLongitude / 111111;
    double degreeOffsetLatitude = meterOffsetLatitude / 111111;
    
    //NSLog(@"%f", self.attitude.yaw);
    
    return CLLocationCoordinate2DMake(self.myLocation.coordinate.latitude + degreeOffsetLatitude,
                                      self.myLocation.coordinate.longitude + degreeOffsetLongitude);
}

- (void) fireButtonPressed:(id)sender {
    //    [gmMapView clear];
    
    self.hitLocation = [[CLLocation alloc]initWithLatitude:[self calculateHitLocation].latitude
                                                 longitude:[self calculateHitLocation].longitude];
    // Create crater coordinates
    // Sets coordinates for the opposite side corners for the overlay (crater)
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(self.hitLocation.coordinate.latitude + 100.0/111111.0, self.hitLocation.coordinate.longitude + 100.0/111111.0);
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(self.hitLocation.coordinate.latitude - 100.0/111111.0, self.hitLocation.coordinate.longitude - 100.0/111111.0);
    
    GMSCoordinateBounds *overlayBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:southWest
                                                                              coordinate:northEast];
    GMSGroundOverlay *groundOverlay = [GMSGroundOverlay groundOverlayWithBounds:overlayBounds
                                                                           icon:[UIImage imageNamed:@"craterBigSquare"]];
    groundOverlay.map = gmMapView;
    [self drawTrajectoryLineToLocation:self.hitLocation];
 //   [self setUpPolyineColors];
    
    [self performSelector:@selector(removeGMOverlay:) withObject:groundOverlay afterDelay:3];
}

- (void)removeGMOverlay:(GMSGroundOverlay *)overlay {
    overlay.map = nil;
    overlay = nil;
}

#pragma mark Polyline methods

- (void) drawTrajectoryLineToLocation:(CLLocation *)destination {
    GMSMutablePath *path = [GMSMutablePath path];
    [path addCoordinate:self.myLocation.coordinate];
    [path addCoordinate:destination.coordinate];
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor blueColor];
    polyline.strokeWidth = 5.f;
    polyline.map = gmMapView;
    [self performSelector:@selector(removeGMSPolyline:) withObject:polyline afterDelay:3];
}

- (void)removeGMSPolyline:(GMSPolyline *)polyline {
    polyline.map = nil;
    polyline = nil;
}

- (void)tick {
    for (GMSPolyline *poly in _polys) {
        poly.spans = GMSStyleSpansOffset(poly.path, _styles, _lengths, kGMSLengthGeodesic, _pos);
    }
    _pos -= _step;
    if (kAnimate) {
        __weak id weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC / 60),
                       dispatch_get_main_queue(),
                       ^{ [weakSelf tick]; });
    }
}

- (void)initLines {
    if (!_polys) {
        NSMutableArray *polys = [NSMutableArray array];
        GMSMutablePath *path = [GMSMutablePath path];
        [path addCoordinate:self.myLocation.coordinate];
        [path addCoordinate:self.hitLocation.coordinate];
        path = [path pathOffsetByLatitude:-30 longitude:0];
        _lengths = @[@([path lengthOfKind:kGMSLengthGeodesic] / 2)];
        for (int i = 0; i < 1; ++i) {
            GMSPolyline *poly = [[GMSPolyline alloc] init];
            poly.path = [path pathOffsetByLatitude:(i * 1.5) longitude:0];
            poly.strokeWidth = 8;
            poly.geodesic = YES;
            poly.map = gmMapView;
            [polys addObject:poly];
        }
        _polys = polys;
    }
}

- (void) setUpPolyineColors {
    
    CGFloat alpha = 1;
    UIColor *red = [UIColor colorWithRed:1 green:0 blue: 0 alpha:alpha];
    UIColor *redTransp = [UIColor colorWithRed:1 green:0 blue: 0 alpha:0];
    GMSStrokeStyle *grad2 = [GMSStrokeStyle gradientFromColor:redTransp toColor:red];
    _styles = @[
                grad2,
                [GMSStrokeStyle solidColor:[UIColor colorWithWhite:0 alpha:0]],
                ];
    _step = 50000;
    [self initLines];
    [self tick];
}




- (void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading.headingAccuracy < 0) return;
    
    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);
    //self.cameraSceneKitHeadingRotationNode.rotation = SCNVector4Make(0, 1, 0, theHeading * (M_PI/180));
    self.pyramidNode.eulerAngles = SCNVector3Make(-1.54, - self.pitchWithLimit , 1.5 );
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.mapView.showsUserLocation = NO;
    CLLocation *lastLocation = [locations lastObject];
    
    CLLocationAccuracy accuracy = [lastLocation horizontalAccuracy];
    //NSLog(@"Received location %@ with accuracy %f", lastLocation, accuracy);
    
    if(accuracy < 10.0) {
        
        //self.myLocation = lastLocation;
        //[mapView setCamera:mapCamera animated:YES];
        
        
        [self.locationManager stopUpdatingLocation];
    }
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
