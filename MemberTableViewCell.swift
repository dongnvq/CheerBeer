//
//  MemberTableViewCell.swift
//  CheerBeer
//
//  Created by CuongBeatbox on 2/3/16.
//  Copyright © 2016 CuongBeatbox. All rights reserved.
//

import UIKit

public class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var memberName: UILabel!
    
    @IBOutlet weak var numberOfBeer: UILabel!
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public func updateCell(member: PersonModel){
        memberName.text = member.Name
        numberOfBeer.text =  String(member.NumberOfBeer)
        
    }

}
