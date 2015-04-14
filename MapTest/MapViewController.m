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
@property (nonatomic, strong) UIButton *zoomButton;
@property (nonatomic, strong) MKPolyline *polyline;
@property (nonatomic, strong) UILabel *pitchLabelData;

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



- (void) registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createTargets) name:@"queryDone" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeTimer) name:@"queryDone" object:nil];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self registerForNotifications];
    [[UserController sharedInstance] setWeaponForUser:cannon];
    [self setUpMotionManager];
    [self setUpLocationManagerAndHeading];
    [self showMainMapView];
    [UserController queryUsersNearCurrentUser:self.locationManager.location.coordinate withinMileRadius:10];
    [self setupSceneKitView];
    [self setUpDataViewFireButton];
    [self setUpPOVButton];
    
    self.arrayOfCraters = [NSMutableArray new];
    
}

- (void) createTargets {
    
    self.mArrayMarkersForMap = [NSMutableArray new];
    
    for (PFUser *user in [UserController sharedInstance].arrayOfUsers) {
        
        NSNumber *healthForTarget = user[healthKey];
        double health = [healthForTarget doubleValue];
        
        // will exclude the currentUser in the array
        // NOTE: must use isEqualToString (string), or else it will compare pointers than the actual objectId!
        if (![user.objectId isEqualToString:[PFUser currentUser].objectId]) {
            
            GMSMarker *marker = [GMSMarker new];
            marker.user = user;
            marker.map = self.gmMapView;
            marker.position = [UserController convertPFGeoPointToLocationCoordinate2D:user[userLocationkey]];
            
            //Set color of marker according to health
            marker.icon = [GMSMarker markerImageWithColor:[self changeColorForHealth:health]];
            
            [self.mArrayMarkersForMap addObject:marker];
        }
    }
}

- (UIColor *) changeColorForHealth:(double)health {
    return [UIColor colorWithRed:(100 - health)/100 green:health/100 blue:.15 alpha:1.0];
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
        self.locationManager.headingFilter = 3;
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

- (BOOL)mapView:(GMSMarker *)mapView didTapMarker:(GMSMarker *)marker {
    
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
    self.zoomButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.zoomButton setTitle:@"100" forState:UIControlStateNormal];
    self.zoomButton.layer.cornerRadius = 25;
    self.zoomButton.frame = CGRectMake(self.view.frame.size.width - 65, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - 80, 50, 50);
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

- (double) convertToDegrees:(double)pitch {
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
    CountdownTimerViewController *timer = [[CountdownTimerViewController alloc]initWithSeconds:[self calculateProjectileTravelTime]];
    NSLog(@"%@", timer);
    [self addChildViewController:timer];
    [timer didMoveToParentViewController:self];
    self.timer = timer;
    //[self.view addSubview:timer.view];
    
}

- (void) removeTimer {
    [self.timer removeFromParentViewController];
}

- (void) fireButtonPressed:(id)sender {
    
    [self createTimer];
    
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

- (void) hitCheckerAtLocation:(CLLocation *)hitLocation {
    
    // Play bombExplosion sound
    [[SoundController sharedInstance] playSoundEffect:bombExplosion];
    
    // Create crater coordinates
    // Sets coordinates for the opposite side corners for the overlay (crater)
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(hitLocation.coordinate.latitude + self.projectile.sizeOfCrater / 111111.0, hitLocation.coordinate.longitude + self.projectile.sizeOfCrater /111111.0);
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(hitLocation.coordinate.latitude - self.projectile.sizeOfCrater /111111.0, hitLocation.coordinate.longitude - self.projectile.sizeOfCrater /111111.0);
    
    GMSCoordinateBounds *overlayBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:southWest
                                                                              coordinate:northEast];
    GMSGroundOverlay *groundOverlay = [GMSGroundOverlay groundOverlayWithBounds:overlayBounds
                                                                           icon:[UIImage imageNamed:@"craterBigSquare"]];
    groundOverlay.map = self.gmMapView;
    
    [self performSelector:@selector(removeGMOverlay:) withObject:groundOverlay afterDelay:3];
    
    // Goes through each marker in the array and checks if that marker's position is within the radius of the weapon damage (meters) of the hitlocation
    for (GMSMarker *marker in self.mArrayMarkersForMap) {
        
        PFUser *userAtMarker = marker.user;
        
        CLLocationCoordinate2D positionOfMarker = marker.position;
        CLLocation *locationOfMarker = [[CLLocation alloc]initWithCoordinate:positionOfMarker altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:[NSDate date]];
        if ([locationOfMarker distanceFromLocation:hitLocation] < self.projectile.radiusOfDamage) {
            
            NSNumber *healthForTarget = userAtMarker[healthKey];
            double health = [healthForTarget doubleValue];
            
            // Runs these methods only if the marker has above 0 health
            if (health > 0 ) {
                // If the distance less than 35% away
                if ([locationOfMarker distanceFromLocation:hitLocation] < self.projectile.radiusOfDamage * 0.35 ) {
                    // do full damage
                    health -= self.projectile.damage;
                    NSLog(@"FULL DAMAGE. Health: %f", health);
                } else {
                    // otherwise do damage relative to is distance
                    health -= self.projectile.damage * ([locationOfMarker distanceFromLocation:hitLocation] / self.projectile.radiusOfDamage);
                    NSLog(@"did %f%% DAMAGE. Health: %f", self.projectile.damage * ([locationOfMarker distanceFromLocation:hitLocation] / self.projectile.radiusOfDamage), health);
                }
                marker.icon = [GMSMarker markerImageWithColor:[self changeColorForHealth:health]];
                // checks if health is below 0, if it is, remove the marker
                userAtMarker[healthKey] = [NSNumber numberWithDouble:health];
                if (health <= 0 ) {
                    NSLog(@"DEAD!");
                    
                    // increment kill for currentUser and saves to Parse
                    [[PFUser currentUser] incrementKey:killKey];
                    //[UserController saveUserToParse:[PFUser currentUser]];
                    
                    //                // increment death for userAtMarker saves to Parse
                    
                    [self longestDistanceRecordCheckerFromMarker:marker];
                    [self removeGMSMarker:marker];
                } else [self createAnimateHitLabel];
                // Adds +1 to the "shotsHit" on Parse
                [[PFUser currentUser] incrementKey:shotsHitKey];
            }
            
            
            
        }
        
    }
}



- (void) createAnimateHitLabel {
    // Create HIT label with animation
    UILabel *hitLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 100)];
    [self.view addSubview:hitLabel];
    hitLabel.text = @"HIT!";
    hitLabel.textAlignment = NSTextAlignmentCenter;
    hitLabel.textColor = [UIColor redColor];
    hitLabel.font = [UIFont boldSystemFontOfSize:50];
    
    // animates the HIT label
    CGAffineTransform scaleTransformHIT = CGAffineTransformMakeScale(.94, .94);
    [UIView animateWithDuration:0.5 animations:^{
        hitLabel.alpha = 0.0;
        hitLabel.center = CGPointMake(hitLabel.center.x, hitLabel.center.y - 14);
        hitLabel.transform = scaleTransformHIT;
        
    } completion:^(BOOL finished) {
        [hitLabel removeFromSuperview];
    }];
}

