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
