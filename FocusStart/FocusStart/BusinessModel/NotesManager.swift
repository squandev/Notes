//
//  NotesManager.swift
//  FocusStart
//
//  Created by Ilya Salatyuk on 3/18/21.
//

import UIKit
import CoreData

class NotesManager {
    static var shared: NotesManager = {
        let notesManager = NotesManager()
        return notesManager
    }()

    private var dataBase: DataBase {
        return DataBase.shared
    }

    func newNote(text: String, attributedText: NSAttributedString, textMods: TextMods?) {
        let note = Note(context: dataBase.persistentContainer.viewContext)
        if let textMods = textMods {
            note.textMods = TextMods.toData(textMods: textMods)
        }
        note.attributedText = attributedText
        note.text = text
        dataBase.save()
    }

    func noteUpdated() {
        dataBase.save()
    }

    func removeNote(note: Note) {
        dataBase.persistentContainer.viewContext.delete(note)
        dataBase.save()
    }
    func loadNotes() -> [Note] {
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        return dataBase.fetch(fetchRequest)
    }
}
