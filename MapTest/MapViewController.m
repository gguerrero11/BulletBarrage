//
//  ViewController.m
//  Snipey
//
//  Created by Gabriel Guerrero on 3/23/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "MapViewController.h"

#import <CoreMotion/CoreMotion.h>
#import "CustomLoginViewController.h"
#import "CustomSignUpViewController.h"
#import <Parse/Parse.h>
#import "UserController.h"
#import "CountdownTimerViewController.h"
#import "Weapon.h"
#import "WeaponController.h"
#import "UserController.h"
#import "GMSMarkerWithUser.h"
#import "SoundController.h"
#import "GMSMarker+addUser.h"
#import "HealthData.h"
#import "HealthDataController.h"
#import "HealthBox.h"
#import "InterfaceLineDrawer.h"

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
static NSString * const craterBigSquare = @"craterBigSquare";
static NSString * const rubble = @"rubble";
static NSString * const smoke = @"smoke";

// Polyline Static
static bool kAnimate = true;

@interface MapViewController () <PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate,UIAlertViewDelegate>
{
    CMMotionManager *_motionManager;
    GMSCameraPosition *gmCamera;
    
    // Polyline properties
    NSArray *_styles;
    NSArray *_lengths;
    NSArray *_polys;
    double _pos, _step;
    
}

@property (nonatomic, strong) GMSMapView *gmMapView;
@property (nonatomic, strong) CLLocation *myLocation;
@property (nonatomic, strong) MKMapCamera *targetCamera;
@property (nonatomic, strong) UIButton *fireButton;
@property (nonatomic, strong) UIButton *respawnButton;
@property (nonatomic, strong) UIButton *zoomButton;
@property (nonatomic, strong) MKPolyline *polyline;
@property (nonatomic, strong) HealthBox *healthBox;
@property (nonatomic, strong) InterfaceLineDrawer *interfaceLineDrawer;
@property (nonatomic) BOOL initialLaunch;

// SceneKit Properties
@property (nonatomic, strong) SCNView *sceneView;
@property (nonatomic, strong) SCNNode *cannonBarrelNode;
@property (nonatomic, strong) SCNNode *barrelPivotNode;
@property (nonatomic, strong) SCNNode *placementNode;
@property (nonatomic, strong) SCNBox *cannonBarrel;
@property (nonatomic, strong) SCNPyramid *placement;
@property (nonatomic, strong) SCNNode *cameraSKPositionNode;
@property (nonatomic, strong) SCNNode *cameraSKHeadingRotationNode;
@property (nonatomic, strong) SCNNode *cameraSKPitchRotationNode;

// GMS Map
@property (nonatomic, assign) NSInteger zoomSelection;
@property (nonatomic, assign) double pitchWithLimit;
@property (nonatomic, strong) NSMutableArray *arrayOfCraters;
@property (nonatomic, strong) CountdownTimerViewController *timer;
@property (nonatomic, strong) NSMutableArray *mArrayMarkersForMap;

@property (nonatomic, strong) Weapon *projectile;
@property (nonatomic, strong) HealthData *currentUserHealthData;
@property (nonatomic, strong) HealthDataController *healthDataController;

// CMDevice motion
@property (nonatomic, strong) CMAttitude *attitude;
@property (nonatomic) double deviceYaw;

// Sound Effects
@property (nonatomic,strong) SoundController *soundController;

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
    
    [PFUser currentUser][healthKey] = [NSNumber numberWithDouble:100.0];
    [PFUser currentUser][killKey] = [NSNumber numberWithDouble:0.0];
    [PFUser currentUser][deathKey] = [NSNumber numberWithDouble:0.0];
    [PFUser currentUser][accuracyKey] = [NSNumber numberWithDouble:0.0];
    [PFUser currentUser][shotsFiredKey] = [NSNumber numberWithDouble:0.0];
    [PFUser currentUser][shotsHitKey] = [NSNumber numberWithDouble:0.0];
    [PFUser currentUser][longestDistanceKey] = [NSNumber numberWithDouble:0.0];
    [PFUser currentUser][weaponSelectedKey] = cannon;
    [UserController saveUserToParse:[PFUser currentUser]];
    
    self.currentUserHealthData = [HealthData object];
    self.currentUserHealthData[healthKey] = @100;
    self.currentUserHealthData[userKey] = [PFUser currentUser];
    [HealthDataController saveHealthData:self.currentUserHealthData];
    
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


