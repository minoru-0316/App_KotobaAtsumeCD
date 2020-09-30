//
//  BookDetail.swift
//  KotobaAtsume_CoreData
//
//  Created by Minoru Edo on 2020/09/23.
//  Copyright © 2020 Minoru Edo. All rights reserved.
//

import UIKit

class BookDetail: UIViewController {
    
    
    @IBOutlet weak var BookTitle: UILabel!
    @IBOutlet weak var Authors: UILabel!
    @IBOutlet weak var Publishers: UILabel!
    @IBOutlet weak var ImageLinks: UILabel!
    @IBOutlet weak var IndustryIdentifiers: UILabel!
    @IBOutlet weak var PreviewLink: UILabel!
    
    var titleText: String?
    var authorsText: [String]?
    var publisherText: String?
    var imageLink: URL?
    var industryIdentifiersText: [String]?
    var previewLinkURL: URL?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("詳細画面が開いた")
        self.BookTitle.text = self.titleText
        
        self.Publishers.text = self.publisherText
        if publisherText == nil {
            self.Publishers.text = "情報がありません"
            self.Publishers.textColor = UIColor.red
        }
        self.Authors.text = self.authorsText!.joined(separator: "、")
        
    }
    
    //CoreDataへ本の情報を保存するコード
    //--------【参考サイト】https://blog.codecamp.jp/programming-iphone-app-development-todo ----------
    @IBAction func registerToBookShelf(_ sender: Any) {
        print("本棚 へ登録　ボタンが押された")
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let book = Book(context: context)
        book.title = self.BookTitle.text!
        book.authors = self.Authors.text!
        book.publisher = self.Publishers.text!
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        //画面遷移：segueを使用しない処理
        //参考サイト：https://qiita.com/marcy731/items/942bd40a8339daeeff97
        let sbBookShelf = UIStoryboard(name: "BookShelf", bundle: nil)
        let vcBookShelf = sbBookShelf.instantiateInitialViewController() as! BookShelfViewController
        self.navigationController?.pushViewController(vcBookShelf, animated: true)
        
        print("本棚　に保存されました。")
    }
    
    
    @IBAction func registerToConcern(_ sender: Any) {
        print("気になる へ登録　ボタンが押された")
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
