//
//  MovieCell.h
//  rottenclient
//
//  Created by Naeim Semsarilar on 2/3/15.
//  Copyright (c) 2015 naeim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIImageView *audienceIcon;
@property (weak, nonatomic) IBOutlet UIImageView *criticsIcon;
@property (weak, nonatomic) IBOutlet UILabel *audienceRating;
@property (weak, nonatomic) IBOutlet UILabel *criticsRating;
@property (weak, nonatomic) IBOutlet UILabel *mpaaLabel;

@end
