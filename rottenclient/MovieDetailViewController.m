//
//  MovieDetailViewController.m
//  rottenclient
//
//  Created by Naeim Semsarilar on 2/4/15.
//  Copyright (c) 2015 naeim. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIScrollView+APParallaxHeader.h"
#import "MovieDetailCell.h"

@interface MovieDetailViewController () <UITableViewDelegate, UITableViewDataSource, APParallaxViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIImageView *posterView;
@property (strong, nonatomic) MovieDetailCell *tempCell;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // sizes
    self.tableView.frame = CGRectMake(0, 0, 375, 603);
    self.posterView.frame = CGRectMake(0, 0, 375, 603);
    
    // configure navigation bar
    self.navigationController.navigationBar.translucent = NO;
    
    // configure table view
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieDetailCell" bundle:nil] forCellReuseIdentifier:@"MovieDetailCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // create image view
    CGRect posterRect = CGRectMake(0, 0, 375, 603);
    self.posterView = [[UIImageView alloc] initWithFrame:posterRect];
    NSString *url = [[self.movie valueForKeyPath:@"posters.original"] stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
    [self.posterView setImageWithURL:[NSURL URLWithString:url]];
    self.posterView.contentMode = UIViewContentModeScaleAspectFill;
    
    // parallax
    [self.tableView addParallaxWithView:self.posterView andHeight:530];
    self.tableView.parallaxView.delegate = self;
    
    // temp cell for cell size calculation
    self.tempCell = [self.tableView dequeueReusableCellWithIdentifier:@"MovieDetailCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)populateCell:(MovieDetailCell*)cell {
    cell.title.text = [NSString stringWithFormat:@"%@ (%ld)", self.movie[@"title"], [[self.movie objectForKey:@"year"] integerValue]];
    
    NSInteger audienceScore = [[self.movie valueForKeyPath:@"ratings.audience_score"] integerValue];
    NSString* audienceRating = [self.movie valueForKeyPath:@"ratings.audience_rating"];
    if (!audienceRating) {
        audienceRating = @"WTS";
    }
    NSInteger criticsScore = [[self.movie valueForKeyPath:@"ratings.critics_score"] integerValue];
    NSString* criticsRating = [self.movie valueForKeyPath:@"ratings.critics_rating"];
    
    if (audienceScore >= 0) {
        cell.audienceRating.text = [NSString stringWithFormat:@"%ld%%", audienceScore];
        [cell.audienceIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", audienceRating]]];
    } else {
        cell.audienceRating.hidden = YES;
        cell.audienceIcon.hidden = YES;
    }
    
    if (criticsScore >= 0) {
        cell.criticsRating.text = [NSString stringWithFormat:@"%ld%%", criticsScore];
        [cell.criticsIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", criticsRating]]];
    } else {
        cell.criticsRating.hidden = YES;
        cell.criticsIcon.hidden = YES;
    }
    
    // mpaa
    NSString* mpaa = self.movie[@"mpaa_rating"];
    if (mpaa && [mpaa length] > 0) {
        cell.mpaaRating.layer.borderColor = [UIColor grayColor].CGColor;
        cell.mpaaRating.layer.borderWidth = 1.0;
        cell.mpaaRating.text = [NSString stringWithFormat:@" %@ ", mpaa];
        [cell.mpaaRating sizeToFit];
    } else {
        cell.mpaaRating.hidden = YES;
    }
    
    // cast
    NSArray *actors = self.movie[@"abridged_cast"];
    NSMutableArray *someActors = [NSMutableArray array];
    
    for(int i = 0; i < MIN(2, actors.count); i++) {
        NSDictionary *actor = actors[i];
        NSString *name = actor[@"name"];
        [someActors addObject:name];
    }
    
    cell.cast.text = [someActors componentsJoinedByString:@", "];
    
    // UI
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.frame = CGRectMake(0, 0, 375, 800);
    
    // synopsis
    cell.synopsis.text = self.movie[@"synopsis"];
    cell.synopsis.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    [cell.synopsis sizeToFit];
}

#pragma Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieDetailCell" forIndexPath:indexPath];
    
    [self populateCell:cell];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect rect = [self.movie[@"synopsis"] boundingRectWithSize:CGSizeMake(359.0, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:17]} context:nil];

    return rect.size.height + 250;
}

#pragma Parallax View

- (void)parallaxView:(APParallaxView *)view willChangeFrame:(CGRect)frame {
    // Do whatever you need to do to the parallaxView or your subview before its frame changes
}

- (void)parallaxView:(APParallaxView *)view didChangeFrame:(CGRect)frame {
    // Do whatever you need to do to the parallaxView or your subview after its frame changed
}


@end