#pragma mark viewDidLoad stuff

- (void) registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerHDataNotifAndCreateTargets) name:@"queryDone" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeTimer) name:@"timerDone" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDeadAlert) name:@"userDead" object:nil];

}

- (void) registerHDataNotifAndCreateTargets {
    [self createTargets];
    [HealthDataController retrieveArrayOfHealthForUsers];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHealthOfMarkers) name:@"healthQueryDone" object:nil];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.alpha = 0;
    
    self.initialLaunch = YES;
    self.healthDataController = [HealthDataController new];
    
    self.arrayOfCraters = [NSMutableArray new];

    [self registerForNotifications];
    
    [[UserController sharedInstance] setWeaponForUser:cannon];
    [self setUpMotionManager];
    [self setUpLocationManagerAndHeading];
    [self showMainMapView];
    
    [UserController queryUsersNearCurrentUser:self.locationManager.location.coordinate withinMileRadius:10];
    
    [self setupSceneKitView];
    
    self.interfaceLineDrawer = [[InterfaceLineDrawer alloc]initWithFrame:self.view.frame withView:self.view];
    self.interfaceLineDrawer.attitude = self.attitude;
    self.interfaceLineDrawer.mapCamera = self.gmMapView.camera;

    [self setUpDataDisplayAndButtons];
    [self setUpPOVButton];
    
}


- (void) createTargets {
    
    self.mArrayMarkersForMap = [NSMutableArray new];
    
    for (PFUser *user in [UserController sharedInstance].arrayOfUsers) {
        
        GMSMarker *marker = [GMSMarker new];
        marker.user = user;
        marker.title = user[usernameKey];
        marker.map = self.gmMapView;
        marker.position = [UserController convertPFGeoPointToLocationCoordinate2D:user[userLocationkey]];
        marker.snippet = marker.distanceString;
        marker.icon = [GMSMarker markerImageWithColor:[UIColor grayColor]];
        
        // Sets the currentUser's marker.map to nil
        // NOTE: must use isEqualToString (string), or else it will compare pointers than the actual objectId!
        if ([[PFUser currentUser].objectId isEqualToString:marker.user.objectId]) {
            marker.map = nil;
        }
        
        [self.mArrayMarkersForMap addObject:marker];
    }
}

// this essentially redraws all the markers when: user launches app, hits/destroys a target.
- (void) updateHealthOfMarkers {
    
    if (self.mArrayMarkersForMap) {
        for (GMSMarker *marker in self.mArrayMarkersForMap) marker.map = nil;
    }
    
    [self createTargets];
    
    for (GMSMarker *marker in self.mArrayMarkersForMap) {

        HealthData *userHealthData = [[HealthDataController sharedInstance] retrieveHealthDataFromUser:marker.user];
        NSNumber *healthForTarget = userHealthData[healthKey];
        double health = [healthForTarget doubleValue];
        //NSLog(@"%f", health);
        
        //Set color of marker according to health for non-currentUser targets
        if (![[PFUser currentUser].objectId isEqualToString:marker.user.objectId]) {
            if (health > 0) {
                
                marker.icon = [GMSMarker markerImageWithColor:[self changeColorForHealth:health]];
                
            } else {
                
                // this only creates smoke/rubble at the intial launch of the app
                if (self.initialLaunch == YES) {
                    [self createGMSMarkerAtCoordinate:marker.position type:smoke disappear:YES];
                    [self createGMSOverlayAtCoordinate:marker.position type:rubble disappear:YES];
                }
                
                // If that marker's health is below 0 it hides it.
                marker.map = nil;

            }
        } else {
            
            if (health <= 0) {
                self.currentUserHealthData = userHealthData;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"userDead" object:nil];
            }
        }
    }
    // setting this to NO disables the creation of smoke/rubble everytime this method is called.
    self.initialLaunch = NO;
}

