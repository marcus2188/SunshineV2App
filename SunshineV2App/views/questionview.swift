//
//  questionview.swift
//  SunshineV2App
//
//  Created by Ksk I on 17/5/22.
//

import SwiftUI
import FirebaseCore

struct questionview: View {
    @ObservedObject var gs: gamestate
    @ObservedObject var fb = fblang()
    @State var chosenAnsStatus: Int = 0   // 0 for not answered, -1 for wrong answer chosen, 1 for correct
    @State var curscore: Int = 0   // starts from 0
    @State var curqnnumber: Int = 1   // starts from 1
    @State var qnChanged: Bool = false
    @State var answeredQnslist: [String] = [String]()
    @State var livesRemaining: Int = 3    // for classic mode
    
    init(gs: gamestate){
        self.gs = gs
//        FirebaseApp.configure()
        fb.getData(selectedLanguage: gs.lang)
    }
    func processQnAns() -> some View{   // multi-mode function
        // Choose 10 elements from the langitemlist to do main loop for main questions
        let chosenlangitemsarray = Array(fb.langitemlist[0..<10])
        // Get all the other langitems excluding the current one
        let otherlangitemsarray = Array(fb.langitemlist[1...])
    
        // init empty list of strings for answers
        var anslist: [String] = []
        // append to answers list for other answers
        for g in 0..<4{
            anslist.append(otherlangitemsarray[fb.otherOptionsIndex[g]].english)
        }
        // append correct answer to answer list, and shuffle the list
        anslist.insert(chosenlangitemsarray[0].english, at: fb.randomInsertionIndex)
        
        // check there is no multiple correct answers inside anslist
        var duplist: [String] = []
        var otherincrementer: Int = 4
        while Set(anslist).count != anslist.count{
            duplist.removeAll()
            anslist.forEach{e in
                if !duplist.contains(e){
                    duplist.append(e)
                }else{
                    // duplicate ans found, remove it, sub in another option at that index
                    if let i = anslist.firstIndex(of: e){
                        anslist[i] = otherlangitemsarray[fb.otherOptionsIndex[otherincrementer]].english
                    }
                    otherincrementer += 1
                }
            }
        }
        
        // return some view back, split up classic/zen from oddoneout mode
        return VStack(alignment: .center, spacing: 20){
            Text(chosenlangitemsarray[0].native).font(.title).bold().foregroundColor(gs.mode==modetype.ZEN ? .black : Color(0xE39FF6))
            Text(chosenlangitemsarray[0].pronunciation).font(.title).foregroundColor(gs.mode==modetype.ZEN ? .gray : Color.white)
            ForEach(0..<anslist.count){ind in
                HStack(spacing: 20){
                    Image(systemName: "circle.fill").font(.caption)
                    Text(anslist[ind]).bold()
                    if chosenAnsStatus == 1 || chosenAnsStatus == -1{
                        Spacer()
                        Image(systemName: anslist[ind]==chosenlangitemsarray[0].english ? "checkmark.circle.fill" : "x.circle.fill").foregroundColor(anslist[ind]==chosenlangitemsarray[0].english ? Color.green : Color.red)
                    }
                }.padding().frame(maxWidth: .infinity, alignment: .leading).foregroundColor( Color.gray).background(Color.white).cornerRadius(10).shadow(color: chosenAnsStatus==0 ? Color.gray : anslist[ind]==chosenlangitemsarray[0].english ? Color.green : Color.red, radius: 5, x: 0.5, y: 0.5).onTapGesture {
                        if anslist[ind]==chosenlangitemsarray[0].english{
                            chosenAnsStatus = 1
                            curscore += 1
                        }else{
                            chosenAnsStatus = -1
                            livesRemaining -= 1
                        }
                }.disabled(chosenAnsStatus != 0)
            }
            
        }
    }
    func processOddoneout() -> some View{  // func exclusively for odd one out
        let chosenlangitemsarray = Array(fb.langitemlist[0..<6])    // pick 6 questions
        let otherlangitemsarray = Array(fb.langitemlist[6...])  // dump out other options as well
        
        // pick the first lang item in the others pile, take its english, check if its english already exists in the chosen 6, then using the randominsertionindex check if the replaced item is already correct with that english. If so, take next lang item in others pile and try again. If the english makes the replaced item wrong, accept it and replace heading in that option box. One option box has 1 native and its pronunciation, and 1 english which may be right or wrong.
        
        // check if there is repeat english between chosen 6 and the replacer lang item
        var incrementer: Int = 0
        var accessorindex: Int = 0
        while accessorindex < 6{
            if chosenlangitemsarray[accessorindex].english == otherlangitemsarray[incrementer].english{
                incrementer += 1
                accessorindex = 0
            }else{
                accessorindex += 1
            }
        }
        // check if the one we wanna replace, is the same correct answer already
        while chosenlangitemsarray[fb.randomReplacementIndexOdd].english == otherlangitemsarray[incrementer].english{
            incrementer += 1
        }
        
        // do the replacement and return that view
        
        // return some view back, split up classic/zen from oddoneout mode
        return VStack(alignment: .center, spacing: 20){
            ForEach(0..<chosenlangitemsarray.count){ind in
                if ind == fb.randomReplacementIndexOdd{
                    HStack(spacing: 20){
                        Image(systemName: "circle.fill").font(.caption)
                        VStack(alignment: .leading){
                            Text(chosenlangitemsarray[ind].native).bold()
                            Text(chosenlangitemsarray[ind].pronunciation)
                            Text(otherlangitemsarray[incrementer].english).bold().foregroundColor(Color.black)
                        }
                        if chosenAnsStatus == 1 || chosenAnsStatus == -1{
                            Spacer()
                            Image(systemName: "checkmark.circle.fill").foregroundColor(Color.green)
                        }
                    }.padding().frame(maxWidth: .infinity, alignment: .leading).foregroundColor( Color.gray).background(Color.white).cornerRadius(10).shadow(color: chosenAnsStatus==0 ? Color.gray : Color.green, radius: 5, x: 0.5, y: 0.5).onTapGesture {
                            chosenAnsStatus = 1
                            curscore += 1
                            
                    }.disabled(chosenAnsStatus != 0)
                }else{
                    HStack(spacing: 20){
                        Image(systemName: "circle.fill").font(.caption)
                        VStack(alignment: .leading){
                            Text(chosenlangitemsarray[ind].native).bold()
                            Text(chosenlangitemsarray[ind].pronunciation)
                            Text(chosenlangitemsarray[ind].english).bold().foregroundColor(Color.black)
                        }
                        if chosenAnsStatus == 1 || chosenAnsStatus == -1{
                            Spacer()
                            Image(systemName: "x.circle.fill").foregroundColor(Color.red)
                        }
                    }.padding().frame(maxWidth: .infinity, alignment: .leading).foregroundColor( Color.gray).background(Color.white).cornerRadius(10).shadow(color: chosenAnsStatus==0 ? Color.gray : Color.red, radius: 5, x: 0.5, y: 0.5).onTapGesture {
                            chosenAnsStatus = -1
                            livesRemaining -= 1
                            
                    }.disabled(chosenAnsStatus != 0)
                }
                
            }
            
        }
    }
    
