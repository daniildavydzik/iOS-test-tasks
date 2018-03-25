//
//  KivaLoanTableViewController.swift
//  KivaLoan
//
//  Created by Daniel Davydzik on 24/03/2018.
//Copyright © 2018 DavydzikInc. All rights reserved.
import UIKit
import CoreData
class KivaLoanTableViewController: UITableViewController {

    
    
   func updateTableViewContent(){
        do {
            try  self.fetchResultController.performFetch()
        } catch let error {
            print(error)
        }
        
        let apiService = APIService()
        apiService.getDataWith { (result) in
            switch result{
            case .Success(let data):
                
                self.clearData()
                self.saveInCoreData(loans: data)
            case .Error(let error):
                print(error)
            }
        }
    }
   // MARK: - ViewController Lifecycle methods
    override func loadView() {
        super.loadView()
         UserDefaults.standard.set(false, forKey: "hasViewedWalkThrough")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 92.0
        tableView.rowHeight = UITableViewAutomaticDimension
        updateTableViewContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - CoreData operations
    private lazy var fetchResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: LoanMO.self))
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    private func createCoreDataEntityWith(loanDictionary : [String : AnyObject]) -> NSManagedObject?{
        let loan = LoanMO(context: CoreDataManager.sharedInstance.persistentContainer.viewContext)
        loan.name = loanDictionary["name"] as? String
        let location = loanDictionary["location"] as? [String : AnyObject]
        loan.country = location?["country"] as? String
        loan.use = loanDictionary["use"] as? String
        loan.loan_amount = (loanDictionary["loan_amount"] as? Int16)!
        
        return loan
    }
    
    private func saveInCoreData(loans : [[String:AnyObject]]){
        _ = loans.map({ self.createCoreDataEntityWith(loanDictionary: $0)})
        do {
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
        CoreDataManager.sharedInstance.saveContext()
    }
    
    private func clearData() {
        do {
            
            let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: LoanMO.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataManager.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fetchCount = fetchResultController.sections?.first?.numberOfObjects{
            return fetchCount
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! KivaLoanTableViewCell
        
        if let loan = self.fetchResultController.object(at: indexPath) as? LoanMO{
            cell.nameLabel.text = loan.name
            cell.countryLabel.text = loan.country
            cell.useLabel.text = loan.use
            cell.amountLabel.text = String(loan.loan_amount)
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowLoanDetail" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let destinationController = segue.destination as! LoanDetailViewController
                destinationController.loan = self.fetchResultController.object(at: indexPath) as? LoanMO
            }
        }
    }
    
    
}
extension KivaLoanTableViewController : NSFetchedResultsControllerDelegate{
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
}
