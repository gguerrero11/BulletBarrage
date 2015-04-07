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

@import SceneKit;

static const NSInteger handicap = 1;

;

@interface MapViewController () <PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate>
{
    CMMotionManager *_motionManager;
}

@property (nonatomic,strong) CLLocation *myLocation;
@property (nonatomic,strong) MKMapCamera *targetCamera;
@property (strong, nonatomic) UIButton *fireButton;
@property (nonatomic,strong) MKPolyline *polyline;
@property (nonatomic, strong) UILabel *pitchLabelData;

// SceneKit Properties
@property (strong, nonatomic) SCNView *sceneView;
@property (nonatomic, strong) SCNNode *cubeNode;
@property (nonatomic, strong) SCNBox *cube;
@property (nonatomic, strong) SCNBox *ground;
@property (nonatomic, strong) SCNNode *cameraNode;
@property (nonatomic, strong) SCNNode *cameraHeadingRotationNode;
@property (nonatomic, strong) SCNNode *cameraPitchRotationNode;
@property (nonatomic, strong) SCNNode *cameraTargetNode;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    [self setUpMotionManager];
    [self setUpLocationManagerAndHeading];
    [self showMainMapView];
    [UserController queryUsersNearCurrentUser:self.locationManager.location.coordinate withinMileRadius:10];
    [self setupSceneKitView];
    [self setUpDataView];
    
    // Create Dummy Data
    CLLocation *dummyLocale1 = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(40.764, -111.896)
                                                             altitude:0 horizontalAccuracy:25
                                                     verticalAccuracy:25
                                                            timestamp:[NSDate date]];
    
    CLLocation *dummyLocale2 = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(40.8, -111.9)
                                                             altitude:0 horizontalAccuracy:25
                                                     verticalAccuracy:25
                                                            timestamp:[NSDate date]];
    
    Target *testTarget1 = [[Target alloc]initWithTargetNumber:@"1" location:dummyLocale1 fromUserLocation:self.myLocation];
    Target *testTarget2 = [[Target alloc]initWithTargetNumber:@"2" location:dummyLocale2 fromUserLocation:self.myLocation];
    [self.mapView addAnnotation:testTarget1];
    [self.mapView addAnnotation:testTarget2];
    
    self.targetCamera = [MKMapCamera cameraLookingAtCenterCoordinate:testTarget1.coordinate fromEyeCoordinate:self.myLocation.coordinate eyeAltitude:10];
    
    // Set this in an array for all headings of targets
    NSLog(@"TARGET %f", self.targetCamera.heading);
    
}

- (void) setUpMotionManager {
    _motionManager = [CMMotionManager new];
    if (_motionManager.isGyroAvailable) {
        //tell maanger to start pulling gyroscope info
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            // attitude what its 3d orientation is (pitch, roll, yaw)
            CMAttitude *attitude = motion.attitude;
            //            float offsetX = motion.attitude.roll * self.view.frame.size.width;
            //            float offsetY = motion.attitude.pitch * self.view.frame.size.height;
            self.pitchLabelData.text = [NSString stringWithFormat:@"%.1f",[self convertToDegrees:attitude.pitch]];
            
            // Set pitch limit for map camera
            //            if ([self convertToDegrees:attitude.pitch] > 75){
            //                self.mapView.camera.pitch = 75;
            //            } else {
            //            self.mapView.camera.pitch = [self convertToDegrees:attitude.pitch];
            //            }
            
            
        }];
        
    }
}

- (void)setUpLocationManagerAndHeading {
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

- (void)showMainMapView {
    
    // create scroll view
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:scrollView];
    
    // attach the mapview to the scroll view so we can move the center for the map visually lower on the screen
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 950)];
    self.mapView.backgroundColor = [UIColor redColor];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.delegate = self;
    self.mapView.rotateEnabled = NO;
    self.mapView.scrollEnabled = NO;
    self.mapView.zoomEnabled = NO;
    self.mapView.showsPointsOfInterest = NO;
    self.mapView.showsBuildings = NO;
    self.mapView.showsUserLocation = YES; // Must be YES in order for the MKMapView protocol to fire.
    //[self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    [scrollView addSubview:self.mapView];
    
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.14, 0.14);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.myLocation.coordinate, span);
    
    [self.mapView setRegion:region animated:YES];
}

