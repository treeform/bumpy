import bumpy, fidget, vmath

var
  a: Circle
  b: Rect
a.radius = 50
b.x = 150
b.y = 200
b.w = 300
b.h = 200

proc drawMain() =
  a.pos = mouse.pos

  group "pointA":
    box a.pos.x-a.radius, a.pos.y-a.radius, a.radius*2, a.radius*2
    cornerRadius a.radius
    fill "#2ecc71", 0.75

  group "rectB":
    box b.x, b.y, b.w, b.h
    if overlaps(a, b):
      fill "#e74c3c", 0.75
    else:
      fill "#3498db", 0.75

windowFrame = vec2(600, 600)
startFidget(drawMain)
