//
//  CQZPurchaseManager.swift
//  CQZPurchaseManager
//
//  Created by Christian Quicano on 5/16/16.
//  Copyright © 2016 ca9z. All rights reserved.
//

import Foundation
import StoreKit

public class CQZPurchaseManager:NSObject {
    
    //MARK:- public properties
    public static let shared = CQZPurchaseManager()
    public var productsIdsList:[String] {
        get{
            return Array(productsIdsListSet)
        }
        set{
            productsIdsListSet = Set(newValue)
            loadProducts()
        }
    }
    public private(set) var productsList = [SKProduct]()
    
    //MARK:- privates properties
    private var productsIdsListSet = Set<String>()
    private var productRestore:((identifier:String)->())?
    
    //MARK:- public func
    public func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchasedProducts(productRestore:(identifier:String)->()) {
        self.productRestore = productRestore
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    //MARK:- private func
    private func loadProducts() {
        let productsRequest = SKProductsRequest(productIdentifiers: productsIdsListSet)
        productsRequest.delegate = self
        productsRequest.start()
        //set the delegate to the payment
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        
    }
    
    //MARK: - override methods
    private override init() {
        super.init()
    }
    
}

extension CQZPurchaseManager:SKProductsRequestDelegate {
    //obtener la lita de productos
    public func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        productsList = response.products
    }
}

extension CQZPurchaseManager:SKPaymentTransactionObserver {
    public func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .Failed:
                print("fallo la compra")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                break
            case .Purchasing:
                break
            case .Purchased:
                print("comprado: \(transaction.payment.productIdentifier)")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                break
            case .Restored:
                productRestore?(identifier: transaction.payment.productIdentifier)
                //                print("restaurado: \(transaction.payment.productIdentifier)")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                break
            case .Deferred:
                break
            }
        }
        
    }
    
}