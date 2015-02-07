//
//  MovieDetailViewController.m
//  rottenclient
//
//  Created by Naeim Semsarilar on 2/4/15.
//  Copyright (c) 2015 naeim. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *url = [[self.movie valueForKeyPath:@"posters.original"] stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
    [self.posterView setImageWithURL:[NSURL URLWithString:url]];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
