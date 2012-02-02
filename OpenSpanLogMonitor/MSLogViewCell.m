//
//  MSLogViewCell.m
//  OpenSpanLogMonitor
//
//  Created by Chris Mills on 02/02/2012.
//  Copyright (c) 2012 MillsySoft. All rights reserved.
//

#import "MSLogViewCell.h"

@implementation MSLogViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel *dateLabel = [[[UILabel	alloc] initWithFrame:CGRectMake(0.0, 0, 30.0,
                                                                    22.0 )] autorelease];
		dateLabel.tag = 0;
		dateLabel.font = [UIFont systemFontOfSize:12.0];
		dateLabel.textAlignment = UITextAlignmentRight;
		dateLabel.textColor = [UIColor blueColor];
		//dateLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:dateLabel]; 
        
        UILabel *msgLabel = [[[UILabel	alloc] initWithFrame:CGRectMake(60.0, 0, 300.0,
                                                                        22.0 )] autorelease];
		msgLabel.tag = 1;
		msgLabel.font = [UIFont systemFontOfSize:12.0];
		msgLabel.textAlignment = UITextAlignmentRight;
		msgLabel.textColor = [UIColor blueColor];
		//msgLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:msgLabel]; 
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@synthesize logDate = _logDate;
@synthesize message = _message;

-(void)setMessage:(NSString *)message
{
    _message = message;
    UILabel* label = (UILabel*)[self viewWithTag:1];
    label.text = self.message;
}

-(void)setLogDate:(NSDate *)date
{
    _logDate = date;
    UILabel* label = (UILabel*)[self viewWithTag:0];
    label.text = [self.logDate description];
}


@end
