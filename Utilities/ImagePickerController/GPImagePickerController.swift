//
//  GPImagePickerController.swift
//  Greenply
//
//  Created by Chinmay Das on 23/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class GPImagePickerController: NSObject {
    
    let imagePicker: UIImagePickerController?
    var sourceViewController: UIViewController?
    var didPickImage:((image: UIImage) -> ())?
    var didCancelPicker:(() -> ())?
    
    static let controller = GPImagePickerController()
    private override init() {
        imagePicker = UIImagePickerController()
    }
    class func pickImage(onController sourceController:UIViewController, didPick:((image: UIImage) -> ()), didCancel:(() -> ())){
        GPImagePickerController.pickImage(onController: sourceController, sourceRect: nil, didPick: didPick, didCancel: didCancel)
    }
    class func pickImage(onController sourceController:UIViewController, sourceRect: CGRect?, didPick:((image: UIImage) -> ()), didCancel:(() -> ())){
        let picker = GPImagePickerController.controller
        picker.sourceViewController = sourceController
        picker.didPickImage = didPick
        picker.didCancelPicker = didCancel
        picker.imagePicker!.delegate = picker
        let alert = UIAlertController.showStandardActionSheetWith(APP_TITLE, messageText: "Choose source type", arrayButtons: ["Camera","Gallery"]) { (index) in
            picker.imagePicker!.allowsEditing = true
            switch index {
                case 0:
                    picker.imagePicker!.sourceType = .Camera
                case 1:
                    picker.imagePicker!.sourceType = .PhotoLibrary
                default:break
            }
            debugPrint(picker.imagePicker!.delegate)
            picker.sourceViewController!.presentViewController(picker.imagePicker!, animated: true, completion: nil)
        }
        
        if IS_IPAD(){
        alert.popoverPresentationController?.sourceView = sourceController.view
            alert.popoverPresentationController?.sourceRect = (sourceRect != nil) ? sourceRect! : CGRectMake(sourceController.view.bounds.width/2, sourceController.view.bounds.height, 0, 0)
        }
        picker.sourceViewController!.presentViewController(alert, animated: true, completion: nil)
    }
}

extension GPImagePickerController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if didPickImage != nil {
            didPickImage!(image: (info[UIImagePickerControllerEditedImage] as? UIImage)!)
        }
        GPImagePickerController.controller.sourceViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        if didCancelPicker != nil {
            didCancelPicker!()
        }
        GPImagePickerController.controller.sourceViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
}