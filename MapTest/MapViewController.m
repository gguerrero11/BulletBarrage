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

@import SceneKit;

static const NSInteger handicap = 1;
static const NSInteger pitchOffset = 30;

@interface MapViewController ()
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



@end

@implementation MapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpMotionManager];
    [self setUpLocationManagerAndHeading];
    [self showMainMapView];
    [self setUpDataView];
    [self setupSceneKitView];
    
    
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
    
    self.targetCamera = [MKMapCamera cameraLookingAtCenterCoordinate:testTarget2.coordinate fromEyeCoordinate:self.myLocation.coordinate eyeAltitude:10];
    
    // Set this in an array for all headings of targets
    //NSLog(@"TARGET %f",targetCamera.heading);
    
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
            
            //mapView.camera.pitch = [self convertToDegrees:attitude.pitch];
            
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
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.mapView];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.delegate = self;
    self.mapView.rotateEnabled = NO;
    self.mapView.scrollEnabled = NO;
    self.mapView.showsUserLocation = YES; // Must be YES in order for the MKMapView protocol to fire.
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.14, 0.14);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.myLocation.coordinate, span);
    
    [self.mapView setRegion:region animated:YES];
}

#pragma mark SceneKit methods
- (void)setupSceneKitView {
    self.sceneView = [[SCNView alloc]initWithFrame:self.view.frame];
    self.sceneView.backgroundColor = [UIColor clearColor];
    self.sceneView.userInteractionEnabled = NO;
    
    //create a scene
    SCNScene *scene = [SCNScene scene];
    
    //self.sceneView.allowsCameraControl = true;
    
    SCNCamera *camera = [SCNCamera camera];
    camera.xFov = 0;
    camera.yFov = 0;
    
    self.cameraNode = [SCNNode node];
    //self.cameraNode.camera = camera;
    //self.cameraNode.position = SCNVector3Make(0, 0, [self meterToAngstrom:self.mapView.camera.altitude]);
    self.cameraNode.position = SCNVector3Make(0, 20, 0);
    self.cameraNode.rotation = SCNVector4Make(1, 0, 0, 270 * (M_PI / 180));
    
    self.cameraHeadingRotationNode = [SCNNode node];
    [self.cameraHeadingRotationNode addChildNode:self.cameraPitchRotationNode];
    
    self.cameraPitchRotationNode = [SCNNode node];
    self.cameraPitchRotationNode.camera = camera;
    
    [self.cameraNode addChildNode:self.cameraHeadingRotationNode];
    
    [scene.rootNode addChildNode:self.cameraNode];
    
    // Create cube
    self.cube = [SCNBox boxWithWidth:1 height:1 length:1 chamferRadius:.2];
    self.cube.firstMaterial.diffuse.contents = [UIColor colorWithRed:0.149 green:0.604 blue:0.859 alpha:1.000];
    
    // Create ground
    self.ground = [SCNBox boxWithWidth:10 height:.1 length:10 chamferRadius:0];
    self.ground.firstMaterial.diffuse.contents = [UIColor brownColor];
    
    
    SCNNode *cubeNode = [SCNNode nodeWithGeometry:self.cube];
    //SCNNode *groundNode = [SCNNode nodeWithGeometry:self.ground];
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
    
    //NSLog(@"%f", self.mapView.camera.heading);
    //NSLog(@"TARGET %f",targetCamera.heading);
    if ( self.mapView.camera.heading > self.targetCamera.heading - handicap &&
        self.mapView.camera.heading < self.targetCamera.heading + handicap) {
        
        NSLog(@"BOOM! HIT!");
    } else {
        NSLog(@"You missed!");
    }
}




- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading.headingAccuracy < 0)
        return;
    
    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);
    
    self.cameraHeadingRotationNode.rotation = SCNVector4Make(0, 0, 1, theHeading * -(M_PI/180));
    self.cameraNode.position = SCNVector3Make(0, (self.mapView.camera.altitude/60) / 6, 0);
    //NSLog(@"%f", self.cameraNode.position.y);
    NSLog(@"%f", self.mapView.camera.altitude);
    
    //    NSLog(@"heading %f", newHeading.trueHeading);
    //   NSLog(@"True Heading %f", theHeading);
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    
    //self.mapView.camera.heading = theHeading;
    //self.mapView.camera.pitch = 77;
    //self.mapView.camera.altitude = 62;
    
    //    NSLog(@"Altitude %f", self.mapView.camera.altitude);
    //    NSLog(@"Pitch %f", self.mapView.camera.pitch);
    
    
    /*
     Altitude 62
     Pitch 77
     
     Alt 88
     Pitch 75
     
     Alt 135
     Pitch 72
     
     Alt 256
     Pitch 66
     
     Alt 674
     Pitch 58
     
     Alt 946
     Pitch 56
     
     */
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *lastLocation = [locations lastObject];
    
    CLLocationAccuracy accuracy = [lastLocation horizontalAccuracy];
    //NSLog(@"Received location %@ with accuracy %f", lastLocation, accuracy);
    
    if(accuracy < 10.0) {
        
        self.myLocation = lastLocation;
        //[mapView setCamera:mapCamera animated:YES];
        
        
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

@end
