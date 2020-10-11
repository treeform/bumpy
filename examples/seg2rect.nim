import chroma, bumpy, fidget, fidget/openglbackend, fidget/opengl/context, vmath

var
  s: Segment
  r: Rect

s.a.x = 10
s.a.y = 10

r.x = 150
r.y = 200
r.w = 300
r.h = 200

proc drawMain() =
  s.b = mouse.pos

  ctx.line(s.a, s.b, parseHtmlColor("#2ecc71"))

  group "rect":
    box r.x, r.y, r.w, r.h
    if overlap(s, r):
      fill "#e74c3c", 0.75
    else:
      fill "#3498db", 0.75

windowFrame = vec2(600, 600)
startFidget(drawMain)
