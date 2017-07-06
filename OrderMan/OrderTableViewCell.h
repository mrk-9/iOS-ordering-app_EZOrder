//
//  OrderTableViewCell.h
//  OrderMan
//
//  Created by System Administrator on 11/2/14.
//  Copyright (c) 2014 System Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell

    @property (strong, nonatomic) IBOutlet UILabel *lbldatetime;
    @property (strong, nonatomic) IBOutlet UILabel *lblNumberOfItems;
    @property (strong, nonatomic) IBOutlet UILabel *lblDesciption;
    @property (strong, nonatomic) IBOutlet UILabel *lblOrderId;

@end
