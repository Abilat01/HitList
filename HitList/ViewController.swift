//
//  ViewController.swift
//  HitList
//
//  Created by Danya on 24.08.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managerContext  = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            people = try managerContext.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func NewTaskSave(_ sender: UIBarButtonItem) {
        
        let alertControler = UIAlertController(title: "Новое имя", message: "Добавте новое имя", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [unowned self] (action) in
            guard let textField = alertControler.textFields?.first, let nameToSave = textField.text else {
                return
            }
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertControler.addTextField()
        
        alertControler.addAction(saveAction)
        alertControler.addAction(cancelAction)
        
        present(alertControler, animated: true, completion: nil)
    }
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managerContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managerContext)!
        let person = NSManagedObject(entity: entity, insertInto: managerContext)
        
        person.setValue(name, forKey: "name")
        
        do {
            try managerContext.save()
            people.append(person)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let person = people[indexPath.row]
        
        cell.textLabel?.text = person.value(forKey: "name") as? String
        
        return cell
    }
    
    
    
    
}

