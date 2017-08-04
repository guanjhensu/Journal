//
//  MainTableViewController.swift
//  Journal
//
//  Created by 蘇冠禎 on 2017/8/4.
//  Copyright © 2017年 蘇冠禎. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {

    // MARK: Property

    var posts  = [PostContent]()
    
    // MARK: View Life Cycle

    override func viewDidLoad() {

        super.viewDidLoad()
        
        // deleteRecords()
        
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        
        self.tableView.register(cellNib, forCellReuseIdentifier: "PostCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchCoreDate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }

    // MARK: Get Core Data

    func fetchCoreDate() {
        
        _ = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
        
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                print("couldn't find appDelegate")
                return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            posts = try context.fetch(PostContent.fetchRequest())
        
        } catch (let error) {
            print(error)
        }

        return
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell
            else {
                print("couldn't find PostTableViewcell")
                return UITableViewCell()
        }
        
        cell.userPostTitle.text = posts[indexPath.row].postTitle
        
        let imageData = posts[indexPath.row].postImage
        
        if imageData as Data? == nil { return UITableViewCell() }

        cell.userImageView.image = UIImage(data: imageData! as Data, scale: 1.0)
        
        return cell
    }
    
    // MARK: Delete

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {

            guard
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                else {
                    print("couldn't find appDelegate")
                    return
            }
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostContent")
            
            let result = try? context.fetch(fetchRequest)
            
            guard let resultData = result as? [PostContent]
                else { return }

            context.delete(resultData[indexPath.row])
            
            appDelegate.saveContext()
            
            fetchCoreDate()

            tableView.reloadData()
        }
    }
    
    // MARK: header
    
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
    
    // MARK: Delete All Core Data
    
    func deleteRecords() {
        
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                print("couldn't find appDelegate")
                return
        }
        let moc = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostContent")
        
        let result = try? moc.fetch(fetchRequest)
        
        guard let resultData = result as? [PostContent]
            else { return }
        
        for object in resultData {
            moc.delete(object)
        }
        
        do {
            try moc.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
 
}
