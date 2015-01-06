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

#import "SPXRevealableView.h"

@interface SPXRevealableView ()

@property (nonatomic, weak) UITableViewCell *cell;
@property (nonatomic, assign) SPXRevealableViewGestureDirection gestureDirection;

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIView *horizontalSeparator;
@property (nonatomic, strong) UIView *verticalSeparator;
@property (nonatomic, assign) BOOL selected;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *currentBackgroundView;
@property (nonatomic, strong) UIView *topSeparator;
@property (nonatomic, assign) UITableViewStyle tableViewStyle;

@end

@implementation SPXRevealableView

@synthesize backgroundView = _backgroundView;
@synthesize selectedBackgroundView = _selectedBackgroundView;

- (instancetype)init
{
  self = [super init];
  if (!self) return nil;
  [self configureTextField];
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (!self) return nil;
  [self configureTextField];
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (!self) return nil;
  [self configureTextField];
  return self;
}

- (void)addSubview:(UIView *)view
{
  [self.contentView addSubview:view];
}

- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview
{
  [self.contentView insertSubview:view aboveSubview:siblingSubview];
}

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
  [self.contentView insertSubview:view atIndex:index];
}

- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview
{
  [self.contentView insertSubview:view belowSubview:siblingSubview];
}

- (void)setCustom:(BOOL)custom
{
  _custom = custom;
  [self configureTextField];
}

- (void)setText:(NSString *)text
{
  _text = text;
  [self configureTextField];
}

- (void)setTextColor:(UIColor *)textColor
{
  _textColor = textColor;
  [self configureTextField];
}

- (void)setTintColor:(UIColor *)tintColor
{
  [super setTintColor:tintColor];
  [self configureTextField];
}

- (void)setRightAlign:(BOOL)rightAlign
{
  _rightAlign = rightAlign;
  self.textLabel.textAlignment = rightAlign ? NSTextAlignmentRight : NSTextAlignmentLeft;
}

- (void)setShowVerticalSeparator:(BOOL)showVerticalSeparator
{
  _showVerticalSeparator = showVerticalSeparator;
  [self configureVerticalSeparator];
}

- (void)setShowHorizontalSeparator:(BOOL)showHSeparator
{
  _showHorizontalSeparator = showHSeparator;
  [self configureHorizontalSeparator];
}

- (void)setTextPadding:(NSUInteger)textPadding
{
  _textPadding = textPadding;
  [self configureTextField];
}

- (void)setGestureDirection:(SPXRevealableViewGestureDirection)gestureDirection
{
  _gestureDirection = gestureDirection;
  [self configureVerticalSeparator];
}

- (void)setTableViewStyle:(UITableViewStyle)tableViewStyle
{
  _tableViewStyle = tableViewStyle;
  
  if (tableViewStyle == UITableViewStyleGrouped) {
    if (!self.topSeparator) {
      self.topSeparator = [UIView new];
      self.topSeparator.backgroundColor = [UIColor colorWithWhite:0.816 alpha:1.000];
      
      CGRect rect = self.bounds;
      rect.size.height = self.lineWidth;
      self.topSeparator.frame = rect;
      
      [super insertSubview:self.topSeparator belowSubview:self.contentView];
    }
  } else {
    [self.topSeparator removeFromSuperview];
    self.topSeparator = nil;
  }
}

- (UIView *)contentView
{
  if (_contentView) {
    return _contentView;
  }
  
  _contentView = [UIView new];
  _contentView.backgroundColor = [UIColor clearColor];
  _contentView.frame = self.bounds;
  _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  
  [super addSubview:_contentView];
  return _contentView;
}

- (void)setSelected:(BOOL)selected
{
  _selected = selected;
  self.currentBackgroundView = selected ? self.selectedBackgroundView : self.backgroundView;
}

