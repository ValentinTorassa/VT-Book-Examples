import os
import threading
import time
def esperar():
    time.sleep(300)
for _ in range(3):
    threading.Thread(target=esperar, daemon=True).start()
print("soy el proceso", os.getpid(),
      "con", threading.active_count(), "threads")
time.sleep(300)