- (UIColor *) changeColorForHealth:(double)health {
    
    double redColor = 0.0;
    double greenColor = 1.0;
    
    if (health >= 50) {
        redColor = (100 - health) / 50 ;
    } else redColor = 1.0;
    
    if (health <= 50) {
        greenColor = (health * 2) /100;
    }
    //NSLog(@"Heatlh %f", health);
    //NSLog(@"Colors %f, %f" ,redColor, greenColor);
    
    return [UIColor colorWithRed:redColor green:greenColor blue:0 alpha:1.0];
}

- (void) setUpMotionManager {
    _motionManager = [CMMotionManager new];
    
    if (_motionManager.isGyroAvailable) {
        //tell maanger to start pulling gyroscope info
        
        [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            
            // attitude what its 3d orientation is (pitch, roll, yaw)
            self.attitude = motion.attitude;
            self.deviceYaw = motion.attitude.yaw + 1.55;
            
            [self.interfaceLineDrawer move:left boxBasedByValue:self.pitchWithLimit];
            [self.interfaceLineDrawer move:right boxBasedByValue:self.gmMapView.camera.zoom];
            
            //[gmMapView animateToBearing:-[self convertToDegrees:self.deviceYaw]];
            //[gmMapView animateToViewingAngle:45];
            
            //[gmMapView animateToLocation:self.myLocation.coordinate];
            // NSLog(@"%f", gmMapView.camera.viewingAngle);
            
            // Set pitch limit for map camera
            if (self.attitude.pitch <= 0){
                self.pitchWithLimit = 0;
            } else {
                self.pitchWithLimit = self.attitude.pitch;
            }
            
            self.cameraSKPitchRotationNode.rotation = SCNVector4Make(1, 0, 0, (self.gmMapView.camera.viewingAngle) * (M_PI/180) );
            self.cameraSKPositionNode.position = SCNVector3Make(0, -((double)self.gmMapView.camera.zoom - 22) * 5  ,0);
            
            
            //            self.pyramidNode.eulerAngles = SCNVector3Make(self.deviceYaw, 0, 1.5 );
            
            // NSLog(@"%f", -((double)gmMapView.camera.zoom - 22) * 5);
            
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
    self.locationManager.distanceFilter = 200;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager startUpdatingLocation];
    
    // Start heading updates.
    if([CLLocationManager headingAvailable] == YES){
        NSLog(@"Heading is available");
        self.locationManager.headingFilter = 4;
        [self.locationManager startUpdatingHeading];
    } else {
        NSLog(@"Heading isn’t available");
    }
    
    // Saves location to Parse
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (geoPoint) {
            [PFUser currentUser][userLocationkey] = geoPoint;
            //#warning TURN THIS BACK ON BEFORE SUBMITTING!
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Initial User location saved to Parse");
                } else {
                    NSLog(@"Error: %@", error);
                }
            }];
            
        } else NSLog(@"Cannot find user!");
    }];
    
    
    self.myLocation = self.locationManager.location;
}

- (void) showMainMapView {
    
    gmCamera = [GMSCameraPosition cameraWithTarget:self.myLocation.coordinate zoom:15 bearing:32 viewingAngle:17];
    
    self.gmMapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 250) camera:gmCamera];
    self.gmMapView.myLocationEnabled = YES;
    self.gmMapView.settings.scrollGestures = NO;
    self.gmMapView.delegate = self;
    
    [self.view addSubview:self.gmMapView];
}

