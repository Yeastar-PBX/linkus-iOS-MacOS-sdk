//
//  SearchBar.swift
//  Linkus
//
//  Created by 杨桂福 on 2022/10/19.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var popover: Bool
    @State private var showT = ""
    @State private var isEditing = false
    
    @FocusState private var isFocus: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray).font(.headline)
            TextField("Search", text: $searchText)
                .textFieldStyle(.plain)
                .submitLabel(.done)
                .onSubmit {
                    showT = searchText
                    isFocus = true
                    popover = true
                }
                .onChange(of: searchText) { newValue in
                    searchText = String(newValue.prefix(20)) // 限制字数
                }
            Image(systemName: "multiply.circle.fill")
                .foregroundColor(.gray)
                .font(.headline)
                .onTapGesture {
                    self.searchText = ""
                }
        }
        .padding(6)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(.gray, lineWidth: 1)
        )
        .padding(.horizontal)
        .frame(width: 200, height: 28)
    }
}

struct SearchBar:View{
    @State var searchStr = ""
    @Binding var isFocused:Bool
    var body: some View{
        HStack{
            Image(systemName: "magnifyingglass")
            MyTextField(text: self.$searchStr,isFocused: self.$isFocused)
        }
        .frame(width: 200, height: 28)
    }
}

struct MyTextField: NSViewRepresentable {
    @Binding var text: String
    @Binding var isFocused: Bool
   // var tf = NSTextField()
    var tf = FocusingTextField()
    func makeNSView(context: NSViewRepresentableContext<MyTextField>) -> NSTextField {

       // tf.focusRingType = .none
       //tf.isBordered = false
        tf.drawsBackground = true
        tf.delegate = context.coordinator
        tf.focueseDelegate = context.coordinator
        
        return tf
    }
    func updateNSView(_ nsView: NSTextField, context: NSViewRepresentableContext<MyTextField>) {
        nsView.stringValue = text
    }
    func makeCoordinator() -> MyTextField.Coordinator {
        Coordinator(parent: self)
    }
    class Coordinator: NSObject, NSTextFieldDelegate ,TextFieldFocusedDelegate {
        let parent: MyTextField
        init(parent: MyTextField) {
            self.parent = parent
        }
       
        func controlTextDidChange(_ obj: Notification) {
            let textField = obj.object as! NSTextField
            parent.text = textField.stringValue
            print("3333")
        }
        func updateFocused(isFocused:Bool){
            self.parent.isFocused = isFocused
        }

    }
}

public protocol TextFieldFocusedDelegate  {
    func updateFocused(isFocused:Bool) -> Void
}




class FocusingTextField : NSTextField {
    var isFocused : Bool = false
    var focueseDelegate:TextFieldFocusedDelegate?
    
    override func becomeFirstResponder() -> Bool {
        let orig = super.becomeFirstResponder()
        if(orig) {
            self.isFocused = true
        }
        self.focueseDelegate!.updateFocused(isFocused: self.isFocused)
        return orig
    }
    
    override func textDidEndEditing(_ notification: Notification) {
        super.textDidEndEditing(notification)
        self.isFocused = false
        self.focueseDelegate!.updateFocused(isFocused: self.isFocused)
        print("1111")
    }

    override func selectText(_ sender: Any?) {
        super.selectText(sender)
        self.isFocused = true
        self.focueseDelegate!.updateFocused(isFocused: self.isFocused)
        print("2222")
    }

}

