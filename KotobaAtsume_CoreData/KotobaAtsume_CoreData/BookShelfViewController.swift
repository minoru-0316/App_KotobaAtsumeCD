//
//  BookShelfViewController.swift
//  KotobaAtsume_CoreData
//
//  Created by Minoru Edo on 2020/09/30.
//  Copyright © 2020 Minoru Edo. All rights reserved.
//
//--------【参考サイト】https://blog.codecamp.jp/programming-iphone-app-development-todo ----------

import UIKit

class BookShelfViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    //本棚へ登録
    @IBOutlet weak var bookShelfTableView: UITableView!
    
    var books : [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookShelfTableView.dataSource = self
        bookShelfTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        bookShelfTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let book = books[indexPath.row]
        cell.textLabel?.text = book.title!
        return cell
    }
    
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            books = try context.fetch(Book.fetchRequest())
        }
        catch {
            print("読み込み失敗")
        }
    }
    
    //リストから削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete {
            let book = books[indexPath.row]
            context.delete(book)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                books = try context.fetch(Book.fetchRequest())
            } catch {
                print("削除失敗")
            }
        }
        tableView.reloadData()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
