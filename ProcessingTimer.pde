class ProcessingTimer {

  Timer timer;
  TimerCallback callback;
  TimerTask timerTask;

  long pausedTimeRemaining;

  ProcessingTimer(TimerCallback callback) {
    this.callback = callback;
  }

  TimerTask createTask() {
    return new TimerTask() {
      @Override
      public void run() {
        getCallback().expired();
      }
    };
  }

  TimerCallback getCallback() {
    return this.callback;
  }

  void schedule(long duration) {
    this.timer = new Timer();
    this.timerTask = createTask();
    this.timer.schedule(timerTask, duration);
  }

  void start(long duration) {
    this.schedule(duration);
  }

  int getRemaining() {
    long remainingTime = timerTask.scheduledExecutionTime() - System.currentTimeMillis();
    if (remainingTime > 0)
      return int(remainingTime);
    else
      return 0;
  }

  void cancel() {
    this.timer.cancel();
  }

  boolean pause() {
    int remaining = getRemaining();
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
    long newDuration = getRemaining() + modifiedDuration;
    if (newDuration > 0) {
      this.schedule(newDuration);
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