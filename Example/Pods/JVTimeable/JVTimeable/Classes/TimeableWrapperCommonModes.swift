/// Protocols dont let me add @objc methods, so a few functions are placed in the class itself.
/// Use this class when you want a 100% accurate timer without side effects e.g. scrolling a tableview.
/// see https://stackoverflow.com/questions/45340753/swift-3-2-timer-with-tableview

open class TimeableWrapperCommonModes: TimeableWrapper {
    
    public init(timerIntervalSeconds: TimeInterval, continueTimingWhenPaused: Bool, repeatTimerAfterCompletion: Bool) {
        super.init(timerIntervalSeconds: timerIntervalSeconds,
                   continueTimingWhenPaused: continueTimingWhenPaused,
                   repeatTimerAfterCompletion: repeatTimerAfterCompletion,
                   runLoop: .commonModes)
    }
    
    public func startTimer(_ customTimeInterval: TimeInterval?) {
        setValuesWhenTimerWillStart()
        
        DispatchQueue.main.async {
            self.timer = Timer(timeInterval: customTimeInterval ?? self.timerIntervalSeconds,
                               target: self,
                               selector: #selector(self._timerHasFired),
                               userInfo: nil,
                               repeats: self.repeatTimerAfterCompletion)
            
            RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.common)
        }
    }
    
    @objc private func _timerHasFired() {
        timerHasFired()
    }
    
    @objc private func _timerHasFiredSingleUsableTimer() {
        timerHasFired()
        
        if self.repeatTimerAfterCompletion {
            self.startTimer(nil)
        }
    }
    
    public func startSingleUseableTimer(timerInterval: TimeInterval) {
        setValuesWhenTimerWillStart()
        
        DispatchQueue.main.async {
            self.timer = Timer(timeInterval: timerInterval,
                               target: self,
                               selector: #selector(self._timerHasFiredSingleUsableTimer),
                               userInfo: nil,
                               repeats: false)
            
            RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.common)
        }
    }
}
