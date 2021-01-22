//
//  ContentView.swift
//  TODOFirestore
//
//  Created by Jigisha Patel on 2021-01-20.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State private var isLoggedOut : Bool = false
    @State private var isPresented : Bool = false
    @EnvironmentObject var taskController : TaskController
    
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(
                    destination: SignInView().environmentObject(taskController).navigationBarHidden(true),
                    isActive: $isLoggedOut,
                    label: {
                        
                    })
                
                List{
                    ForEach(self.taskController.taskList.enumerated().map({$0}), id: \.element.self){idx, task in
                        
                        NavigationLink(destination: SubCollectionListView(task: task).environmentObject(taskController), label: {
                            HStack{
                                Text("\(task.title)")
                                
                                Spacer()
                                
                                if (task.completion){
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.green)
                                }
                            }
                            .onTapGesture {
                                var tempTask = task
                                tempTask.completion.toggle()
                                self.taskController.updateTask(index: idx, task: tempTask)
                            }
                        })
                    }
                    .onDelete{indexSet in
                        for index in indexSet{
                            self.taskController.deleteTask(index: index)
                        }
                    }
                }
                    .navigationBarTitle("TODO", displayMode: .inline)
                    .navigationBarItems(trailing: Button(action:{
                        self.isPresented = true
                    }){
                        Image(systemName: "plus")
                            .resizable()
                            .padding()
                    }.sheet(isPresented: self.$isPresented){
                        AddTaskView(id: "")
                    }
                    )
                
                Button(action: {
                    self.onLogoutClick()
                }, label: {
                    Text("Log out")
                        .frame(width: 100, height: 50, alignment: .center)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .padding(.top, 30)
                        
                })
            }
        }
        .onAppear(){
            self.taskController.getAllTasks()
        }
    }
    
    private func onLogoutClick(){
        let firebaseAuth = Auth.auth()
       do {
         try firebaseAuth.signOut()
         print("User has logged out.")
         UserDefaults.standard.set(false, forKey: "isLoggedIn")
         self.isLoggedOut.toggle()
       } catch let signOutError as NSError {
         print ("Error signing out: %@", signOutError)
       }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