- (void) longestDistanceRecordCheckerFromMarker:(GMSMarker *)marker {
    // checks if its the longest distance hit, if it is, saves to Parse
    NSNumber *currentLongestDistance = [PFUser currentUser][longestDistanceKey];
    
    if (marker.distance > [currentLongestDistance doubleValue]) {
        NSNumber *newDistance = [NSNumber numberWithDouble:marker.distance];
        [PFUser currentUser][longestDistanceKey] = newDistance;
        
        // Create New Record label with animation
        UILabel *newRecordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 100)];
        [self.view addSubview:newRecordLabel];
        newRecordLabel.text = @"NEW DISTANCE RECORD!";
        newRecordLabel.textAlignment = NSTextAlignmentCenter;
        newRecordLabel.textColor = [UIColor redColor];
        newRecordLabel.font = [UIFont boldSystemFontOfSize:25];
        
        // animates the new record label
        CGAffineTransform scaleTransformNEWRECORD = CGAffineTransformMakeScale(.94, .94);
        [UIView animateWithDuration:2.0 animations:^{
            newRecordLabel.alpha = 0.0;
            newRecordLabel.center = CGPointMake(newRecordLabel.center.x, newRecordLabel.center.y - 14);
            newRecordLabel.transform = scaleTransformNEWRECORD;
            
        } completion:^(BOOL finished) {
            [newRecordLabel removeFromSuperview];
        }];
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



- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    self.cameraSKHeadingRotationNode.eulerAngles = SCNVector3Make(0, -(position.bearing * M_PI / 180), 0);
    self.cannonBarrelNode.eulerAngles = SCNVector3Make(self.pitchWithLimit, self.deviceYaw, 0 );
    
}

- (void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading.headingAccuracy < 10) return;
    
    [self.gmMapView animateToBearing:-[self convertToDegrees:self.deviceYaw]];
    //[gmMapView animateToViewingAngle:45];
    
    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);
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
