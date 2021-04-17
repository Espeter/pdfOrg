////
////  StoreView.swift
////  pdfOrg
////
////  Created by Carl Espeter on 03.04.21.
////
//
//import SwiftUI
//
//struct StoreView: View {
//    
//    @EnvironmentObject private var store: Store
//    
//    var body: some View {
//        NavigationView(){
//            VStack{
//                HStack{
//                    Text("LS_Unlimited number of books" as LocalizedStringKey).foregroundColor(.black)
//                    Button(action: {
//                        store.purcheseProduct(store.product(for: Store.Prodakt.unlimitedBooks.rawValue)!)
//                    }, label: {
//                        Text("LS_Buy" as LocalizedStringKey).padding()
//                    })
//                }
//                Button(action: {
//                    store.restorePurchases()
//                }, label: {
//                    Text("LS_Restore Purchases" as LocalizedStringKey).padding()
//                })
//            }.padding()
//            
//            .navigationBarTitle("LS_Store" as LocalizedStringKey)
//        }
//    }
//}
