//
//  AddEditConsoleViewController.swift
//  MyGames
//
//  Created by tamires.p.silva on 26/08/20.
//  Copyright © 2020 Tamires. All rights reserved.
//

import UIKit
import Photos

class AddEditConsoleViewController: UIViewController {
    
    @IBOutlet weak var tfConsole: UITextField!
    @IBOutlet weak var ivConsole: UIImageView!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var btCover: UIButton!
    
    var console: Console?
    
    var consolesManager = ConsolesManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        consolesManager.loadConsoles(with: context)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareDataLayout()
    }
    
    @IBAction func AddEditCover(_ sender: UIButton) {
        // para adicionar uma imagem da biblioteca
        // para adicionar uma imagem da biblioteca
        print("para adicionar uma imagem da biblioteca")
        
        
        let alert = UIAlertController(title: "Selecinar capa", message: "De onde você quer escolher a capa?", preferredStyle: .actionSheet)
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        })
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Album de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        })
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addEditConsole(_ sender: UIButton) {
        if console == nil {
            console = Console(context: context)
        }
        console?.name = tfConsole.text
        
        console?.cover = ivConsole.image
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        // Back na navigation
        navigationController?.popViewController(animated: true)
    }
    
    func chooseImageFromLibrary(sourceType: UIImagePickerController.SourceType) {
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.navigationBar.tintColor = UIColor(named: "main")
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        
        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    
                    self.chooseImageFromLibrary(sourceType: sourceType)
                    
                } else {
                    
                    print("unauthorized -- TODO message")
                }
            })
        } else if photos == .authorized {
            
            self.chooseImageFromLibrary(sourceType: sourceType)
        }
    }
    
    
    func prepareDataLayout() {
        if console != nil {
            title = "Editar console"
            btAddEdit.setTitle("ALTERAR", for: .normal)
            tfConsole.text = console?.name
            
            ivConsole.image = console?.cover as? UIImage
            
            if console?.cover != nil {
                btCover.setTitle(nil, for: .normal)
            }
        }
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
     
        tfConsole.inputAccessoryView = toolbar
    }
    
}
/*
 // MARK: - Extension
 */
extension AddEditConsoleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return consolesManager.consoles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let console = consolesManager.consoles[row]
        return console.name
    }
}

extension AddEditConsoleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // tip. implementando os 2 protocols o evento sera notificando apos user selecionar a imagem
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // ImageView won't update with new image
            // bug fixed: https://stackoverflow.com/questions/42703795/imageview-wont-update-with-new-image
            DispatchQueue.main.async {
                self.ivConsole.image = pickedImage
                self.ivConsole.setNeedsDisplay()
                self.btCover.setTitle(nil, for: .normal)
                self.btCover.setNeedsDisplay()
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
