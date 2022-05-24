//
//  primarybutton.swift
//  SunshineV2App
//
//  Created by Ksk I on 17/5/22.
//

import SwiftUI

struct primarybutton: View {
    var buttontext: String
    var buttoncolor: Color = Color("AccentColor")
    
    var body: some View {
        Text(buttontext).foregroundColor(.white).padding().padding(.horizontal).background(buttoncolor).cornerRadius(20)
    }
}

struct primarybutton_Previews: PreviewProvider {
    static var previews: some View {
        primarybutton(buttontext: "hi")
    }
}
