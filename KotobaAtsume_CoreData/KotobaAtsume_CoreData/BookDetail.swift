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
    

    @IBAction func registerToBookShelf(_ sender: Any) {
        print("本棚 へ登録　ボタンが押された")
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
