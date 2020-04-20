import Foundation
import UIKit
import CoreData
import Signals

class ProductCatalogService: ProductCatalogServiceProtocol {
    
    internal var networkService: NetworkServiceProtocol
    internal var userService: UserServiceProtocol
    
    var onCatalogLoadingFinished = Signal<(customerAccountId: Int64, wasSuccesful: Bool, error: String?)>()
    
    init()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        networkService = appDelegate.container.resolve(NetworkServiceProtocol.self)!
        userService = appDelegate.container.resolve(UserServiceProtocol.self)!
        
        self.userService.onCustomerAccountSelected.subscribe(with: self)
        { (_) in
            self.loadCatalogAsync()
        }
    }
    
    func getProducts(code: String!, completion: @escaping (_ results: [Product]?)-> Void)
    {
        guard let keyword = code else {
            completion(nil)
            return
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        request.predicate = NSPredicate(format: "(id CONTAINS[cd] %@) OR (code CONTAINS[cd] %@)", keyword, keyword)
        request.returnsObjectsAsFaults = false
        do
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let result = try context.fetch(request)
            completion(result as? [Product])
            return
        }
        catch
        {
            print("Failed")
        }
        completion(nil)
    }
    
    func getProduct(dssId: Int64) -> Product?
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        request.predicate = NSPredicate(format: "id = %d", dssId)
        request.returnsObjectsAsFaults = false
        do
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let result = try context.fetch(request)
            let product = result as? [Product]
            return product?.first
        }
        catch
        {
            print("Failed")
        }
        return nil
    }
    
    func loadCatalogAsync()
    {
        DispatchQueue.global(qos: .background).async
            {
                let customerAccountId = self.userService.currentCustomerAccount!.id!
                self.loadCatalog(customerAccountId: customerAccountId)
        }
    }
    
    func loadCatalog(customerAccountId: Int64)
    {
        let lastUpdated = UserDefaults.standard.object(forKey: "ProductsLastUpdatedDate") as? Date
        networkService.getProducts(customerId: (userService.currentCustomerAccount?.id)!, lastUpdated: lastUpdated, completion:
            {
                (result: ChangeSet?) in
                if result != nil
                {
                    self.saveProducts(changeset: result!, completion:
                    {
                        (wasProcessed: Bool) in
                        if wasProcessed
                        {
                            print("Finished saving products")
                            UserDefaults.standard.set(Date(), forKey: "ProductsLastUpdatedDate")
                            self.onCatalogLoadingFinished.fire((customerAccountId, true, nil))
                        }
                        else
                        {
                            print("Failed saving products")
                            self.onCatalogLoadingFinished.fire((customerAccountId, true, nil))
                        }
                    })
                }
                else
                {
                    print("Error loading products")
                    self.onCatalogLoadingFinished.fire((customerAccountId, false, "Unspecified error"))
                }
        })
    }
    
    func saveProducts(changeset: ChangeSet, completion: @escaping (_ result: Bool) -> Void)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Product", in: context)
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        managedObjectContext.persistentStoreCoordinator = context.persistentStoreCoordinator
        managedObjectContext.perform
        {
            // Upsert new and updated products
            autoreleasepool
            {
                if (changeset.new != nil)
                {
                    for product in changeset.new!
                    {
                        self.insertProductIntoManagedObjectContext(product: product, entity: entity, managedObjectContext: managedObjectContext)
                    }
                }
                
                if (changeset.updated != nil)
                {
                    for product in changeset.updated!
                    {
                        self.insertProductIntoManagedObjectContext(product: product, entity: entity, managedObjectContext: managedObjectContext)
                    }
                }
            }
            
            do
            {
                try managedObjectContext.save()
            }
            catch
            {
                print(error)
            }
            
            managedObjectContext.reset()
            
            // Soft-delete removed products
            if changeset.removed?.count ?? 0 > 0
            {
                self.softDeleteRemovedProducts(productIdList: changeset.removed!, entityDescription: entity, managedObjectContext: managedObjectContext)
            }
            
            completion(true)
        }
    }
    
    func insertProductIntoManagedObjectContext(product: ProductDto!, entity: NSEntityDescription!, managedObjectContext :NSManagedObjectContext!)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let newProduct = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        newProduct.setValue(product.id, forKey: "id")
        newProduct.setValue(product.code, forKey: "code")
        newProduct.setValue(product.name, forKey: "name")
        newProduct.setValue(product.longDescription, forKey: "longDescription")
        newProduct.setValue(product.imageUrl, forKey: "imageUrl")
        newProduct.setValue(product.brandId, forKey: "brandId")
    }
    
    func softDeleteRemovedProducts(productIdList: [Int64], entityDescription: NSEntityDescription!, managedObjectContext :NSManagedObjectContext!)
    {
        let batchUpdateRequest = NSBatchUpdateRequest(entity: entityDescription!)
        batchUpdateRequest.resultType = .updatedObjectIDsResultType
        batchUpdateRequest.propertiesToUpdate = ["isDeleted": NSNumber(value: true)]
        
        do
        {
            let batchUpdateResult = try managedObjectContext.execute(batchUpdateRequest) as! NSBatchUpdateResult
            let objectIDs = batchUpdateResult.result as! [NSManagedObjectID]
            for objectID in objectIDs
            {
                let managedObject = managedObjectContext.object(with: objectID)
                managedObjectContext.refresh(managedObject, mergeChanges: false)
            }
        }
        catch
        {
            let updateError = error as NSError
            print("\(updateError), \(updateError.userInfo)")
        }
    }
}
