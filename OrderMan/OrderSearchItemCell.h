//
//  OrderSearchItemCell.h
//  OrderMan
//
//  Created by System Administrator on 11/3/14.
//  Copyright (c) 2014 System Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderSearchItemCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblUPC;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblQuantity;

@end