- (void)setCurrentBackgroundView:(UIView *)currentBackgroundView
{
  [self.currentBackgroundView removeFromSuperview];
  
  currentBackgroundView.frame = self.contentView.bounds;
  currentBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  
  _currentBackgroundView = currentBackgroundView;
  [super insertSubview:currentBackgroundView belowSubview:self.contentView];
}

- (void)setBackgroundView:(UIView *)backgroundView
{
  if (_backgroundView == backgroundView) {
    return;
  }
  
  [_backgroundView removeFromSuperview];
  _backgroundView = backgroundView;
  
  if (!self.selected) {
    self.currentBackgroundView = backgroundView;
  }
}

- (void)setSelectedBackgroundView:(UIView *)selectedBackgroundView
{
  if (_selectedBackgroundView == selectedBackgroundView) {
    return;
  }
  
  [_selectedBackgroundView removeFromSuperview];
  _selectedBackgroundView = selectedBackgroundView;
  
  if (self.selected) {
    self.currentBackgroundView = selectedBackgroundView;
  }
}

- (UIView *)backgroundView
{
  if (_backgroundView) {
    return _backgroundView;
  }
  
  _backgroundView = [UIView new];
  return _backgroundView;
}

- (UIView *)selectedBackgroundView
{
  if (_selectedBackgroundView) {
    return _selectedBackgroundView;
  }
  
  _selectedBackgroundView = [UIView new];
  _selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.816 alpha:1.000];
  
  return _selectedBackgroundView;
}

- (void)configureTextField
{
  if (self.custom) {
    [self.textLabel removeFromSuperview];
    self.textLabel = nil;
    return;
  }
  
  if (!self.textLabel) {
    self.textLabel = [UILabel new];
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.textLabel];
  }
  
  self.textLabel.text = self.text;
  self.textLabel.textColor = self.textColor ?: self.tintColor;
  [self layoutTextLabel];
}

- (void)layoutTextLabel
{
  CGRect rect = self.bounds;

  rect.origin.x += self.textPadding;
  rect.size.width -= self.textPadding * 2;
  
  self.textLabel.frame = rect;
  self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (CGFloat)lineWidth
{
  CGFloat scale = [UIScreen mainScreen].scale;
  
  if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
    scale = [UIScreen mainScreen].nativeScale ?: 0.5;
    return 1 / scale;
  } else {
    return 1 / [UIScreen mainScreen].scale;
  }
}

- (void)configureHorizontalSeparator
{
  if (!self.showHorizontalSeparator) {
    [self.horizontalSeparator removeFromSuperview];
    self.horizontalSeparator = nil;
    return;
  }
  
  if (!self.horizontalSeparator) {
    self.horizontalSeparator = [UIView new];
    self.horizontalSeparator.backgroundColor = [UIColor colorWithRed:0.737 green:0.729 blue:0.757 alpha:1.000];
    self.horizontalSeparator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [super insertSubview:self.horizontalSeparator aboveSubview:self.contentView];
  }
  
  CGRect rect = self.bounds;
  rect.origin.y += CGRectGetHeight(rect) - self.lineWidth;
  rect.size.height = self.lineWidth;
  self.horizontalSeparator.frame = rect;
} 

- (void)configureVerticalSeparator
{
  if (!self.showVerticalSeparator) {
    [self.verticalSeparator removeFromSuperview];
    self.verticalSeparator = nil;
    return;
  }
  
  if (!self.verticalSeparator) {
    self.verticalSeparator = [UIView new];
    self.verticalSeparator.backgroundColor = [UIColor colorWithRed:0.737 green:0.729 blue:0.757 alpha:1.000];
    self.verticalSeparator.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    [super insertSubview:self.verticalSeparator aboveSubview:self.contentView];
  }
  
  CGRect rect = self.bounds;
  
  if (self.gestureDirection == SPXRevealableViewGestureDirectionRight) {
    rect.origin.x = CGRectGetWidth(rect) - self.lineWidth;
  }
  
  rect.size.width = self.lineWidth;
  self.verticalSeparator.frame = rect;
}

@end
