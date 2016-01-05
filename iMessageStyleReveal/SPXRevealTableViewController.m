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
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  cell.textLabel.text = [LoremIpsum name];
  cell.revealableView = [[UINib nibWithNibName:@"TimestampView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
  cell.revealStyle = rand() % 2 ? SPXRevealableViewStyleOverlay : SPXRevealableViewStyleSlide;
  
  cell.textLabel.textAlignment = cell.revealStyle == SPXRevealableViewStyleSlide ? NSTextAlignmentRight : NSTextAlignmentLeft;
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 40;
}

@end
