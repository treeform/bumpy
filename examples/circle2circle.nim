import bumpy, fidget, vmath

var
  a: Circle
  b: Circle
a.radius = 200
b.pos.x = 300
b.pos.y = 300
b.radius = 100

proc drawMain() =
  a.pos = mouse.pos

  group "pointA":
    box a.pos.x-a.radius, a.pos.y-a.radius, a.radius*2, a.radius*2
    cornerRadius a.radius
    fill "#2ecc71", 0.75

  group "pointB":
    box b.pos.x-b.radius, b.pos.y-b.radius, b.radius*2, b.radius*2
    cornerRadius b.radius
    if overlaps(a, b):
      fill "#e74c3c", 0.75
    else:
      fill "#3498db", 0.75

windowFrame = vec2(600, 600)
startFidget(drawMain)
