//
//  SPXRevealController.m
//  iMessageStyleReveal
//
//  Created by Shaps Mohsenin on 04/04/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

#import "SPXRevealTableViewController.h"
#import "UITableView+SPXRevealAdditions.h"
#import "LoremIpsum.h"

@implementation SPXRevealTableViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.tableView enableRevealableViewForDirection:SPXRevealableViewGestureDirectionLeft];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UIView *backgroundView = [UIView new];
  backgroundView.backgroundColor = [UIColor blueColor];
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  cell.textLabel.text = [LoremIpsum name];
  cell.backgroundView = backgroundView;
  
  backgroundView = [UIView new];
  backgroundView.backgroundColor = [UIColor redColor];
  cell.selectedBackgroundView = backgroundView;
  
  cell.revealableView = [[UINib nibWithNibName:@"TimestampView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 40;
}

@end
