//
//  commentView.swift
//  morpion
//
//  Created by Daniel Monteiro on 14/09/2023.
//
import SwiftUI


struct commentView: View{
    @State var firstName : String
    @State var lastName : String
    @State var grade : Int
    @State var showAlert : Bool
    @State var message : String
    @State var canClear = false
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("First Name", text: $firstName)
                        .autocapitalization(.words)
                    TextField("Last Name", text: $lastName)
                        .autocapitalization(.words)
                }
                HStack{
                    ForEach(1..<6) { index in
                        Image(systemName: index <= grade ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .onTapGesture {
                                self.grade = index
                                
                            }
                    }
                }
                Section {
                    Button(action: {
                        showAlert = true
                        if(!firstName.isEmpty && !lastName.isEmpty && grade > 1){
                            sendGETRequest(firstName: firstName, lastName: lastName, grade: grade)
                            message = "Thank you for your contribution"
                            canClear = true
                        }
                        if(grade <= 1){
                            
                            message = "Please put at least one star"
                        }
                        if(firstName.isEmpty || lastName.isEmpty){
                            message+="Please fill your name"
                        }
                        
                    }) {
                        Text("Send Review")
                    }.alert(message, isPresented: $showAlert) {
                        Button("OK", role: .cancel) {
                            if(canClear){
                                firstName = ""
                                lastName = ""
                                grade = 0
                                showAlert = false
                                message = ""
                                canClear = false
                                
                            }
                            
                        }
                    }
                }
                
            }
            .navigationBarTitle("Review Tic Tac Toe 🕹️")
        }
    }
}


struct commentView_Previews: PreviewProvider {
    static var previews: some View {
        commentView(firstName : "", lastName : "", grade : 0, showAlert: false, message: "", canClear: false)
    }
}


func sendGETRequest(firstName : String, lastName : String, grade : Int) -> Bool{
    var returnValue = false
    let urlString = "https://reviewstitactoe.daniel-monteiro.fr/sendReview.php?firstName=\(firstName)&lastName=\(lastName)&grade=\(grade)"
    
    if let url = URL(string: urlString) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let responseString = String(data: data, encoding: .utf8) {
                        DispatchQueue.main.async {
                            if (responseString=="done") {
                                returnValue = true
                            } else {
                                returnValue = false
                            }
                        }
                    }
                }
            } else {
                // Gérer l'erreur réseau ou les données vides ici
                returnValue = false
            }
        }
        task.resume()
    } else {
        // Gérer l'URL invalide ici
        returnValue = false
    }
    return returnValue
}

