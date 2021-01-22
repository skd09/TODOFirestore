//
//  AddTaskView.swift
//  TODOFirestore
//
//  Created by Jigisha Patel on 2021-01-20.
//

import SwiftUI

struct AddTaskView: View {
    @State private var newTaskTitle : String = ""
    @EnvironmentObject var taskController : TaskController
    @Environment(\.presentationMode) var presentationMode
    var id : String
    
    
    var body: some View {
        VStack{
            Text("Add item to the list")
                .bold()
                .font(.system(size: 30))
                
            
            TextField("Task title", text: self.$newTaskTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top, 30)
            
            Button(action:{
                
                if(id.isEmpty){
                    //insert the task on Firestore
                    self.taskController.insertTask(newTask: TaskMO(title: self.newTaskTitle, completion: false))
                    
                }else{
                    let taskMO = TaskMO(title: self.newTaskTitle, completion: false)
                    self.taskController.insertSubTask(id: id, newTask: taskMO)
                }
                
                
                //to dismiss the View from screen and navigation stack
                self.presentationMode.wrappedValue.dismiss()
            }){
                Text("Add Task")
                    .frame(width: 100, height: 50, alignment: .center)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .padding(.top, 30)
            }
            Spacer()
        }.padding()
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(id: "")
    }
}
