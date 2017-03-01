
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var startTaskBtn: UIButton!
    
    @IBOutlet weak var intervalPickerView: AAPickerView!
    
    @IBOutlet weak var spanPickerView: AAPickerView!
    
    @IBOutlet weak var taskPickerView: AAPickerView!
    
    private var interval: Int = 0
    
    private var span: Int = 0
    
    private var taskIndex: Int = -1
    
    private var taskType: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setUpPickers()
    }
    
    @IBAction func showTaskStatus(_ sender: Any) {
        
        if self.canProceed() {
            
            // present status view modally
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let statusVC = storyboard.instantiateViewController(withIdentifier: "statusViewController") as!StatusViewController
            
            let task = self.getSelectedTask()
            
            statusVC.currentTask = task as? BaseTask
            
            statusVC.currentTaskType = self.taskType
            
            self.present(statusVC, animated: true, completion: nil)
            
        } else {
            
            // error alert
            let alertView = UIAlertView(title: "Error", message: "Something is wrong with your input", delegate: nil, cancelButtonTitle: "Ok")
            
            alertView.show()
            
        }
        
    }
    
    
    private func canProceed() -> Bool {
        
        return self.interval != 0 && self.span != 0 && self.taskIndex != -1
        //return true
    }
    
    private func getSelectedTask() -> AnyObject {
        
        switch self.taskIndex {
            case 0:
                return LightTask(interval: self.interval, span: self.span)
            case 1:
                return MediumTask(interval: self.interval, span: self.span)
            case 2:
                return HeavyTask(interval: self.interval, span: self.span)
            default:
                break
        }
        
        return HeavyTask(interval: 1, span: 5)
    }
    
    private func setUpPickers() -> Void {
        
        self.setUpIntervalPicker()
        
        self.setUpSpanPicker()
        
        self.setUpTaskPicker()
        
    }
    
    private func setUpIntervalPicker() -> Void {
        
        self.intervalPickerView.pickerType = .StringPicker
        
        let data:[String] = ["1", "5", "10", "15", "30", "60"]
        
        self.intervalPickerView.stringPickerData = data
        
        self.intervalPickerView.stringDidChange = {[unowned self] index in
            
            self.interval = Int(data[index])! * 60
            
        }
        
    }
    
    private func setUpSpanPicker() -> Void {
        
        self.spanPickerView.pickerType = .StringPicker
        
        let data:[String] = ["1", "2", "3", "4"]
        
        self.spanPickerView.stringPickerData = data
        
        self.spanPickerView.stringDidChange = {[unowned self] index in
            
            self.span = Int(data[index])! * 3600
            
        }
        
    }
    
    private func setUpTaskPicker() -> Void {
        
        self.taskPickerView.pickerType = .StringPicker
        
        let data:[String] = ["light (console log)", "medium (arithmetics)", "heavy (http request)"]
        
        self.taskPickerView.stringPickerData = data
        
        self.taskPickerView.stringDidChange = {[unowned self] index in
            
            self.taskIndex = index
            
            self.taskType = data[index]
            
        }
        
    }
    
    

}


