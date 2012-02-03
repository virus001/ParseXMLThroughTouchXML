//
//  ViewController.h
//  ChkTouchXML
//
//  Created by Vishwanath Uddanti on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableData *respData;

@property (nonatomic, retain) NSMutableArray *respArray;

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

-(void)readFromXML;

@end
