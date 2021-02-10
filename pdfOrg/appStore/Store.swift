//
//  Store.swift
//  pdfOrg
//
//  Created by Carl Espeter on 08.02.21.
//  https://www.youtube.com/watch?v=B_oVUIN7ZJQ&t=1186s
//  https://www.youtube.com/watch?v=skhYzNcfmnU&t=389s

import StoreKit


typealias FechCompletionHandler = (([SKProduct]) -> Void)
typealias PurchesCompletionHandler =  ((SKPaymentTransaction?) -> Void)

class Store: NSObject, ObservableObject {   //TODO: umbennenen IAPManger
        
    enum Prodakt: String, CaseIterable {
        case unlimitedBooks = "com.espeter.pdfOrg.unlimitedBooks.test3"
    }
    
    private let allProductIdentifiers = Set(Prodakt.allCases.compactMap({$0.rawValue}))
    
    private var completedPurcheses = [String]()
    
    private var productsRequest: SKProductsRequest?
    private var fetchedProducts = [SKProduct]()
    private var fetchCompletionHandler: FechCompletionHandler?
    private var purchesCompletionHandler: PurchesCompletionHandler?
    
    override init() {
        super.init()
        
        srartObservingPaymentQueue()
        
        fetchProducts { products in
            print(products)
            
            products.forEach { prodakt in
                print("ist gklauft oder auch nicht ... \(prodakt)")
            }
        }
    }
    
    
    private func srartObservingPaymentQueue(){
        SKPaymentQueue.default().add(self)
    }
    
    
    private func fetchProducts(_ completion: @escaping FechCompletionHandler) {
        
        guard self.productsRequest == nil else {return}
        
        fetchCompletionHandler = completion
        
        productsRequest = SKProductsRequest(productIdentifiers: allProductIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
        
    }
    
    private func buy(_ product: SKProduct, completion: @escaping PurchesCompletionHandler) {
        
        guard SKPaymentQueue.canMakePayments() else {
            return
        }
        
        
        purchesCompletionHandler = completion
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    
    private func addProduct(id: String) {
                
        let persistenceController = PersistenceController.shared
        let viewContext = persistenceController.container.viewContext
        
        
       let newProduct = Product(context: viewContext)
        newProduct.id = id
        
        do{
            try viewContext.save()
        }
        catch {
            let error = error as NSError
            fatalError("error addProduct: \(error)")
        }
    }
}


extension Store {
    
    func isPurchased(id: String) -> Bool {
      
        var isPurchased = false
        
        isPurchased = completedPurcheses.contains(id)
        
        return isPurchased
    }
    
    
    func product(for identifier: String) -> SKProduct? {
        return fetchedProducts.first(where: { $0.productIdentifier == identifier})
    }
    
    func purcheseProduct(_ product: SKProduct)  {
        srartObservingPaymentQueue()
        buy(product) { _ in
            
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension Store: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            
            var shouldFinishTrensaction = false
            
            switch transaction.transactionState {
            
//            case .purchasing:
//                <#code#>
            case .purchased, .restored:
                completedPurcheses.append(transaction.payment.productIdentifier)
                shouldFinishTrensaction = true
                addProduct(id: String(transaction.payment.productIdentifier))
            case .failed:
                shouldFinishTrensaction = true
//            case .restored:
//                <#code#>
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
            
            if shouldFinishTrensaction {
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.purchesCompletionHandler?(transaction)
                    self.purchesCompletionHandler = nil
                }
            }
            
        }
    }
    
    
}

extension Store: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let loadedProducts = response.products
        let invalidProducts = response.invalidProductIdentifiers
        
        guard !loadedProducts.isEmpty else {
            print("Could not load the porducts!")
            if !invalidProducts.isEmpty {
                print("Invalid Products found: \(invalidProducts)")
            }
            productsRequest = nil
            return
        }
        
        fetchedProducts = loadedProducts
        
        DispatchQueue.main.async {                  //DOTO: was macht das?????
            self.fetchCompletionHandler?(loadedProducts)
            self.fetchCompletionHandler = nil
            self.productsRequest = nil
        }
        
        
    }
}

