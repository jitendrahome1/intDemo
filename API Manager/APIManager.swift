//
//  GPAPIManager.swift
//  Greenply
//
//  Created by Jitendra on 9/6/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
import Alamofire
import Timberjack
import SwiftyJSON

class APIManager: Alamofire.Manager {

	static let manager: APIManager = {
		let configuration = Timberjack.defaultSessionConfiguration()
		let manager = APIManager(configuration: configuration)
		return manager
	}()

	private let baseURL = "http://52.6.251.159/~demoecom/greenply/api/web/v1"
	private static let apiKey = ""
	private let parameterEncoding: ParameterEncoding = .JSON
	internal var header: [String: String] = ["Content-Type": "application/json"]

	func cancelAllTaskExcluding(tasks cancelTasks: [String]) {
		self.session.getTasksWithCompletionHandler
		{
			(dataTasks, uploadTasks, downloadTasks) -> Void in
			for task in dataTasks as [NSURLSessionTask] {
				if !cancelTasks.contains((task.currentRequest?.URL?.description)!) {
					task.cancel()
					debugPrint("*************************\(task.currentRequest?.URL?.description)*************")
				}
			}
		}
	}

	// MARK: Reachability Check
	private func isReachable() -> (Bool) {
		let network = NetworkReachabilityManager()
		network?.startListening()
		if network?.isReachable ?? false {
			if ((network?.isReachableOnEthernetOrWiFi) != nil) {
				return true
			} else if (network?.isReachableOnWWAN)! {
				return true
			}
		}
		else {
			return false
		}
		return false
	}

	func postRequestJSON(endPoint: String, parameters: [String: AnyObject]?, headers: [String: String]?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
		defer {
			debugPrint("POST REQUEST for endpoint \(endPoint) successfully executed")
		}
		if isReachable() {
			debugPrint("start loader")

			if headers != nil {
				header += headers!
			}

			APIManager.manager.cancelAllTaskExcluding(tasks: [baseURL + DASHBOARD])

			CDSpinner.show()
			APIManager.manager.request(.POST, baseURL + endPoint, parameters: parameters, encoding: parameterEncoding, headers: header).validate().responseJSON { (response) in

				CDSpinner.hide()
				debugPrint("loader hide")

				guard response.result.isSuccess else {
					failure(error: response.result.error)

					return
				}
				if let value = response.result.value {
					success(response: JSON(value))
				}
			}
		} else {

			CDSpinner.hide()
			Toast.show(withMessage: NO_NETWORK)
		}
	}

