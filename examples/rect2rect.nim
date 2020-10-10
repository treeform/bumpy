import bumpy, fidget, vmath

var
  a: Rect
  b: Rect
a.w = 50
a.h = 40
b.x = 150
b.y = 200
b.w = 300
b.h = 200

proc drawMain() =
  a.x = mouse.pos.x
  a.y = mouse.pos.y

  group "rectA":
    box a.x, a.y, a.w, a.h
    fill "#2ecc71", 0.75

  group "rectB":
    box b.x, b.y, b.w, b.h
    if bumpy.overlap(a, b):
      fill "#e74c3c", 0.75
    else:
      fill "#3498db", 0.75

windowFrame = vec2(600, 600)
startFidget(drawMain)
