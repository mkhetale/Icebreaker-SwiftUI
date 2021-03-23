//
//  ContentView.swift
//  Icebreaker-SwiftUI
//
//  Created by Mihir Khetale on 3/2/21.
//

import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    let db = Firestore.firestore()
    
    @State var questions = [Question]()
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var preferredName: String = ""
    @State var answer: String = ""
    @State var question: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Icebreaker")
                .font(.system(size:40))
                .bold()
            Text("Built with SwiftUI")
                .font(.system(size:30))
                .bold()
            TextField("First Name", text: $firstName)
                .font(.largeTitle)
                .disableAutocorrection(true)
            TextField("Last Name", text: $lastName)
                .font(.largeTitle)
                .disableAutocorrection(true)
            TextField("Preferred Name", text: $preferredName)
                .font(.largeTitle)
                .disableAutocorrection(true)
            Button(action: {
                setRandomQuestion()
            }) {
                Text("Get a new random question")
                    .font(.system(size:28))
            }
            Text(question)
                .font(.system(size:30))
            TextField("Answer", text: $answer)
                .font(.largeTitle)
                .disableAutocorrection(true)
            Button(action: {
                submit()
            }) {
                Text("Submit")
                    .font(.system(size:28))
            }
        }
        .padding(30)
        .onAppear(perform: getQuestionsFromFirebase)
    }
    
    func getQuestionsFromFirebase() {
        db.collection("questions")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if let question = Question(id: document.documentID, data: document.data()) {
                            print("Retrieved question: id = \(question.id), text = \(question.text)")
                            self.questions.append(question)
                        }
                    }
                }
            }
    }
    func setRandomQuestion() {
        question = questions.randomElement()!.text
    }
    func submit() {
        writeStudentToFirebase()
        resetTextFields()
    }
    func writeStudentToFirebase() {
        let data = ["first_name": firstName,
                    "last_name": lastName,
                    "preferred_name": preferredName,
                    "question": question,
                    "answer": answer,
                    "class": "ios-spring21"]
            as [String: Any]
        
        var ref: DocumentReference? = nil
        ref = db.collection("students").addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
            
        }
    }
    func resetTextFields() {
        firstName = ""
        lastName = ""
        preferredName = ""
        answer = ""
        question = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