	func getRequest(endpoint: String, headers: [String: String]?, parameters: [String: AnyObject]?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {

		defer {
			debugPrint("GET REQUEST for endpoint \(endpoint) successfully executed")

		}

		if headers != nil {
			header += headers!
		}
		if isReachable() {

			APIManager.manager.cancelAllTaskExcluding(tasks: [baseURL + DASHBOARD])

			CDSpinner.show()
			APIManager.manager.request(.GET, baseURL + endpoint, parameters: parameters, encoding: parameterEncoding, headers: header).validate().responseJSON { (response) in

				CDSpinner.hide()
				guard response.result.isSuccess else {
					failure(error: response.result.error)
					return
				}

				if let value = response.result.value {
					success(response: JSON(value))
				}
			}
		} else {
			CDSpinner.hide()
			Toast.show(withMessage: NO_NETWORK)
		}
	}

	func putRequestJSON(endPoint: String, parameters: [String: AnyObject]?, headers: [String: String]?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
		defer {
			debugPrint("PUT REQUEST for endpoint \(endPoint) successfully executed")
		}
		if isReachable() {
			debugPrint("show loader")
			if headers != nil {
				header += headers!
			}

			APIManager.manager.cancelAllTaskExcluding(tasks: [baseURL + DASHBOARD])

			CDSpinner.show()
			APIManager.manager.request(.PUT, baseURL + endPoint, parameters: parameters, encoding: parameterEncoding, headers: header).validate().responseJSON { (response) in
				debugPrint("hide loader")
				CDSpinner.hide()
//                CMHelper.helper.stopLoaderAnimation()
				guard response.result.isSuccess else {
					failure(error: response.result.error)
					if response.result.error?.localizedDescription != "cancelled" {
//                        UIApplication.sharedApplication().keyWindow!.makeToast(response.result.error!.localizedDescription, duration: 1.0, position: CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT - 75))
					}
//                    self.showError(data: response.data!)
					if let userInfo = response.result.error?.userInfo {
						if let code = userInfo["StatusCode"] as? NSNumber {
							if code == 406 || code == 403 {
								debugPrint(response.result.error!.userInfo["StatusCode"]!)
								// self.logout()
							}
						}
					}
					return
				}

				if let value = response.result.value {
					success(response: JSON(value))
				}
			}
		} else {
			CDSpinner.hide()
			Toast.show(withMessage: NO_NETWORK)
		}
	}

	func deleteRequestJSON(endPoint: String, parameters: [String: AnyObject]?, headers: [String: String]?, success: (response: JSON!) -> (), failure: (error: NSError!) -> ()) {
		defer {
			debugPrint("Delete REQUEST for endpoint \(endPoint) successfully executed")
		}
		if isReachable() {
			debugPrint("show loader")
			if headers != nil {
				header += headers!
			}

			APIManager.manager.cancelAllTaskExcluding(tasks: [baseURL + DASHBOARD])

			CDSpinner.show()
			APIManager.manager.request(.DELETE, baseURL + endPoint, parameters: parameters, encoding: parameterEncoding, headers: header).validate().responseJSON { (response) in
				debugPrint("hide loader")
				CDSpinner.hide()
				// CMHelper.helper.stopLoaderAnimation()
				guard response.result.isSuccess else {
					failure(error: response.result.error)
					if response.result.error?.localizedDescription != "cancelled" {
						// UIApplication.sharedApplication().keyWindow!.makeToast(response.result.error!.localizedDescription, duration: 1.0, position: CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT - 75))
					}
					// self.showError(data: response.data!)
					if let userInfo = response.result.error?.userInfo {
						if let code = userInfo["StatusCode"] as? NSNumber {
							if code == 406 || code == 403 {
								debugPrint(response.result.error!.userInfo["StatusCode"]!)
								// self.logout()
							}
						}
					}
					return
				}

				if let value = response.result.value {
					success(response: JSON(value))
				}
			}
		} else {
			CDSpinner.hide()
			Toast.show(withMessage: NO_NETWORK)
		}
	}

	func uploadFileMultipartFormDataWithParams(endPoint: String, headers: [String: String]?, uploadImageList: [AnyObject]?, fileName: String?, parameters: [String: AnyObject]?, success: (response: JSON!) -> (), failure: (errorMsg: String) -> ()) {

		if isReachable() {
			if headers != nil {
				header += headers!
			}
			CDSpinner.show()

			APIManager.manager.upload(.POST, baseURL + endPoint, headers: header, multipartFormData: { (MultipartFormData) in

				for index in 0..<uploadImageList!.count {
					if let imageData = uploadImageList![index] as? NSData {
						MultipartFormData.appendBodyPart(data: imageData, name: "PortfolioImages[]", fileName: "abc.jpg", mimeType: "image/jpg")
					}
				}

				for (key, value) in parameters! {
					MultipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
				}

				}, encodingCompletion: { encodingResult in

				switch encodingResult {
				case .Success(let upload, _, _):
					upload.responseJSON { response in
						debugPrint(response)
						CDSpinner.hide()
						if let value = response.result.value {
							success(response: JSON(value))
						}
					}
				case .Failure(let encodingError):
					print(encodingError)
					CDSpinner.hide()
					failure(errorMsg: "Failure")
					Toast.show(withMessage: NO_NETWORK)

				}
			})
		} else {
			CDSpinner.hide()
			debugPrint("No Network.")
			failure(errorMsg: "No Network.")
			Toast.show(withMessage: NO_NETWORK)
		}
	}

}

func += <K, V> (inout left: [K: V], right: [K: V]) {
	for (k, v) in right {
		left.updateValue(v, forKey: k)
	}
}