    var body: some View {
        NavigationView{
            if gs.mode == modetype.ZEN{
                VStack(spacing: 50){
                    Spacer()
                    VStack(alignment: .center){
                        Text(String(describing: gs.mode) + " Mode").screenmaintitle().foregroundColor(Color("AccentColor"))
                        Text("Qn " + String(curqnnumber) + " of 10").screensubtitle().foregroundColor(Color("AccentColor"))
                        Text("Score: " + String(curscore)).font(.headline)
                    }
                    progressbar(progress: CGFloat(curqnnumber*350/10), desiredColor: Color("AccentColor"))
                    if curqnnumber >= 0{
                        processQnAns()
                    }
                    if curqnnumber >= 10{
                        NavigationLink(destination: gameoverview(gs: gs, yourscore: curscore)){
                            primarybutton(buttontext: "End Game").disabled(chosenAnsStatus==0)
                        }
                    }else{
                        if chosenAnsStatus != 0{
                            primarybutton(buttontext: "Next").onTapGesture {
                                // check if list is empty, if not shuffle the remaining based on language and make sure no repeat questions, shuffle the other options as well, increment qn number and reset answer statuses
                                if fb.langitemlist.isEmpty{
                                    print("EMPTIED DB")
                                }else{
                                    fb.langitemlist.shuffle()
                                    // make sure chosen lang item is not repeated, if so then keep right shifting until 1st element is not inside answered qn list. If not repeated, add it into that list
                                    while answeredQnslist.contains(fb.langitemlist[0].native){
                                        fb.langitemlist.shiftRight()
                                    }
                                    // Put current qn into answered qn list
                                    answeredQnslist.append(fb.langitemlist[0].native)
                                    
                                    fb.randomInsertionIndex = [[0,1,2,3].endIndex, 0, 1, 2, 3].shuffled()[0]
                                    if gs.lang == languagetype.ALL{
                                        fb.otherOptionsIndex = (0..<46-1).shuffled()
                                    }else{
                                        if gs.lang == languagetype.KOREAN{
                                            fb.otherOptionsIndex = (0..<14-1).shuffled()
                                        }else{
                                            if gs.lang == languagetype.SPANISH{
                                                fb.otherOptionsIndex = (0..<16-1).shuffled()
                                            }else{
                                                if gs.lang == languagetype.CHINESE{
                                                    fb.otherOptionsIndex = (0..<16-1).shuffled()
                                                }
                                            }
                                        }
                                    }
                                    
                                    curqnnumber += 1
                                    chosenAnsStatus = 0
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                }.padding().frame(maxWidth: .infinity, maxHeight: .infinity).background(Color(red: 0.984, green: 0.929, blue: 0.847)).edgesIgnoringSafeArea(.all).navigationBarHidden(true)
            }else{
                if gs.mode == modetype.CLASSIC{
                    VStack{
                        Spacer()
                        VStack(alignment: .center){
                            Text(String(describing: gs.mode) + " Mode").screenmaintitle().foregroundColor(Color.white)
                            Text("Qn " + String(curqnnumber)).screensubtitle().foregroundColor(Color.white)
                            Text("Score: " + String(curscore)).font(.headline).foregroundColor(Color.white)
                        }
                        progressbar(progress: 350, desiredColor: Color(0xE39FF6))
                        Text(String(livesRemaining) + " lives remaining").foregroundColor(livesRemaining==3 ? Color.green : livesRemaining==2 ? Color.orange : livesRemaining==1 ? Color.red : Color.black)
                        Spacer()
                        if curqnnumber >= 0{
                            processQnAns()
                        }
                        Spacer()
                        if chosenAnsStatus != 0{
                            if livesRemaining == 0{
                                NavigationLink(destination: gameoverview(gs: gs, yourscore: curscore)){
                                    primarybutton(buttontext: "Game Over")
                                }
                            }else{
                                primarybutton(buttontext: "Next").onTapGesture {
                                    // check if list is empty, if not shuffle the remaining based on language and make sure no repeat questions, shuffle the other options as well, increment qn number and reset answer statuses
                                    if fb.langitemlist.isEmpty{
                                        print("EMPTIED DB")
                                    }else{
                                        fb.langitemlist.shuffle()
                                        // make sure chosen lang item is not repeated, if so then keep right shifting until 1st element is not inside answered qn list. If not repeated, add it into that list
                                        // if all qn answered in db, print
                                        if answeredQnslist.count == fb.langitemlist.count{
                                            print("all qn answered")
                                            answeredQnslist.removeAll()
                                        }
                                        while answeredQnslist.contains(fb.langitemlist[0].native){
                                            fb.langitemlist.shiftRight()
                                        }
                                        // Put current qn into answered qn list
                                        answeredQnslist.append(fb.langitemlist[0].native)
                                        
                                        
                                        
                                        fb.randomInsertionIndex = [[0,1,2,3].endIndex, 0, 1, 2, 3].shuffled()[0]
                                        if gs.lang == languagetype.ALL{
                                            fb.otherOptionsIndex = (0..<46-1).shuffled()
                                        }else{
                                            if gs.lang == languagetype.KOREAN{
                                                fb.otherOptionsIndex = (0..<14-1).shuffled()
                                            }else{
                                                if gs.lang == languagetype.SPANISH{
                                                    fb.otherOptionsIndex = (0..<16-1).shuffled()
                                                }else{
                                                    if gs.lang == languagetype.CHINESE{
                                                        fb.otherOptionsIndex = (0..<16-1).shuffled()
                                                    }
                                                }
                                            }
                                        }
                                        
                                        curqnnumber += 1
                                        chosenAnsStatus = 0
                                    }
                                }
                            }
                            
                        }
                        Spacer()
                    }.padding().frame(maxWidth: .infinity, maxHeight: .infinity).background(Color(0x601A35)).edgesIgnoringSafeArea(.all).navigationBarHidden(true)
                }else{
                    if gs.mode == modetype.ODDONEOUT{
                        VStack{
                            Spacer()
                            VStack(alignment: .center){
                                Text(String(describing: gs.mode) + " Mode").screenmaintitle().foregroundColor(Color.black)
                                Text("Score: " + String(curscore)).font(.headline).foregroundColor(Color.black)
                            }
                            Text(String(livesRemaining) + " lives remaining").foregroundColor(livesRemaining==3 ? Color.green : livesRemaining==2 ? Color.orange : livesRemaining==1 ? Color.red : Color.black)
                            if curqnnumber >= 0{
                                processOddoneout()
                            }
                            Spacer()
                            if chosenAnsStatus != 0{
                                if livesRemaining == 0{
                                    NavigationLink(destination: gameoverview(gs: gs, yourscore: curscore)){
                                        primarybutton(buttontext: "Game Over")
                                    }
                                }else{
                                    primarybutton(buttontext: "Next").onTapGesture {
                                        // check if list is empty, if not shuffle the remaining based on language and make sure no repeat questions, shuffle the other options as well, increment qn number and reset answer statuses
                                        if fb.langitemlist.isEmpty{
                                            print("EMPTIED DB")
                                        }else{
                                            fb.langitemlist.shuffle()
                                            fb.randomReplacementIndexOdd = [0, 1, 2, 3, 4, 5].shuffled()[0]
                                            curqnnumber += 1
                                            chosenAnsStatus = 0
                                        }
                                    }
                                }
                                
                            }
                            
                            Spacer()
                        }.padding().frame(maxWidth: .infinity, maxHeight: .infinity).background(Color(0xF6CA97)).edgesIgnoringSafeArea(.all).navigationBarHidden(true)
                    }
                }
            }
            
        }.navigationBarHidden(true)
        
    }
}

struct questionview_Previews: PreviewProvider {
    static var previews: some View {
        questionview(gs: gamestate())
    }
}
