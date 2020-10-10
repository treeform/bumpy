import vmath, fidget, bumpy

var a, b: Vec2
b.x = 300
b.y = 300

proc drawMain() =
  a = mouse.pos

  group "pointA":
    box a.x-10, a.y-10, 20, 20
    cornerRadius 10
    fill "#2ecc71", 0.75

  group "pointB":
    box b.x-20, b.y-20, 40, 40
    cornerRadius 20
    if overlap(a, b):
      fill "#e74c3c", 0.75
    else:
      fill "#3498db", 0.75

windowFrame = vec2(600, 600)
startFidget(drawMain)
