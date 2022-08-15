//
//  ViewController.swift
//  TaskManager
//
//  Created by Mac on 15/08/2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    var tasks = [NSManagedObject]()
    
    @IBOutlet weak var tableView: UITableView!
     
    @IBAction func addTask(sender: AnyObject){
        
        
        func saveTask(nameTask:String){
           //1
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           let managedContext = appDelegate.persistentContainer.viewContext
         
           //2
           let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)
           let task = NSManagedObject(entity: entity!, insertInto: managedContext)
         
           //3
           task.setValue(nameTask, forKey: "name")
         
           //4
           do {
             try managedContext.save()
             //5
             tasks.append(task)
           } catch let error as NSError {
             print("No ha sido posible guardar \(error), \(error.userInfo)")
           }
         }
        
        
        //Creamos el UIAlertController
       let alert = UIAlertController(title: "Nueva Tarea",
         message: "Añade una nueva tarea",
         preferredStyle: .alert)
     
       //Creamos el UIAlertAction que nos permitirá guardar la tarea
       let saveAction = UIAlertAction(title: "Guardar",
         style: .default,
         handler: { (action:UIAlertAction) -> Void in
            
           //Guardamos el texto del textField en el array tasks y recargamos la table view
           let textField = alert.textFields!.first
           saveTask(nameTask: textField!.text!)
           self.tableView.reloadData()
       })
     
       //Creamos el UIAlertAction que nos permitirá cancelar
       let cancelAction = UIAlertAction(title: "Cancelar",
         style: .default) { (action: UIAlertAction) -> Void in
       }
     
       //Añadimos el TextField al UIAlertController
       alert.addTextField {
         (textField: UITextField) -> Void in
       }
     
       //Añadimos las dos UIAlertAction que hemos creado al UIAlertController
       alert.addAction(saveAction)
       alert.addAction(cancelAction)
     
     //Lanzamos el UIAlertController
     present(alert,
       animated: true,
       completion: nil)
     }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")


    }

    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
     {
       return tasks.count
     }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
       //Creamos un objeto task que recuperamos del array tasks
       let task = tasks[indexPath.row]
       //Con KVC obtenemos el contenido del atributo "name" de la task y lo añadimos a nuestra Cell
       cell!.textLabel!.text = task.value(forKey: "name") as? String
     
       return cell!
     }
     
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
    }
     
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
     
      // 1
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let managedContext = appDelegate.persistentContainer.viewContext
     
      // 2
      let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Task")
     
      // 3
      do {
        let results = try managedContext.fetch(fetchRequest)
//        tasks = results as [NSManagedObject]
     } catch let error as NSError {
        print("No ha sido posible cargar \(error), \(error.userInfo)")
     }
     // 4
     tableView.reloadData()
    }
    

}

