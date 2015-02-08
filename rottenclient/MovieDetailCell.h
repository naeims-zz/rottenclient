//
//  MovieDetailCell.h
//  rottenclient
//
//  Created by Naeim Semsarilar on 2/7/15.
//  Copyright (c) 2015 naeim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *synopsis;
@property (weak, nonatomic) IBOutlet UILabel *mpaaRating;
@property (weak, nonatomic) IBOutlet UIImageView *audienceIcon;
@property (weak, nonatomic) IBOutlet UILabel *audienceRating;
@property (weak, nonatomic) IBOutlet UIImageView *criticsIcon;
@property (weak, nonatomic) IBOutlet UILabel *criticsRating;
@property (weak, nonatomic) IBOutlet UILabel *cast;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end