- (void) setUpDataDisplayAndButtons {
    
    // Set up fire button
    self.fireButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 30, self.view.frame.size.height - 130, 80, 80)];
    self.fireButton.layer.cornerRadius = 40;
    self.fireButton.backgroundColor = [UIColor redColor];
    [self.fireButton setTitle:@"Fire!" forState:UIControlStateNormal];
    [self.fireButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.fireButton setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    [self.fireButton addTarget:self action:@selector(fireButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.fireButton];
    
    // Set up respawn button
    self.respawnButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 -
                                                                    75, self.view.frame.size.height / 2, 150, 150)];
    self.respawnButton.layer.cornerRadius = 75;
    self.respawnButton.backgroundColor = [UIColor blueColor];
    [self.respawnButton setTitle:@"Respawn" forState:UIControlStateNormal];
    [self.respawnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.respawnButton addTarget:self action:@selector(showRespawnButton) forControlEvents:UIControlEventTouchDown];
    self.respawnButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.respawnButton.layer.shadowOpacity = 0.8;
    self.respawnButton.layer.shadowRadius = 3;
    self.respawnButton.layer.shadowOffset = CGSizeMake(12.0f, 12.0f);
    self.respawnButton.hidden = YES;
    [self.view addSubview:self.respawnButton];
    
    // Set up HealthBox
    self.healthBox = [[HealthBox alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 35, 0, 100, 70)];
    [self.view addSubview:self.healthBox];
}

- (void) showRespawnButton {
    self.currentUserHealthData[healthKey] = @100;
    [HealthDataController saveHealthData:self.currentUserHealthData];
    self.respawnButton.hidden = YES;
    self.fireButton.backgroundColor = [UIColor redColor];
    self.fireButton.userInteractionEnabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDeadAlert) name:@"userDead" object:nil];
}

- (void) userDeadAlert {
    UIAlertView *deadAlert = [[UIAlertView alloc]initWithTitle:@"You have been destroyed!" message:@"Well, looks like you're dead. Hopefully it's not because you aimed horribly." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:@"Who got me!?", nil];
    [deadAlert show];
    self.respawnButton.hidden = NO;
    self.fireButton.backgroundColor = [UIColor grayColor];
    self.fireButton.userInteractionEnabled = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userDead" object:nil];
    
}

- (BOOL) mapView:(GMSMarker *)mapView didTapMarker:(GMSMarker *)marker {
    
    return NO;
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
    self.cameraSKPositionNode = [SCNNode node];
    self.cameraSKHeadingRotationNode = [SCNNode node];
    self.cameraSKPitchRotationNode = [SCNNode node];
    
    // Setup heading rotation node
    self.cameraSKHeadingRotationNode.position = SCNVector3Make(0, 0, 0);
    [self.cameraSKHeadingRotationNode addChildNode: self.cameraSKPitchRotationNode];
    
    // setup pitch rotation node
    [self.cameraSKPitchRotationNode addChildNode:self.cameraSKPositionNode];
    
    // Setup camera node
    self.cameraSKPositionNode.position = SCNVector3Make(0, 5, 0);
    self.cameraSKPositionNode.rotation = SCNVector4Make(1, 0, 0, 270 * (M_PI / 180));
    self.cameraSKPositionNode.camera = camera;
    
    [scene.rootNode addChildNode:self.cameraSKHeadingRotationNode];
    
    // Create pyramid
    self.cannonBarrel = [SCNBox boxWithWidth:.05 height:.05 length:.5 chamferRadius:0];
    self.cannonBarrel.firstMaterial.diffuse.contents = [UIColor colorWithRed:0.149 green:0.604 blue:0.859 alpha:1.000];
    
    // Create cube
    self.placement = [SCNPyramid pyramidWithWidth:.3 height:.3 length:.3];
    self.placement.firstMaterial.diffuse.contents = [UIColor colorWithRed:0.149 green:0.604 blue:0.859 alpha:1.000];
    
    //SCNFloor use later
    
    SCNNode *cannonBarrel = [SCNNode nodeWithGeometry:self.cannonBarrel];
    cannonBarrel.pivot = SCNMatrix4MakeTranslation(0, 0, .3);
    cannonBarrel.position = SCNVector3Make(0, .1, 0);
    
    SCNNode *placementNode = [SCNNode nodeWithGeometry:self.placement];
    placementNode.position = SCNVector3Make(0, .03, 0);
    
    
    [placementNode addChildNode:cannonBarrel];
    [scene.rootNode addChildNode:placementNode];
    
    self.cannonBarrelNode = cannonBarrel;
    self.placementNode = placementNode;
    
    // Add scene to SceneView
    self.sceneView.scene = scene;
    [self.view addSubview:self.sceneView];
    
    
}

