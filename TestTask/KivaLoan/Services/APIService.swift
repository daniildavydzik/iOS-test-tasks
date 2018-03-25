//
//  APIService.swift
//  KivaLoan
//
//  Created by Daniel Davydzik on 24/03/2018.
//Copyright © 2018 DavydzikInc. All rights reserved.
import Foundation
class APIService : NSObject{
    let kivaURL  = "https://api.kivaws.org/v1/loans/newest.json"
    func getDataWith(completion : @escaping(Result <[[String : AnyObject]]>) -> Void) {
        guard let url = URL(string: kivaURL) else {return}
        let request = URLRequest.init(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {return completion(.Error(error!.localizedDescription))}
            
            guard let data = data else{return completion(.Error(error?.localizedDescription ?? "No new data to show!"))}
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]{
                    guard let jsonLoans = jsonResult["loans"] as? [[String  : AnyObject]] else{
                    return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
                }
                    DispatchQueue.main.async {
                        completion(.Success(jsonLoans))
                    }
                }
            } catch let error  {
                completion(.Error(error.localizedDescription))
            }
            
        }
    task.resume()
    }
    
    
}

enum Result<T>{
    case Success(T)
    case Error(String)
}
