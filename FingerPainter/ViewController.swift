//
//  ViewController.swift
//  FingerPainter
//
//  Created by Matthew Dias on 12/17/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func clearTapped(_ sender: Any) {
        guard let drawingView = view as? PaintingView else { return }

        drawingView.clearPainting()
    }

}

