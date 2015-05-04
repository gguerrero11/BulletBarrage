//
//  MarkerInfoWindowView.h
//  MapTest
//
//  Created by Gabriel Guerrero on 5/2/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "GMSMarker+addUser.h"

@interface MarkerInfoWindowView : UIView

- (id) initWithFrame:(CGRect)frame andMarker:(GMSMarker *)marker;

@end
