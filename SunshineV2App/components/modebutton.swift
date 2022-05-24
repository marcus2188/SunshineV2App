//
//  modebutton.swift
//  SunshineV2App
//
//  Created by Ksk I on 17/5/22.
//

import SwiftUI

struct modebutton: View {
    var buttontext: String
    var buttonbgname: String
    var body: some View {
        ZStack(){
            Image(buttonbgname).resizable().colorMultiply(Color(red: 0.8, green: 0.8, blue: 0.8, opacity: 1)).cornerRadius(30)
            Text(buttontext).font(.title).foregroundColor(.white).fontWeight(.heavy)
        }.frame(maxWidth: 300, maxHeight: 80)
    }
}

struct modebutton_Previews: PreviewProvider {
    static var previews: some View {
        modebutton(buttontext: "Hi there", buttonbgname: "classicmode")
    }
}
