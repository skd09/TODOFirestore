//
//  SubCollectionListView.swift
//  TODOFirestore
//
//  Created by Work on 2021-01-21.
//

import SwiftUI

struct SubCollectionListView: View {
    
    var task : TaskMO
    @EnvironmentObject var taskController : TaskController
    @State private var isPresented : Bool = false
    
    var body: some View {
        VStack{
            Text(task.title)
                .bold()
                .font(.system(size: 30))
                .padding(.top, 30)
            
            List(self.taskController.subTaskList, id : \.self) { item in
                HStack{
                    
                    Text(item.title)
                    
                    Spacer()
                    
                    if (item.completion){
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                    }
                }
            }.sheet(isPresented: self.$isPresented){
                AddTaskView(id: task.id!)
            }
            
            Button(action: {
                self.isPresented = true
            }, label: {
                Text("Add Item")
            })
            
        }.onAppear(){
            self.taskController.getAllSubTasks(id: task.id!)
        }
    }
}

struct SubCollectionListView_Previews: PreviewProvider {
    static var previews: some View {
        SubCollectionListView(task: TaskMO())
    }
}