#pragma mark SceneKit methods
- (void)setupSceneKitView {
    // Init the scene and default lighting
    self.sceneView = [[SCNView alloc]initWithFrame:CGRectMake(0,153, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height/2)];
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
    self.cameraHeadingRotationNode = [SCNNode node];
    self.cameraPitchRotationNode = [SCNNode node];
    
    // Setup heading rotation node
    self.cameraHeadingRotationNode.position = SCNVector3Make(0, 0, 0);
    [self.cameraHeadingRotationNode addChildNode: self.cameraPitchRotationNode];
    
    // setup pitch rotation node
    [self.cameraPitchRotationNode addChildNode:self.cameraNode];
    
    // Setup camera node
    self.cameraNode.position = SCNVector3Make(0, 5, 0);
    self.cameraNode.rotation = SCNVector4Make(1, 0, 0, 270 * (M_PI / 180));
    self.cameraNode.camera = camera;
    
    [scene.rootNode addChildNode:self.cameraHeadingRotationNode];
    
    // Create cube
    self.cube = [SCNBox boxWithWidth:.1 height:.1 length:.1 chamferRadius:.005];
    self.cube.firstMaterial.diffuse.contents = [UIColor colorWithRed:0.149 green:0.604 blue:0.859 alpha:1.000];
    
    // Create ground
    self.ground = [SCNBox boxWithWidth:.24 height:0 length:.24 chamferRadius:0];
    self.ground.firstMaterial.diffuse.contents = [UIColor brownColor];
    
    //SCNFloor use later
    
    
    SCNNode *cubeNode = [SCNNode nodeWithGeometry:self.cube];
    cubeNode.position = SCNVector3Make(0, .05, 0);
    
    SCNNode *groundNode = [SCNNode nodeWithGeometry:self.ground];
    
    [scene.rootNode addChildNode:cubeNode];
    //[scene.rootNode addChildNode:groundNode];
    self.cubeNode = cubeNode;
    
    // Add scene to SceneView
    self.sceneView.scene = scene;
    [self.view addSubview:self.sceneView];
    
    
}

- (void) setUpDataView {
    
    // Set up grey box
    double widthOfStatView = self.view.frame.size.width *0.3;
    double heightOfStatView = self.view.frame.size.height *0.3;
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
    self.fireButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 40)];
    [self.fireButton setTitle:@"Fire!" forState:UIControlStateNormal];
    [self.fireButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.fireButton addTarget:self action:@selector(fireButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.fireButton];
    
    
    
}

- (double) convertToDegrees:(double)pitch {
    return pitch * 60;
}

- (void)fireButtonPressed:(id)sender {
    

    
    double distanceOfProjectile = 0.005;
    CLLocationDegrees newLongitude = self.myLocation.coordinate.longitude + distanceOfProjectile;

    CLLocation *hitLocation = [[CLLocation alloc]initWithLatitude:self.myLocation.coordinate.latitude longitude:newLongitude];
    
    Target *hitTarget = [[Target alloc]initWithTargetNumber:@"Hit position" location:hitLocation fromUserLocation:self.myLocation];
    [self.mapView addAnnotation:hitTarget];
    
    
    
    //NSLog(@"%f", self.mapView.camera.heading);
    //NSLog(@"TARGET %f",targetCamera.heading);
    if ( self.mapView.camera.heading > self.targetCamera.heading - handicap &&
        self.mapView.camera.heading < self.targetCamera.heading + handicap) {
        
        NSLog(@"BOOM! HIT!");
    } else {
        NSLog(@"You missed! ");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading.headingAccuracy < 0)
        return;
    
    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);
    // Heading rotation
    //    self.cameraHeadingRotationNode.eulerAngles = SCNVector3Make(self.mapView.camera.pitch, 0, theHeading * -(M_PI/180));
    //         self.cameraHeadingRotationNode.eulerAngles = SCNVector3Make(0, 0, theHeading * -(M_PI/180));
    //         self.cameraTargetNode.eulerAngles = SCNVector3Make(self.mapView.camera.pitch * (M_PI/180), 0, 0);
    
    self.cameraHeadingRotationNode.rotation = SCNVector4Make(0, 1, 0, theHeading * -(M_PI/180));
    self.cameraPitchRotationNode.rotation = SCNVector4Make(1, 0, 0, (self.mapView.camera.pitch) * (M_PI/180) );
    self.cameraNode.position = SCNVector3Make(0, (self.mapView.camera.altitude/60)/17 + 4 ,0);
    
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
    
    self.mapView.camera.heading = theHeading;
    self.mapView.camera.altitude = 93;
    self.mapView.camera.pitch = 78;

    
    //NSLog(@"%f", self.mapView.camera.heading);
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}



@end
