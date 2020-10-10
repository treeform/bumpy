import bumpy, fidget, vmath

var
  a: Vec2
  b: Rect
b.x = 150
b.y = 200
b.w = 300
b.h = 200

proc drawMain() =
  a = mouse.pos

  group "pointA":
    box a.x-10, a.y-10, 20, 20
    cornerRadius 10
    fill "#2ecc71", 0.75

  group "rectB":
    box b.x, b.y, b.w, b.h
    if overlap(a, b):
      fill "#e74c3c", 0.75
    else:
      fill "#3498db", 0.75

windowFrame = vec2(600, 600)
startFidget(drawMain)
