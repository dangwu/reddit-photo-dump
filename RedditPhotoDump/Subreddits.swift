//
//  Subreddits.swift
//  RedditPhotoDump
//
//  Created by Wu, Daniel on 10/19/16.
//  Copyright © 2016 Wu, Daniel. All rights reserved.
//

import Foundation

struct Subreddits {
    
    static let all = [
        "abandonedporn",
        "amateurphotography",
        "animalporn",
        "architectureporn",
        "aww",
        "breathless",
        "cabinporn",
        "cityporn",
        "earthporn",
        "foodporn",
        "historyporn",
        "humanporn",
        "infrastructureporn",
        "itookapicture",
        "militaryporn",
        "naturepics",
        "photocritique",
        "pic",
        "pics",
        "remoteplaces",
        "ruralporn",
        "skyporn",
        "spaceporn",
        "travel",
        "villageporn",
        "wallpaper",
        "wallpapers"
    ]
    
    static func random() -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(Subreddits.all.count)))
        return Subreddits.all[randomIndex]
    }
}
