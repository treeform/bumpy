import chroma, bumpy, fidget, fidget/openglbackend, fidget/opengl/context, vmath

var
  d: Segment
  s: Segment

d.a.x = 300
d.a.y = 300

s.a.x = 50
s.a.y = 100
s.b.x = 300
s.b.y = 400

proc drawMain() =
  d.b = mouse.pos

  ctx.line(d.a, d.b, parseHtmlColor("#2ecc71"))

  let color =
    if overlap(d, s):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  ctx.line(s.a, s.b, color)

windowFrame = vec2(600, 600)
startFidget(drawMain)
