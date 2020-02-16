class ProcessingTimer {

  TimerCallback callback;

  Timer timer;
  TimerTask timerTask;

  long pausedTimeRemaining;

  ProcessingTimer(TimerCallback callback) {
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

  int remaining() {
    return int(timerTask.scheduledExecutionTime() - System.currentTimeMillis());
  }

  void start(int duration) {
    this.timer.schedule(this.timerTask, duration);
  }

  boolean pause() {
    int remaining = remaining();
    if (remaining > 0) {
      this.timer.cancel();
      this.pausedTimeRemaining = remaining;
      return true;
    }
    else {
      return false;
    }
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