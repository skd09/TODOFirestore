//
//  TaskMO.swift
//  TODOFirestore
//
//  Created by Jigisha Patel on 2021-01-20.
//

import Foundation
import FirebaseFirestoreSwift

struct TaskMO : Codable, Identifiable, Hashable{
    @DocumentID var id : String? = UUID().uuidString
    var title : String = ""
    var completion : Bool = false
    
    init() {}
    
    init(title: String, completion: Bool) {
        self.title = title
        self.completion = completion
    }
}

extension TaskMO{
    init?(dictionary: [String : Any]) {
        
        guard let title = dictionary["title"] as? String else{
            return nil
        }
        
        guard let completion = dictionary["completion"] as? Bool else {
            return nil
        }
        
        self.init(title: title, completion: completion)
    }
}
