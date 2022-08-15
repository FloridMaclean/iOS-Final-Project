//
//  eventsViewController.swift
//  Final Project
//
//  Created by Florid Maclean on 2022-08-14.
//

import UIKit
import FirebaseFirestore

class eventsViewController: UIViewController {
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    let db = Firestore.firestore()
    
    private var events: [eventStruct] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.dataSource = self
                fetchAllEvents()
    }
    
    @IBAction func onBackButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    private func fetchAllEvents() {
            db.collection("events").getDocuments() { [self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting event documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let eventName = "\(document.data()["eventName"] ?? "myEvent")"
                        let eventDate = "\(document.data()["eventDate"] ?? "15/08/2022")"
                        events.append(eventStruct(eventName: eventName, eventDate: eventDate))
                    }
                    eventsTableView.reloadData()
                }
            }
        }
}

extension eventsViewController: UITableViewDataSource {
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        let events = events[indexPath.row]

        var content = cell.defaultContentConfiguration()

        content.text = events.eventName
        content.secondaryText = events.eventDate

        cell.contentConfiguration = content
        return cell
    }
}

struct eventStruct {
    var eventName: String
    var eventDate: String
}
