class ProcessingTimer {

  int duration;
  TimerCallback callback;

  Timer timer;
  TimerTask timerTask;

  ProcessingTimer(int duration, TimerCallback callback) {
    this.duration = duration;
    this.callback = callback;
    this.timer = new Timer();
    this.timerTask = new TimerTask() {
      @Override
      public void run() {
        getCallback().expired();
      }
    };
  }

  TimerCallback getCallback() {
    return this.callback;
  }

  long remaining() {
    return timerTask.scheduledExecutionTime() - System.currentTimeMillis();
  }

  void start() {
    this.timer.schedule(this.timerTask, this.duration);
  }

  void modify(int modifiedDuration) {
    long newDuration = remaining() + modifiedDuration;
    if (newDuration > 0) {
      this.timer.schedule(this.timerTask, newDuration);
    }
    else {
      this.callback.expired();
    }
  }

  void add(int modifiedDuration) {
    this.modify(modifiedDuration);
  }

  void subtract(int modifiedDuration) {
    this.modify(modifiedDuration * -1);
  }
}

interface TimerCallback {
  void expired();
}