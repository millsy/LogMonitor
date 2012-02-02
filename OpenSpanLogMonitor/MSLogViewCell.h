//
//  MSLogViewCell.h
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 02/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSLogViewCell : UITableViewCell

@property (nonatomic, retain) NSDate* logDate;
@property (nonatomic, retain) NSString* message;

@end
