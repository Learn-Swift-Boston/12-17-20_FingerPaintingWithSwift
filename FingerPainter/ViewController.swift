//
//  ViewController.swift
//  FingerPainter
//
//  Created by Matthew Dias on 12/17/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var paintingView: PaintingView!
    let picker = UIColorPickerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        picker.selectedColor = paintingView.brushColor
    }

    @IBAction func clearTapped(_ sender: Any) {
        paintingView.clearPainting()
    }

    @IBAction func colorTapped(_ sender: Any) {

        present(picker, animated: true, completion: nil)
    }
}

extension ViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        paintingView.brushColor = viewController.selectedColor
        viewController.dismiss(animated: true, completion: nil)
    }
}
