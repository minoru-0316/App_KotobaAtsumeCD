//
//  ViewController.swift
//  KotobaAtsume_CoreData
//
//  Created by Minoru Edo on 2020/09/23.
//  Copyright © 2020 Minoru Edo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //---------------------------------------------------------------------------
        //[メモ 5:searchBar : delegate , プレースホルダーを設定]
        //Search Barのdelegate通知先を設定
        searchText.delegate = self
        //入力のヒントとなる、プレースホルダーを設定
        searchText.placeholder = "検索キーワードを入力。表示件数20件まで"
        
        //---------------------------------------------------------------------------
        //[メモ 12 <2>dataSourceメソッドが存在するクラスの設定]
        tableView.dataSource = self
        
    }
    
    //---------------------------------------------------------------------------
    //[メモ 4:searchBar , tableView　の紐付け]
    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    //---------------------------------------------------------------------------
    //[メモ11 <1>本のデータを格納するタプルを作成し、さらにそれを配列にする]
    var searchBookList : [(title:String?, authors:[String?], publisher:String?, industryIdentifiers:[industryIdentifiersJson], imageLinks:ImageLinkJson, previewLink:URL)] = []
    
    //---------------------------------------------------------------------------
    //[メモ 6:searchBarのサーチボタンクリック時のメソッドを追加]
    // 検索ボタンをクリックした時のメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //キーボードを閉じる
        view.endEditing(true)
        
        if let searchWord = searchBar.text {
            print("検索キーワード： \(searchWord)")
            searchBook(keyword: searchWord)
        }
    }
    
    //---------------------------------------------------------------------------
    //[メモ 8:リクエストを生成して、JSONを取得する JSONを記憶する構造体の宣言]
    
    // imageLinkのデータ構造
    struct  ImageLinkJson: Codable {
        let smallThumbnail: URL?
        let thumbnail: URL?
    }
    
    // isbnLinkのデータ構造
    struct  industryIdentifiersJson: Codable {
        let type: String
        let identifier: String
    }
    
    //VolumeInfoJson内のデータ構造
    struct VolumeInfoJson: Codable {
        //本のタイトル
        let title: String?
        //著者
        let authors: [String]?
        //出版社
        let publisher: String?
        //画像リンク
        let imageLinks: ImageLinkJson?
        //JANコード(ISBN_10 ISBN_13)
        let industryIdentifiers: [industryIdentifiersJson]?
        //紹介ページへのリンク
        let previewLink: URL?
    }
    
    // JSONのItems内のデータ構造
    struct ItemsJson: Codable {
        let volumeInfo: VolumeInfoJson?
    }
    
    //JSONのデータ構造
    struct ResultJson: Codable {
        //複数要素
        let kind: String?
        let totalItems: Int?
        let items:[ItemsJson]?
    }
    
    
    //---------------------------------------------------------------------------
    //[メモ 7:キーワードから本を検索して、一覧を表示する searchBookメソッド]
    //第一引数
    func searchBook(keyword : String) {
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            else {
                return
        }
        
        //リクエストURLの組み立て（結果の表示数は、20件まで）
        guard let req_url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(keyword_encode)&maxResults=20&startIndex=1") else{
            return
        }
        print(req_url)
        
        //---------------------------------------------------------------------------
        //[メモ 9:リクエストを生成して、JSONを取得]
        //リクエストに必要な情報を生成
        let req = URLRequest(url: req_url)
        //データ転送を管理するためのセッションを生成
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //リクエストをタスクとして登録
        let task = session.dataTask(with: req, completionHandler: {
            (data , response , error) in
            
            //セッションを終了
            session.finishTasksAndInvalidate()
            
            //do try catch　エラーハンドリング
            do {
                //JSONDecoderのインスタンス取得
                let decoder = JSONDecoder()
                //受け取ったJSONデータをパース（解析）して格納
                let json = try decoder.decode(ResultJson.self, from: data!)
                print("jsonを出力")
                print(json)
                
                
                //---------------------------------------------------------------------------
                //[メモ 11 <2>本のデータをタプル配列に詰め込む]
                //本の情報が取得できているか確認
                if let itemsInfo = json.items {
                    
                    //本のリストを初期化
                    self.searchBookList.removeAll()
                    
                    //取得している本の数だけ処理
                    for items in itemsInfo {
                        //本の情報をアンラップ
                        if
                            let title = items.volumeInfo?.title ,
                            let authors:[String?] = items.volumeInfo?.authors ,
                            let publisher:String? = items.volumeInfo?.publisher ,
                            let industryIdentifiers = items.volumeInfo?.industryIdentifiers ,
                            let imageLinks = items.volumeInfo?.imageLinks ,
                            let previewLink = items.volumeInfo?.previewLink
                            
                        {
                            //1つの本をタプルでまとめて管理する
                            let bookInfo = (title,
                                            authors,
                                            publisher,
                                            industryIdentifiers,
                                            imageLinks,
                                            previewLink)
                            //本の配列へ追加
                            self.searchBookList.append(bookInfo)
                            print("タプルにまとめたbookInfoを出力")
                            print(bookInfo)
                        }
                    }
                    
                    //TableViewを更新する
                    self.tableView.reloadData()
                    
                    //正常に動作しているかの確認
                    if let bookInfodbg = self.searchBookList.first {
                        print("取得した本の１番目の結果を出力ーーーーーーーーーーーーーーーーーーーーーーーー")
                        print("一番目の検索結果 = \(bookInfodbg)")
                    }
                }
                
            }
            catch {
                //エラー処理
                print("エラーが出ました")
            }
        })
        //ダウンロード開始
        task.resume()
    }
    
    //---------------------------------------------------------------------------
    //[メモ 12 <3>dataSourceメソッドの追加]
    //Cellの総数を返すdataSourceメソッド、必ず記述すること
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //本の検索結果の総数
        return searchBookList.count
    }
    
    //---------------------------------------------------------------------------
    //[メモ 12 <4>dataSourceメソッドの追加]
    //Cellに値を設定するdataSourceメソッド、必ず記述すること
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //今回表示を行う、Cellオブジェクト（１行）を取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath)
        
        //本のタイトルを取得
        cell.textLabel?.text = searchBookList[indexPath.row].title
        //本の画像(smallThumbnail)を取得
        if let imageData = try? Data(contentsOf: searchBookList[indexPath.row].imageLinks.smallThumbnail!) {
            //正常に取得できた場合は、UIImageで画像オブジェクトを生成して、Cellに本の画像を設定
            cell.imageView?.image = UIImage(data: imageData)
        }
        //設定済みのCellオブジェクトを画面に反映
        return cell
    }
    
}

//---------------------------------------------------------------------------
//[メモ]
