//
//  MainView.swift
//  TODOFirestore
//
//  Created by Work on 2021-01-21.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var taskController : TaskController
    
    var body: some View {
        if(UserDefaults.standard.bool(forKey: "isLoggedIn")){
            ContentView().environmentObject(taskController)
        }else{
            SignInView().environmentObject(taskController)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
