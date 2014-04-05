/*
   Copyright (c) 2014 Snippex. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY Snippex `AS IS' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL Snippex OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


/**
 *  Defines the gesture options avaialble for the revealable views
 */
typedef NS_OPTIONS(NSInteger, SPXRevealableViewGestureDirection)
{
  /**
   *  Pan to the left
   */
  SPXRevealableViewGestureDirectionLeft,
  /**
   *  Pan to the right
   */
  SPXRevealableViewGestureDirectionRight
};


/**
 *  Adds support for a revealable view to this cell
 */
@interface UITableViewCell (SPXRevealAdditions)


/**
 *  Gets/sets the revealable view. The view will be added to the cell's contentView
 */
@property (nonatomic, strong) UIView *revealableView;


@end


/**
 *  Adds support for revealable views to all cells when performing a left or right gesture
 */
@interface UITableView (SPXRevealAdditions)


/**
 *  Enables a revealable view for the specified gesture direction
 *
 *  @param direction The gesture direction
 */
- (void)enableRevealableViewForDirection:(SPXRevealableViewGestureDirection)direction;


@end
