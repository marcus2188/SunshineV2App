//
//  answerrow.swift
//  SunshineV2App
//
//  Created by Ksk I on 19/5/22.
//

import SwiftUI

struct answerrow: View {
    @State public var isSelected: Bool = false
    @Binding var answerChosen: Bool
    var ans: answer
    var green = Color(hue: 0.437, saturation: 0.711, brightness: 0.711)
    var red = Color(red: 0.71, green: 0.094, blue: 0.1)
    
    var body: some View {
        HStack(spacing: 20){
            Image(systemName: "circle.fill").font(.caption)
            Text(ans.anstext).bold()
            if isSelected{
                Spacer()
                Image(systemName: ans.isCorrect ? "checkmark.circle.fill" : "x.circle.fill").foregroundColor( ans.isCorrect ? green : red)
            }
        }.padding().frame(maxWidth: .infinity, alignment: .leading).foregroundColor(isSelected ?  Color("AccentColor") : Color.gray).background(Color.white).cornerRadius(10).shadow(color: isSelected ? (ans.isCorrect ? green : red) : Color.gray, radius: 5, x: 0.5, y: 0.5).onTapGesture {
                isSelected = true
                answerChosen = true
                if ans.isCorrect{
                    
                }
            }
    }
}

struct answerrow_Previews: PreviewProvider {
    static var previews: some View {
        answerrow(answerChosen: Binding.constant(true), ans: answer(anstext: "Hello there", isCorrect: true))
    }
}
