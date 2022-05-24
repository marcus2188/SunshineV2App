//
//  extensions.swift
//  SunshineV2App
//
//  Created by Ksk I on 17/5/22.
//

import Foundation
import SwiftUI
import Combine
import FirebaseCore
import FirebaseFirestore

// GLOBAL EXTENSIONS OF PROPERTIES
extension Text{
    func screenmaintitle() -> some View {
        self.font(.largeTitle).fontWeight(.heavy)
    }
    func screensubtitle() -> some View {
        self.font(.headline)
    }
}
extension Image{
    func shadowedformattedimage() -> some View {
        self.resizable().scaledToFit().shadow(color: .purple, radius: 6)
    }
}
extension CaseIterable where Self: Equatable {
    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex : next]
    }
}
extension Array {
    mutating func shiftRight() {
        if let obj = self.popLast(){
            self.insert(obj, at: 0)
        }
    }
}
extension Color {
  init(_ hex: UInt, alpha: Double = 1) {
    self.init(
      .sRGB,
      red: Double((hex >> 16) & 0xFF) / 255,
      green: Double((hex >> 8) & 0xFF) / 255,
      blue: Double(hex & 0xFF) / 255,
      opacity: alpha
    )
  }
}

// ENUMERATIONS
enum modetype {
    case NONE, CLASSIC, ZEN, ODDONEOUT, TRAINING
}
enum languagetype: CaseIterable {
    case ALL, CHINESE, KOREAN, JAPANESE, SPANISH
}

// OBSERVED OBJECTS, GLOBAL STATES FOR ALL VIEWS SHARED
class gamestate: ObservableObject{
    @Published var mode: modetype = modetype.NONE
    @Published var lang: languagetype = languagetype.allCases[0]
    @Published var score = 0
}
class fblang: ObservableObject{
    @Published var langitemlist = [langitem]()
    // Indices for 4 other options, randomly generated
    @Published var randomInsertionIndex: Int = [[0,1,2,3].endIndex, 0, 1, 2, 3].shuffled()[0]
    // Randomise the other options by index, for range, put the smallest language amount
    @Published var otherOptionsIndex: [Int] = (0..<14-1).shuffled()
    @Published var randomReplacementIndexOdd: Int = [0, 1, 2, 3, 4, 5].shuffled()[0]
    
    
    func getData(selectedLanguage: languagetype){
        if FirebaseApp.app() == nil{
            FirebaseApp.configure()
        }
        let db = Firestore.firestore()
        if selectedLanguage==languagetype.KOREAN{
            db.collection("masterlist_KOR").getDocuments{snapshot, error in
                if error==nil {
                    if let snapshot=snapshot {
                        DispatchQueue.main.async {
                            self.langitemlist = snapshot.documents.map {d in
                                return langitem(id: d.documentID,
                                                english: d["english"] as? String ?? "",
                                                language: d["language"] as? String ?? "",
                                                native: d["native"] as? String ?? "",
                                                pronunciation: d["pronunciation"] as? String ?? "")
                            }
                            self.langitemlist.shuffle()
                        }
                        
                    }
                }
                else{
                    // handle error
                }
            }
        }else{
            if selectedLanguage==languagetype.SPANISH{
                db.collection("masterlist_SPN").getDocuments{snapshot, error in
                    if error==nil {
                        if let snapshot=snapshot {
                            DispatchQueue.main.async {
                                self.langitemlist = snapshot.documents.map {d in
                                    return langitem(id: d.documentID,
                                                    english: d["english"] as? String ?? "",
                                                    language: d["language"] as? String ?? "",
                                                    native: d["native"] as? String ?? "",
                                                    pronunciation: d["pronunciation"] as? String ?? "")
                                }
                                self.langitemlist.shuffle()
                            }
                            
                        }
                    }
                    else{
                        // handle error
                    }
                }
            }else{
                if selectedLanguage==languagetype.CHINESE{
                    db.collection("masterlist_CHN").getDocuments{snapshot, error in
                        if error==nil {
                            if let snapshot=snapshot {
                                DispatchQueue.main.async {
                                    self.langitemlist = snapshot.documents.map {d in
                                        return langitem(id: d.documentID,
                                                        english: d["english"] as? String ?? "",
                                                        language: d["language"] as? String ?? "",
                                                        native: d["native"] as? String ?? "",
                                                        pronunciation: d["pronunciation"] as? String ?? "")
                                    }
                                    self.langitemlist.shuffle()
                                }
                                
                            }
                        }
                        else{
                            // handle error
                        }
                    }
                }else{
                    // ALL LANGUAGES SELECTED, PLEASE EDIT THIS PART IF ADDING/CHANGING LANGUAGES, tgt with firestore side
                    self.langitemlist.removeAll()
                    let collectionslist = ["masterlist_KOR", "masterlist_SPN", "masterlist_CHN"].shuffled()
                    collectionslist.forEach{colname in
                        db.collection(colname).getDocuments{snapshot, error in
                            if error==nil {
                                if let snapshot=snapshot {
                                    DispatchQueue.main.async {
                                        self.langitemlist += snapshot.documents.map {d in
                                            return langitem(id: d.documentID,
                                                            english: d["english"] as? String ?? "",
                                                            language: d["language"] as? String ?? "",
                                                            native: d["native"] as? String ?? "",
                                                            pronunciation: d["pronunciation"] as? String ?? "")
                                        }
                                        self.langitemlist.shuffle()
                                    }
                                    
                                }
                            }
                            else{
                                // handle error
                            }
                        }
                    }
                }
                
            }
        }
    }
}
class answered: ObservableObject {
    @Published var answeredQnslist: [String] = [String]()
}