- (void) setUpPOVButton {
    self.zoomButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.zoomButton setTitle:@"100" forState:UIControlStateNormal];
    self.zoomButton.layer.cornerRadius = 25;
    self.zoomButton.frame = CGRectMake(self.view.frame.size.width - 100, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - 80, 50, 50);
    [self.zoomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.zoomButton.tintColor = [UIColor whiteColor];
    self.zoomButton.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.zoomButton];
    [self.zoomButton addTarget:self action:@selector(changeZoom) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *homeIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"homelocation"]];
    homeIcon.frame = CGRectMake(self.zoomButton.frame.size.width / 2 - self.zoomButton.frame.size.width * 0.75 / 2, self.zoomButton.frame.size.height / 2 - self.zoomButton.frame.size.height * 0.75 / 2 , self.zoomButton.frame.size.width * 0.75, self.zoomButton.frame.size.height * 0.75);
    [self.zoomButton addSubview:homeIcon];
    
}

- (void) changeZoom {
    
    switch (self.zoomSelection) {
            //        case 0:
            //            [gmMapView animateToZoom:18];
            //            self.zoomSelection = 1;
            //            break;
            //        case 1:
            //            [gmMapView animateToZoom:17];
            //            self.zoomSelection = 2;
            //            break;
            //        case 2:
            //            [gmMapView animateToZoom:14];
            //            self.zoomSelection = 0;
            //            break;
            
        case 0:
            [self.zoomButton setTitle:@"100" forState:UIControlStateNormal];
            [[UserController sharedInstance] setWeaponForUser:cannon];
            self.zoomSelection = 1;
            break;
        case 1:
            [self.zoomButton setTitle:@"250" forState:UIControlStateNormal];
            [[UserController sharedInstance] setWeaponForUser:missle];
            self.zoomSelection = 2;
            break;
        case 2:
            [self.zoomButton setTitle:@"500" forState:UIControlStateNormal];
            [[UserController sharedInstance] setWeaponForUser:nuke];
            self.zoomSelection = 0;
            break;
    }
}


#pragma mark Firing/Projectile methods

+ (double) convertToDegrees:(double)pitch {
    return pitch * (180/M_PI);
}

- (double) calculateDistanceFromUserWeapon {
    
    // formula to calculate the distance the projectile will travel
    double range = ( powl([UserController sharedInstance].currentWeapon.velocity, 2 ) * sinl(2 * self.pitchWithLimit) ) / gravityStatic;
    return range;
}

- (double) calculateProjectileTravelTime {
    double time = [self calculateDistanceFromUserWeapon] / [UserController sharedInstance].currentWeapon.velocity * cosh(self.pitchWithLimit);
    return time;
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

- (void) createTimer {
    self.timer = [[CountdownTimerViewController alloc]initWithSeconds:[self calculateProjectileTravelTime]];
    self.timer.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
    self.timer.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.4];
    NSLog(@"%@", self.timer);
    [self addChildViewController:self.timer];
    [self.timer didMoveToParentViewController:self];
    
    [self.view addSubview:self.timer.view];
    
}

- (void) removeTimer {
    
    [self.timer removeFromParentViewController];
    
}

