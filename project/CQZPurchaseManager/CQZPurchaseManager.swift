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
    
    //MARK: - Singleton
    public static let shared = CQZPurchaseManager()
    
    private let identifiers = Set(arrayLiteral: "ejemplopurchase_retirar_publicidad")
    
    //MARK: - public properties
    public var products = [SKProduct]()
    
    //MARK: - public methods
    private func loadProducts() {
        let requestProducts = SKProductsRequest(productIdentifiers: identifiers)
        requestProducts.delegate = self
        requestProducts.start()
    }
    
    public func restoreProducts() {
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    public func canPayment() -> Bool{
        return SKPaymentQueue.canMakePayments()
    }
    
    //MARK: - override methods
    private override init() {
        super.init()
    }
    
}

extension CQZPurchaseManager:SKProductsRequestDelegate {
    
    public func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        
        products = response.products
        
    }
    
}

extension CQZPurchaseManager:SKPaymentTransactionObserver {
    
    public func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            let state = transaction.transactionState
            
            switch state {
            case .Purchasing:
                break
            case .Failed:
                print("fallo")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                break
            case .Purchased:
                print("item comprado: \(transaction.payment.productIdentifier)")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                break
            case .Restored:
                print("item restaurado: \(transaction.payment.productIdentifier)")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                break
            case .Deferred:
                break
            }
            
        }
        
    }
    
}