//
//  MainTableViewController.swift
//  Journal
//
//  Created by 蘇冠禎 on 2017/8/4.
//  Copyright © 2017年 蘇冠禎. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postID", for: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let frame: CGRect = tableView.frame
        // header
        
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        headerView.backgroundColor = UIColor.white
        
        // title
        
        let mainTitle = UILabel(frame: CGRect(x: 30, y: 34, width: 283, height: 24))
        
        mainTitle.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightSemibold)
        
        mainTitle.textColor = UIColor(red: 67.0/255.0, green: 87.0/255.0, blue: 97.0/255.0, alpha: 1.0)
        
        mainTitle.textAlignment = .left
        
        mainTitle.text = "My Journals"
        
        headerView.addSubview(mainTitle)

        // button
        
        let addBtn: UIButton = UIButton(frame: CGRect(x: frame.size.width - 52, y: 22, width: 44, height: 44))

        let btnImage = UIImage(named: "icon_plus")?.withRenderingMode(.alwaysTemplate)
        
        addBtn.setImage(btnImage, for: .normal)
        
        addBtn.tintColor = UIColor.red

        addBtn.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)

        headerView.addSubview(addBtn)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    
    func buttonTapped(sender: UIButton) {
        print("Tapped")
        
        guard
            let newContentVC = self.storyboard?.instantiateViewController(withIdentifier: "newContent")
            else {
                print("couldn't find newContentVC")
                return
        }
        
        self.present(newContentVC, animated: true, completion: nil)
        
    }
 
}