- (void) fireButtonPressed:(id)sender {
    
    //[self createTimer];
    
    [[SoundController sharedInstance] playSoundEffect:cannon];
    //NSURL *urlForCannon = [[NSBundle mainBundle] URLForResource:cannon withExtension:@"caf"];
    //[self.soundController playAudioFileAtURL:urlForCannon];
    
    
    // we need to create a separate projecile weapon instance, so when the user changes weapon mid-flight, it doesn't change that weapon also
    self.projectile = [Weapon new];
    self.projectile = [UserController sharedInstance].currentWeapon;
    
    // Adds +1 to the "shotsFired" on Parse
    [[PFUser currentUser] incrementKey:shotsFiredKey];
    
    CLLocation * hitLocation = [[CLLocation alloc]initWithLatitude:[self calculateHitLocation].latitude
                                                         longitude:[self calculateHitLocation].longitude];
    
    [self performSelector:@selector(hitCheckerAtLocation:) withObject:hitLocation afterDelay:[self calculateProjectileTravelTime]];
    //[self performSelector:@selector(hitCheckerAtLocation:) withObject:hitLocation afterDelay:3];
    
    [self drawTrajectoryLineToLocation:hitLocation];
    //[self setUpPolyineColorsToLocation:hitLocation];
    
}

- (void) createGMSOverlayAtCoordinate:(CLLocationCoordinate2D )hitCoordinate type:(NSString *)type disappear:(BOOL)disappear {
    
    // the distance of the coordinate for the overlay (the corners). This determines the size of the overlay;
    NSInteger overlayOffset;
    
    // checks if its rubble type, if not, the size of the crater according to the weapon is the offset.
    if (type != rubble) overlayOffset = self.projectile.sizeOfCrater;
    else overlayOffset = 50;
    
    // Create crater coordinates if its not "rubble" type
    // Sets coordinates for the opposite side corners for the overlay (crater)
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(hitCoordinate.latitude + overlayOffset / 111111.0, hitCoordinate.longitude + overlayOffset /111111.0);
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(hitCoordinate.latitude - overlayOffset /111111.0, hitCoordinate.longitude - overlayOffset /111111.0);
    
    GMSCoordinateBounds *overlayBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:southWest
                                                                              coordinate:northEast];
    GMSGroundOverlay *groundOverlay = [GMSGroundOverlay groundOverlayWithBounds:overlayBounds
                                                                           icon:[UIImage imageNamed:type]];
    
    groundOverlay.bearing = rand() % 360;
    
    groundOverlay.map = self.gmMapView;
    
    if (disappear == YES) [self performSelector:@selector(removeGMOverlay:) withObject:groundOverlay afterDelay:60];
}

- (void) createGMSMarkerAtCoordinate:(CLLocationCoordinate2D )atCoordinate type:(NSString *)type disappear:(BOOL)disappear {
    
    // create smoke marker
    GMSMarker *marker = [GMSMarker new];
    marker.map = self.gmMapView;
    marker.position = atCoordinate;
    marker.icon = [UIImage imageNamed:smoke];
    
    if (disappear == YES) [self performSelector:@selector(removeGMSMarker:) withObject:marker afterDelay:60];
}

