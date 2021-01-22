//
//  TaskController.swift
//  TODOFirestore
//
//  Created by Jigisha Patel on 2021-01-20.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class TaskController: ObservableObject{
    @Published var taskList = [TaskMO]()
    @Published var subTaskList = [TaskMO]()
    
    private let COLLECTION_TASK : String = "Tasks"
    private let SUB_COLLECTION_TASK : String = "SubTasks"
    
    let store : Firestore
    
    init(database: Firestore){
        self.store = database
    }
    
    func insertTask(newTask: TaskMO){
        do{
            _ = try self.store.collection(COLLECTION_TASK).addDocument(from: newTask)
        }catch let error as NSError{
            print(#function, "Error inserting task", error)
        }
    }
    
    
    func insertSubTask(id : String, newTask: TaskMO){
        do{
            _ = try self.store.collection(COLLECTION_TASK).document(id).collection(SUB_COLLECTION_TASK).addDocument(from: newTask)
        }catch let error as NSError{
            print(#function, "Error inserting task", error)
        }
    }
    
    func updateTask(index: Int, task: TaskMO){
        self.store.collection(COLLECTION_TASK)
            .document(self.taskList[index].id!)
            .updateData(["completion" : task.completion]){ error in
                if let error = error{
                    print(#function, error)
                }else{
                    print(#function, "Document updated successfully")
                }
            }
    }
    
    func deleteTask(index: Int){
        self.store.collection(COLLECTION_TASK)
            .document(self.taskList[index].id!)
            .delete{error in
                if let error = error{
                    print(#function, error)
                }else{
                    print(#function, "Document successfully deleted")
                }
            }
    }
    
    func getAllSubTasks(id : String){
        self.subTaskList.removeAll()
        self.store.collection(COLLECTION_TASK).document(id).collection(SUB_COLLECTION_TASK)
            .addSnapshotListener({ [self] (querySnapshot, error) in
                
                guard let snapshot = querySnapshot else{
                    print(#function, "Error fetching snapshot results", error)
                    return
                }
                snapshot.documentChanges.forEach{ doc in
                    var task = TaskMO()
                    do{
                        task = try doc.document.data(as: TaskMO.self)!
                        
                        if doc.type == .added{
                            self.subTaskList.append(task)
                        }
                    }catch{
                        print(error)
                    }
                }
                
            })
    }
    
    func getAllTasks(){
        self.taskList.removeAll()
        self.store.collection(COLLECTION_TASK)
            .order(by: "title", descending: true)
            .addSnapshotListener({ [self] (querySnapshot, error) in
                
                guard let snapshot = querySnapshot else{
                    print(#function, "Error fetching snapshot results", error)
                    return
                }
                
                snapshot.documentChanges.forEach{ (doc) in
                    var task = TaskMO()
                    
                    do{
                        task = try doc.document.data(as: TaskMO.self)!
                        
                        if doc.type == .added{
                            self.taskList.append(task)
                        }
                        
                        if doc.type == .modified{
                            let docID = doc.document.documentID
                            
                            let matchedTaskIndex = self.taskList.firstIndex(where: {
                                ($0.id?.elementsEqual(docID))!
                            })
                            
                            if (matchedTaskIndex != nil){
                                self.taskList[matchedTaskIndex!] = task
                            }
                        }
                        
                        if doc.type == .removed{
                            let docID = doc.document.documentID
                            
                            let matchedTaskIndex = self.taskList.firstIndex(where: {
                                ($0.id?.elementsEqual(docID))!
                            })
                            
                            if (matchedTaskIndex != nil){
                                self.taskList.remove(at: matchedTaskIndex!)
                            }
                        }
                        
                    }catch let error as NSError{
                        print(#function, error)
                    }
                }
                
            })
    }
    
}
