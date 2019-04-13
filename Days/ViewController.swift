//
//  ViewController.swift
//  Days
//
//  Created by Tamas Bara on 10.04.19.
//  Copyright © 2019 Tamas Bara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var date: Date? {
        didSet {
            if let date = date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
                labelDebug.text = dateFormatter.string(from: date)
                updatePie(force: true)
                UserDefaults.standard.set(date, forKey: "date")
            }
        }
    }
    
    func getChildVC<T: UIViewController>() -> T? {
        return children.single(where: {$0 is T}) as? T
    }
    
    var timer: Timer?
    
    @IBOutlet weak var datePickerContainer: UIView!
    @IBOutlet weak var labelDays: UILabel!
    @IBOutlet weak var labelDebug: UILabel!
    @IBOutlet weak var datePickerConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let date = UserDefaults.standard.object(forKey: "date") as? Date {
            self.date = date
        } else {
            start()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.update()
        }
    }

    @IBAction func start() {
        date = Date()
    }
    
    @IBAction func pick() {
        performSegue(withIdentifier: "datePicker", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DatePickerViewController {
            vc.delegate = self
            vc.date = date
        }
    }
    
    private func update() {
        guard let date = date else {return}
        labelDays.text = Date().diff(to: date)
        updatePie()
    }
    
    private func updatePie(force: Bool = false) {
        guard let date = date else {return}
        let timeSince = Date().timeIntervalSince(date)
        if Int(timeSince) % 60 == 0 || force {
            let vc: PieViewController? = getChildVC()
            vc?.ratio = CGFloat(timeSince/(31*86400))
        }
    }
}

extension ViewController: DatePickerViewControllerDelegate {
    func datePickerViewController(_ controller: DatePickerViewController, didSelectDate date: Date) {
        self.date = date
    }
}

extension Date {
    func diff(to date: Date) -> String {
        let diff = Int(timeIntervalSince(date))
        
        guard diff > 0 else {return ""}
        
        let remainder = 31*86400 - diff
        
        switch remainder {
        case 1:
            return "noch 1 Sekunde"
        case 2..<60:
            return "noch \(remainder) Sekunden"
        case 60..<120:
            return "noch 1 Minute"
        case 120..<3600:
            return "noch \(remainder/60) Minuten"
        case 3600..<7200:
            return "noch 1 Stunde"
        case 7200..<86400:
            return "noch \(remainder/3600) Stunden"
        case 86400..<172800:
            return "noch 1 Tag"
        default:
            return "noch \(remainder/86400) Tage"
        }
    }
}

extension Sequence {
    func single(where condition: ((Element) throws -> Bool)) rethrows -> Element? {
        var singleElement: Element?
        for element in self where try condition(element) {
            guard singleElement == nil else {
                singleElement = nil
                break
            }
            singleElement = element
        }
        return singleElement
    }
}
