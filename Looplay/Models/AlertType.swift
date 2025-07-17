//
//  AlertType.swift
//  Looplay
//
//  Created by Amadou on 15.07.2025.
//

enum AlertType: Identifiable {    
    case copySongs
    case importSongs(String)
    case deleteAll

    var id: String {
        switch self {
        case .copySongs:
            return "copy"
        case .importSongs(let text):
            return text
        case .deleteAll:
            return "deleteAll"
        }
    }
}
