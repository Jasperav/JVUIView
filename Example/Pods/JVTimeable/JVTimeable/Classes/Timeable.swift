import JVRestartable

/// DO NOT FORGET TO ADD AN DEINIT WHICH CALLS REMOVETIMER() WHEN NOT INHERTING FROM TIMEABLEWRAPPER(COMMONMODES)


/// Protocol for creating a timeable object
public protocol Timeable: Restartable {
    
    /// The actual timer
    var timer: Timer? { get set }
    
    /// The seconds the timer needs to wait before firing function action
    var timerIntervalSeconds: TimeInterval { get }
    
    /// Should have a default value of 0.0.
    /// The protocol extensions take care of this value.
    var timeThatTheTimerStarted: TimeInterval { get set }
    
    /// Should have a default value of nil.
    /// The protocol extensions take care of this value.
    var timeThatTheTimerHasBeenPaused: TimeInterval? { get set }
    
    /// If the timer has been paused, timeThatTheTimerHasBeenPaused always get the current date as value.
    /// When resuming, the timer will get a value that is calculated as followed if continueTimingWhenPaused = false:
    /// timeThatTheTimerHasBeenPaused - timeThatTheTimerStarted
    /// when continueTimingWhenPaused is true, the time the timer has been paused will also be substracted.
    var continueTimingWhenPaused: Bool { get }
    
    /// Indicates that, when the timer has fired, it auto-repeats.
    var repeatTimerAfterCompletion: Bool { get }
    
    /// This closure is chosen over a function because now this protocol can be implemented with the the composite design pattern.
    /// It is explicitly unwrapped because we can not use a [weak self] block in the initializer when constructing the new object.
    /// It is possible to use [weak self] in the initializer, but not in the calling code.
    var timerHasFired: (() -> ())! { get }
    
    /// The runloop of the current timer.
    var runLoop: TimeableRunloop { get }
}

public extension Timeable {
    
    /// Leave nil to use the property timerIntervalSeconds as value
    public func startTimer(_ customTimeInterval: TimeInterval?) {
        switch runLoop {
        case .main:
            startTimerMainThread(customTimeInterval)
        case .normal:
            startTimerNormal(customTimeInterval)
        case .commonModes:
            fatalError("You should never ever be able to get here >:(.")
        }
    }
    
    /// Fire with timer set to main queue, use this when the timer gets called from a different thread.
    public func startTimerMainThread(_ customTimeInterval: TimeInterval?) {
        setValuesWhenTimerWillStart()
        assert(runLoop != .commonModes)
        // No assert to check if the current thread is from the main thread, it doens't really matter.
        
        // Timers should always fire from the main thread else the won't fire in closures
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: customTimeInterval ?? self.timerIntervalSeconds, repeats: self.repeatTimerAfterCompletion, block: { [weak self] (_) in
                self?.timerHasFired()
            })
        }
    }
    
    /// Starts the timer without running it explicitly on the main thread.
    /// I do not really know why people use this so much, since it can crash (if called from outside the main thread).
    public func startTimerNormal(_ customTimeInterval: TimeInterval?) {
        setValuesWhenTimerWillStart()
        assert(runLoop != .commonModes)
        assert(Thread.isMainThread)
        
        self.timer = Timer.scheduledTimer(withTimeInterval: customTimeInterval ?? self.timerIntervalSeconds, repeats: self.repeatTimerAfterCompletion, block: { [weak self] (_) in
            self?.timerHasFired()
        })
    }
    
    /// In some situations it is preferred to start a timer but a new Timeinterval, but only once.
    /// Imagine a situation a timeable object is making every hour a request to the server,
    /// but a query fails (e.g., the user doesn't have internet atm).
    /// What we gonna do? Gonna wait another hour to wait for startTimer to fire?
    /// The app can call startTimer with a single-use timerinterval, but what if the timeable object will restart itself (repeatTimerAfterCompletion == true)?
    /// Don't panic!! Just use this method.
    /// This app will call startTimer if repeatTimerAfterCompletion == true with the normal timerIntervalSeconds.
    public func startSingleUseableTimer(timerInterval: TimeInterval) {
        setValuesWhenTimerWillStart()
        assert(runLoop != .commonModes)
        assert(Thread.isMainThread)
        
        // Timers should always fire from the main thread else the won't fire in closures
        self.timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: false, block: { [weak self] (_) in
            self?.timerHasFired()
            if self?.repeatTimerAfterCompletion ?? false {
                self?.startTimerNormal(nil)
            }
        })
    }
    
    /// Fire with timer set to main queue, use this when the timer gets called from a different thread.
    public func startSingleUseableTimerSynced(timerInterval: TimeInterval) {
        assert(runLoop != .commonModes)
        setValuesWhenTimerWillStart()
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: false, block: { [weak self] (_) in
                self?.timerHasFired()
                if self?.repeatTimerAfterCompletion ?? false {
                    self?.startTimerMainThread(nil)
                }
            })
        }
    }
    
    /// If this changes, change it in TimeableWrapper to in the pause() method
    public func pause() {
        timeThatTheTimerHasBeenPaused = Date.timeIntervalSinceReferenceDate
        removeTimer()
    }
    
    /// If this changes, change it in TimeableWrapper to in the resume() method
    public func resume() {
        // Copied
        guard let timeThatTheTimerHasBeenPaused = timeThatTheTimerHasBeenPaused else {
            determineStartTimer(nil)
            return
        }
        
        let secondsForTheTimerToRun: TimeInterval
        
        if continueTimingWhenPaused {
            secondsForTheTimerToRun = timerIntervalSeconds - ((timeThatTheTimerHasBeenPaused + (Date.timeIntervalSinceReferenceDate - timeThatTheTimerHasBeenPaused)) - timeThatTheTimerStarted)
        } else {
            secondsForTheTimerToRun = timerIntervalSeconds - (timeThatTheTimerHasBeenPaused - timeThatTheTimerStarted)
        }
        
        if secondsForTheTimerToRun < 0 {
            timerHasFired()
            if repeatTimerAfterCompletion {
                determineStartTimer(nil)
            }
        } else {
            determineStartTimer(secondsForTheTimerToRun)
        }
    }
    
    /// This method should be called when not knowing what runLoop the current timer has.
    public func determineStartTimer(_ timeInterval: TimeInterval?) {
        
        // We need to cast it to TimeableWrapperCommonModes because else the wrong startTimer will get invoked.
        guard let timeableWrapperCommonModes = self as? TimeableWrapperCommonModes else {
            startTimer(timeInterval)
            return
        }
        
        timeableWrapperCommonModes.startTimer(timeInterval)
    }
    
    /// Removes the current timer.
    /// It isn't needed to remove it from the runLoop, since that will be done with the invalidate() method.
    public func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// Method to call just before a new timer will be created.
    public func setValuesWhenTimerWillStart() {
        timeThatTheTimerStarted = Date.timeIntervalSinceReferenceDate
        timeThatTheTimerHasBeenPaused = nil
        removeTimer()
    }
}
