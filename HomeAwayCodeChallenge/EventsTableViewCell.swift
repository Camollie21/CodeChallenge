//
//  EventsTableViewCell.swift
//  HomeAwayCodeChallenge
//
//  Created by Cameron Ollivierre on 6/25/18.
//  Copyright © 2018 Cameron Ollivierre. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventPreviewImage: UIImageView!
    @IBOutlet weak var heartImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