- (void) hitCheckerAtLocation:(CLLocation *)hitLocation {
    
    // Play bombExplosion sound
    [[SoundController sharedInstance] playSoundEffect:bombExplosion];
    
    // play explosion gif
    GMSMarker *explosion = [GMSMarker new];
    explosion.map = self.gmMapView;
    explosion.position = hitLocation.coordinate;
    explosion.icon = [UIImage animatedImageNamed:@"explosion-" duration:0.7f];
    [self performSelector:@selector(removeGMSMarker:) withObject:explosion afterDelay:0.7 ];
    
    // create crater
    [self createGMSOverlayAtCoordinate:hitLocation.coordinate type:craterBigSquare disappear:YES];
    
    // Goes through each marker in the array and checks if that marker's position is within the radius of the weapon damage (meters) of the hitlocation
    for (GMSMarker *marker in self.mArrayMarkersForMap) {
        
        PFUser *userAtMarker = marker.user;
        HealthData *healthDataUserAtMarker = [[HealthDataController sharedInstance] retrieveHealthDataFromUser:userAtMarker];
        
        CLLocationCoordinate2D positionOfMarker = marker.position;
        CLLocation *locationOfMarker = [[CLLocation alloc]initWithCoordinate:positionOfMarker altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:[NSDate date]];
        if ([locationOfMarker distanceFromLocation:hitLocation] < self.projectile.radiusOfDamage) {
            
            NSNumber *healthForTarget = healthDataUserAtMarker[healthKey];
            int health = [healthForTarget doubleValue];
            
            // Runs these methods only if the marker has above 0 health
            if (health > 0 ) {
                
                // If the distance less than 35% away
                if ([locationOfMarker distanceFromLocation:hitLocation] < self.projectile.radiusOfDamage * 0.35 ) {
                    
                    // do full damage
                    health -= self.projectile.damage;
                    NSLog(@"FULL DAMAGE. Health: %d", health);
                    
                } else {
                    
                    // otherwise do damage relative to is distance
                    health -= self.projectile.damage * ([locationOfMarker distanceFromLocation:hitLocation] / self.projectile.radiusOfDamage);
                    NSLog(@"did %f%% DAMAGE. Health: %d", self.projectile.damage * ([locationOfMarker distanceFromLocation:hitLocation] / self.projectile.radiusOfDamage), health);
                }
                
                marker.icon = [GMSMarker markerImageWithColor:[self changeColorForHealth:health]];
                
                // ensures health never goes below 0 and sets it to the user's HealthData
                if (health < 0) health = 0;
                healthDataUserAtMarker[healthKey] = [NSNumber numberWithUnsignedInteger:health];
                
                if (health <= 0 ) {
                    
                    [self createAnimateLabel:@"TARGET DESTROYED!" bigText:NO];
                    NSLog(@"DEAD!");
                    
                    [self createGMSOverlayAtCoordinate:marker.position type:rubble disappear:NO];
                    
                    [self createGMSMarkerAtCoordinate:marker.position type:smoke disappear:NO];
                    
                    // increment kill for currentUser and saves to Parse
                    [[PFUser currentUser] incrementKey:killKey];
                    //[UserController saveUserToParse:[PFUser currentUser]];
                    
                    // increment death for userAtMarker saves to Parse
                    [healthDataUserAtMarker incrementKey:deathKey];
                    
                    [self longestDistanceRecordCheckerFromMarker:marker];
                    [self removeGMSMarker:marker];
                    
                } else [self createAnimateLabel:@"HIT!" bigText:YES];
                
                // This will save health data
                [HealthDataController saveHealthData:healthDataUserAtMarker];
                
        

                // Adds +1 to the "shotsHit" but not saved yet.
                [[PFUser currentUser] incrementKey:shotsHitKey];
                
            }
        }
    }
}

- (void) createAnimateLabel:(NSString *)string bigText:(BOOL)bigText {
    UILabel *hitLabel = [UILabel new];
    [self.view addSubview:hitLabel];
    hitLabel.text = string;
    hitLabel.textAlignment = NSTextAlignmentCenter;
    hitLabel.textColor = [UIColor redColor];
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(.94, .94);
    
    if (bigText == YES) {
        
        // Create big Text
        hitLabel.frame = CGRectMake(0, 40, self.view.frame.size.width, 100);
        hitLabel.font = [UIFont boldSystemFontOfSize:50];
        
        // animates the label
        [UIView animateWithDuration:0.5 animations:^{
            hitLabel.alpha = 0.0;
            hitLabel.center = CGPointMake(hitLabel.center.x, hitLabel.center.y - 14);
            hitLabel.transform = scaleTransform;
            
        } completion:^(BOOL finished) {
            [hitLabel removeFromSuperview];
        }];
    } else {
        
        // Create smaller Text
        hitLabel.frame = CGRectMake(0, 120, self.view.frame.size.width, 100);
        hitLabel.font = [UIFont boldSystemFontOfSize:25];
        
        // animates the label
        [UIView animateWithDuration:2.0 animations:^{
            hitLabel.alpha = 0.0;
            hitLabel.center = CGPointMake(hitLabel.center.x, hitLabel.center.y - 14);
            hitLabel.transform = scaleTransform;
            
        } completion:^(BOOL finished) {
            [hitLabel removeFromSuperview];
        }];
        
        
    }
}

