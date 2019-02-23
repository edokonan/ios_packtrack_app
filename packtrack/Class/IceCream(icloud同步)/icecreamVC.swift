//
//  icecreamVC.swift
//  packtrack
//
//  Created by ksymac on 2019/2/11.
//  Copyright © 2019年 ZHUKUI. All rights reserved.
//
import UIKit
import RealmSwift
import IceCream
import RxRealm
import RxSwift

class icecreamVC: UIViewController {
    
    let jim = Person()
    var dogs: [RMTrackMain] = []
    let bag = DisposeBag()
    
    lazy var realm = try! Realm()
    
    lazy var addBarItem: UIBarButtonItem = {
        let b = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(add))
        return b
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        navigationItem.rightBarButtonItem = addBarItem
        title = "iceCream"
        
        bind()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.frame
    }
    
    func bind() {
        let realm = try! Realm()
        
        /// Results instances are live, auto-updating views into the underlying data, which means results never have to be re-fetched.
        /// https://realm.io/docs/swift/latest/#objects-with-primary-keys
        let dogs = realm.objects(RMTrackMain.self)
        
        Observable.array(from: dogs).subscribe(onNext: { (dogs) in
            /// When dogs data changes in Realm, the following code will be executed
            /// It works like magic.
//            self.dogs = dogs.filter{ !$0.isDeleted }
            self.dogs = dogs.filter{ !$0.isDeleted }
            self.tableView.reloadData()
        }).disposed(by: bag)
    }
    
    @objc func add() {
        IceCreamMng.shared.deleteAllDataForTest()
        IceCreamMng.shared.startImportToIceCreamFromOldDB()
        let list1:Array<TrackStatus> = IceCreamMng.shared.getAllStatusList();
        for bean in list1{
            print(bean.status)
            print(bean.statusname)
        }
        print("-----------------------")
        let list:[RMTrackMain] = IceCreamMng.shared.getTrackMainlist();
        for bean in list{
            print(bean.trackNo)
            let list2: Array<TrackDetail> = IceCreamMng.shared.getDetailsByTrackNo(bean.trackNo)
            for bean2 in list2{
                print(bean2.status)
            }
        }
    }
}

extension icecreamVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, ip) in
            let alert = UIAlertController(title: NSLocalizedString("caution", comment: "caution"), message: NSLocalizedString("sure_to_delete", comment: "sure_to_delete"), preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: NSLocalizedString("delete", comment: "delete"), style: .destructive, handler: { (action) in
                guard ip.row < self.dogs.count else { return }
                let dog = self.dogs[ip.row]
                try! self.realm.write {
                    dog.isDeleted = true
                }
            })
            let defaultAction = UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel"), style: .default, handler: nil)
            alert.addAction(defaultAction)
            alert.addAction(deleteAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        let archiveAction = UITableViewRowAction(style: .normal, title: "Plus") { [weak self](_, ip) in
            guard let `self` = self else { return }
            guard ip.row < `self`.dogs.count else { return }
            let dog = `self`.dogs[ip.row]
            try! `self`.realm.write {
//                dog.age += 1
            }
        }
        let changeImageAction = UITableViewRowAction(style: .normal, title: "Change Img") { [weak self](_, ip) in
            guard let `self` = self else { return }
            guard ip.row < `self`.dogs.count else { return }
            let dog = `self`.dogs[ip.row]
            try! `self`.realm.write {
//                if let imageData = UIImageJPEGRepresentation(UIImage(named: dog.age % 2 == 0 ? "smile_dog" : "tongue_dog")!, 1.0) {
//                    dog.avatar = CreamAsset.create(object: dog, propName: Dog.AVATAR_KEY, data: imageData)
//                }
            }
        }
        changeImageAction.backgroundColor = .blue
        let emptyImageAction = UITableViewRowAction(style: .normal, title: "Nil Img") { [weak self](_, ip) in
            guard let `self` = self else { return }
            guard ip.row < `self`.dogs.count else { return }
            let dog = `self`.dogs[ip.row]
            try! `self`.realm.write {
//                dog.avatar = nil
            }
        }
        emptyImageAction.backgroundColor = .purple
        return [deleteAction, archiveAction, changeImageAction, emptyImageAction]
    }
}

extension icecreamVC: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = dogs[indexPath.row].trackNo
        cell?.imageView?.image = UIImage(named: "dog_placeholder")
        return cell ?? UITableViewCell()
    }
}

