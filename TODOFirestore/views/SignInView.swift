//
//  SignInView.swift
//  TODOFirestore
//
//  Created by Work on 2021-01-21.
//

import SwiftUI
import Firebase


struct SignInView: View {
    
    @State private var tfEmail : String = "sharvarid94@gmail.com"
    @State private var tfPassword : String = "Sharvari@123"
    @State private var isLogin : Bool = false
    @EnvironmentObject var taskController : TaskController
    
    
    var body: some View {
        
        NavigationView{
            VStack{
                NavigationLink(
                    destination: ContentView().environmentObject(taskController).navigationBarHidden(true),
                    isActive: $isLogin,
                    label: {
                        
                    })
                
                Text("Sign In")
                    .bold()
                    .font(.system(size: 30))
                
                TextField("Enter email", text: $tfEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 30)
                
                SecureField("Enter password", text: $tfPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    self.onSubmitClick()
                }, label: {
                    Text("Submit")
                        .frame(width: 100, height: 50, alignment: .center)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .padding(.top, 30)
                        
                })
                Spacer()
            }.padding()
             .navigationBarHidden(true)
        }
    }
    
    private func onSubmitClick(){
        Auth.auth().signIn(withEmail: self.tfEmail, password: self.tfPassword) { (authData, error) in
            if let error = error {
                print(error)
                return
            }else{
                if((authData?.user.isEmailVerified) != nil){
                    print("Login Successful")
                    self.isLogin.toggle()
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                }
            }
        }
    }
    
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
