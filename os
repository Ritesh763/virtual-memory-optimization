from collections import deque, OrderedDict

class MemorySimulator:
    def __init__(self, frames=4):
        self.frames = frames
        self.page_faults = 0

    def fifo(self, ref_str):
        queue, self.page_faults = deque(maxlen=self.frames), 0
        for page in ref_str:
            if page not in queue:
                self.page_faults += 1
                queue.append(page)
        return self.page_faults

    def lru(self, ref_str):
        cache, self.page_faults = OrderedDict(), 0
        for page in ref_str:
            if page not in cache:
                self.page_faults += 1
                if len(cache) == self.frames:
                    cache.popitem(last=False)
            cache[page] = None
            cache.move_to_end(page)
        return self.page_faults

def test_algorithms():
    ref_str = [1,2,3,4,1,2,5,1,2,3,4,5]  # Reference string
    sim = MemorySimulator(frames=3)
    
    print("FIFO faults:", sim.fifo(ref_str))
    print("LRU faults:", sim.lru(ref_str))
    
    # Working set visualization
    ws = set()
    window = 4
    print("\nWorking Set:")
    for i, page in enumerate(ref_str):
        ws.add(page)
        if i >= window and ref_str[i-window] not in ref_str[i-window+1:i+1]:
            ws.remove(ref_str[i-window])
        print(f"Time {i}: {ws}")

test_algorithms()
