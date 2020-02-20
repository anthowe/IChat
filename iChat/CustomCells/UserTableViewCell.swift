//
//  UserTableViewCell.swift
//  iChat
//
//  Created by Anthony Howe on 12/26/19.
//  Copyright © 2019 Anthony Howe. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    var indexPath: IndexPath!
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tapGestureRecognizer.addTarget(self, action: #selector(self.avatarTap))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    func generateCellWith(fUser: FUser, indexPath: IndexPath){
        
        self.indexPath = indexPath
        
        self.fullNameLabel.text = fUser.fullname
        
        if fUser.avatar != ""{
            
            imageFromData(pictureData: fUser.avatar) { (avatarImage) in
                
                if avatarImage != nil{
                    
                    self.avatarImageView.image = avatarImage!.circleMasked
                }
            }
        }
    }
    
    @objc func avatarTap(){
        
        print("avatar tap at \(String(describing: indexPath))")
    }

}
