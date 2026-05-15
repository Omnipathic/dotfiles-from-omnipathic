import evdev
import asyncio
import subprocess

SCROLL_SPEED = 30  # pixels per tick
scrolling = False
scroll_task = None

def find_mouse():
    devices = [evdev.InputDevice(p) for p in evdev.list_devices()]
    for d in devices:
        caps = d.capabilities()
        if evdev.ecodes.EV_KEY in caps:
            if evdev.ecodes.BTN_MIDDLE in caps[evdev.ecodes.EV_KEY]:
                return d
    return None

async def do_scroll(device):
    global scrolling
    while scrolling:
        subprocess.run(["ydotool", "mousemove", "--", "0", f"-{SCROLL_SPEED}"])
        await asyncio.sleep(0.05)

async def main():
    global scrolling, scroll_task
    mouse = find_mouse()
    if not mouse:
        print("No mouse found")
        return

    print(f"Watching {mouse.name}")
    async for event in mouse.async_read_loop():
        if event.type == evdev.ecodes.EV_KEY and event.code == evdev.ecodes.BTN_MIDDLE:
            if event.value == 1:  # pressed
                scrolling = True
                scroll_task = asyncio.create_task(do_scroll(mouse))
            elif event.value == 0:  # released
                scrolling = False
                if scroll_task:
                    scroll_task.cancel()

asyncio.run(main())
