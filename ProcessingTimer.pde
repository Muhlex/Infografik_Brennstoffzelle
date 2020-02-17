class ProcessingTimer {

  Timer timer;
  TimerCallback callback;
  TimerTask timerTask;

  boolean isPaused;
  long remainingTimeOnLastPause;

  ProcessingTimer(TimerCallback callback) {
    this.callback = callback;
    this.isPaused = false;
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

  private void schedule(long duration) {
    this.timer = new Timer();
    this.timerTask = createTask();
    this.timer.schedule(timerTask, duration);
  }

  void start(long duration) {
    if (timer != null) {
      this.cancel();
    }
    this.schedule(duration);
  }

  int getRemaining() {
    if (this.isPaused) {
      return int(remainingTimeOnLastPause);
    }
    else {
      long remainingTime = timerTask.scheduledExecutionTime() - System.currentTimeMillis();
      if (remainingTime > 0)
        return int(remainingTime);
      else
        return 0;
    }
  }

  void cancel() {
    if (isPaused) {
      this.unpause();
    }
    this.timer.cancel();
  }

  boolean pause() {
    int remaining = getRemaining();
    if (remaining > 0 && ! isPaused) {
      this.timer.cancel();
      this.remainingTimeOnLastPause = remaining;
      this.isPaused = true;
    }
    return isPaused;
  }

  boolean unpause() {
    if (isPaused) {
      schedule(this.remainingTimeOnLastPause);
      this.isPaused = false;
    }
    return ! isPaused;
  }

  void modify(int modifiedDuration) {
    long newDuration = getRemaining() + modifiedDuration;
    this.cancel();

    if (newDuration > 0) {
      if (this.isPaused) {
        remainingTimeOnLastPause = newDuration;
      }
      else {
        this.schedule(newDuration);
      }
    }
    else {
      this.remainingTimeOnLastPause = 0;
      this.isPaused = true;
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