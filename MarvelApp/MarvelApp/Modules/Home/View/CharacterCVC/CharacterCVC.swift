//
//  CharacterCVC.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 29/10/22.
//

import UIKit

class CharacterCVCViewModel {
    var character : String
    init(character: String) {
        self.character = character
    }
}


class CharacterCVC: CollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.makeCircular()
    }

    override func configure(_ item: Any?) {
        guard let item = item as? CharacterCVCViewModel else { return }
        titleLabel.text = item.character
    }
    
}