- (void) longestDistanceRecordCheckerFromMarker:(GMSMarker *)marker {
    
    // checks if its the longest distance hit
    NSNumber *currentLongestDistance = [PFUser currentUser][longestDistanceKey];
    
    if (marker.distance > [currentLongestDistance doubleValue]) {
        NSNumber *newDistance = [NSNumber numberWithDouble:marker.distance];
        [PFUser currentUser][longestDistanceKey] = newDistance;
        [self createAnimateLabel:@"NEW DISTANCE RECORD!" bigText:NO];
        
    }
}

- (void) removeGMOverlay:(GMSGroundOverlay *)overlay {
    overlay.map = nil;
    overlay = nil;
}

- (void) removeGMSMarker:(GMSMarker *)marker {
    marker.map = nil;
}


#pragma mark Polyline methods

- (void) drawTrajectoryLineToLocation:(CLLocation *)destination {
    GMSMutablePath *path = [GMSMutablePath path];
    [path addCoordinate:self.myLocation.coordinate];
    [path addCoordinate:destination.coordinate];
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor colorWithRed:1 green:0.1 blue:.1 alpha:.2];
    polyline.strokeWidth = 5.f;
    polyline.map = self.gmMapView;
    
    [self performSelector:@selector(removeGMSPolyline:) withObject:polyline afterDelay:[self calculateProjectileTravelTime]];
}

- (void) removeGMSPolyline:(GMSPolyline *)polyline {
    polyline.map = nil;
    polyline = nil;
}

- (void) tick {
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

- (void) initLinesToLocation:(CLLocation *)hitLocation {
    if (!_polys) {
        NSMutableArray *polys = [NSMutableArray array];
        GMSMutablePath *path = [GMSMutablePath path];
        [path addCoordinate:self.myLocation.coordinate];
        [path addCoordinate:hitLocation.coordinate];
        path = [path pathOffsetByLatitude:-30 longitude:0];
        _lengths = @[@([path lengthOfKind:kGMSLengthGeodesic] / 2)];
        for (int i = 0; i < 2; ++i) {
            GMSPolyline *poly = [[GMSPolyline alloc] init];
            poly.path = [path pathOffsetByLatitude:(i * 1.5) longitude:0];
            poly.strokeWidth = 8;
            poly.geodesic = YES;
            poly.map = self.gmMapView;
            [polys addObject:poly];
        }
        _polys = polys;
    }
}

- (void) setUpPolyineColorsToLocation:(CLLocation *)hitLocation {
    
    CGFloat alpha = 1;
    UIColor *red = [UIColor colorWithRed:1 green:0 blue: 0 alpha:alpha];
    UIColor *redTransp = [UIColor colorWithRed:1 green:0 blue: 0 alpha:0];
    GMSStrokeStyle *grad2 = [GMSStrokeStyle gradientFromColor:redTransp toColor:red];
    _styles = @[
                grad2,
                [GMSStrokeStyle solidColor:[UIColor colorWithWhite:0 alpha:0]],
                ];
    _step = 50000;
    [self initLinesToLocation:hitLocation];
    [self tick];
}


#pragma mark navigational items

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    self.cameraSKHeadingRotationNode.eulerAngles = SCNVector3Make(0, -(position.bearing * M_PI / 180), 0);
    self.cannonBarrelNode.eulerAngles = SCNVector3Make(self.pitchWithLimit, self.deviceYaw, 0 );
    
}

- (void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading.headingAccuracy < 10) return;
    
    [self.gmMapView animateToBearing:-[MapViewController convertToDegrees:self.deviceYaw]];
    //[gmMapView animateToViewingAngle:45];
    
    // Use the true heading if it is valid.
    //    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
    //                                       newHeading.trueHeading : newHeading.magneticHeading);
    //    self.cameraSKHeadingRotationNode.rotation = SCNVector4Make(0, 1, 0, gmMapView.camera.bearing * (M_PI / 180));
    
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
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
