import bumpy, fidget, vmath

var
  a: Vec2
  b: Circle
b.pos.x = 300
b.pos.y = 300
b.radius = 100

proc drawMain() =
  a = mouse.pos

  group "pointA":
    box a.x-10, a.y-10, 20, 20
    cornerRadius 10
    fill "#2ecc71", 0.75

  group "pointB":
    box b.pos.x-b.radius, b.pos.y-b.radius, b.radius*2, b.radius*2
    cornerRadius b.radius
    if overlap(a, b):
      fill "#e74c3c", 0.75
    else:
      fill "#3498db", 0.75

windowFrame = vec2(600, 600)
startFidget(drawMain)
