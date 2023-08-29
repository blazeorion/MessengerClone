//
//  LoginFirebaseView.swift
//  Laugh Yourself Well
//
//  Created by Blaze Dowis on 6/24/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
        @State var email = ""
        @State var password = ""
        @State var showPassword: Bool = false
        @State var pushActive = false
    
        @EnvironmentObject var viewModel: AuthViewModel
    
        var isSignInButtonDisabled: Bool {
            [email, password].contains(where: \.isEmpty)
        }
        var body: some View {
            
            VStack {
                ZStack {
                    VStack(spacing: 15){
                        
                        Image("circles").resizable()
                            .aspectRatio(contentMode: .fit)
                        Spacer()
                        
                        Text("Sign In")
                            .bold()
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                            .frame(width: 200)
                            .multilineTextAlignment(.center)
                        Spacer()
                        
                        InputView(text: $email, placeholder: "Email").autocapitalization(.none)
                        
                        HStack {
                            InputView(text: $password, placeholder: "Password", isSecureField: true, showPassword: showPassword)

                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.black)
                            }

                        }
                        
                        Spacer()
                        
                        //login to home view
                        Button {
                            Task{
                               try await viewModel.signIn(withEmail:email,password:password)
                            }
                        } label: {
                            Text("Sign In")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                        }
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color("AccentColor"))
                        .cornerRadius(15)
                        .disabled(!formIsValid)
                        .opacity(formIsValid ? 1.0 : 0.5)
                        
                    }
                }.padding()
            }
        }

        func login() {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                } else {
                    print("success")
                    self.pushActive = true
                    print("handleSuccessfullLogin")
                }
            }
        }
}

extension LoginFirebaseView: AuthenticationFormProtocol{
    var formIsValid: Bool{
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        
    }
}

struct LoginFirebaseView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFirebaseView()
    }
}
