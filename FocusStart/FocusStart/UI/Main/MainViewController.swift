//
//  MainViewController.swift
//  FocusStart
//
//  Created by Ilya Salatyuk on 3/18/21.
//

import UIKit

class MainViewController: UIViewController, Storyboarded {
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // swiftlint:disable force_cast
        return storyboard.instantiateInitialViewController() as! Self
        // swiftlint:enable force_cast
    }

    @IBOutlet var tableView: UITableView!

    private var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Notes"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        notes = NotesManager.shared.loadNotes()
        tableView.reloadData()
    }
    
    @IBAction func newNotePressed(_ sender: Any) {
        MainCoordinator.shared.note(note: nil)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteCell
        // swiftlint:enable force_cast
        let note = notes[indexPath.row]
        if let text = note.text?.components(separatedBy: CharacterSet.newlines) {
            cell.title.text = text.first
            if text.count > 1 {
                cell.mainText.text = text[1]
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        MainCoordinator.shared.note(note: note)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes[indexPath.row]
            NotesManager.shared.removeNote(note: note)
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
