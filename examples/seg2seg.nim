import bumpy, chroma, fidget, fidget/opengl/context, fidget/openglbackend, vmath

var
  d: Segment
  s: Segment

d.at.x = 300
d.at.y = 300

s.at.x = 50
s.at.y = 100
s.to.x = 300
s.to.y = 400

proc drawMain() =
  d.to = mouse.pos

  ctx.line(d.at, d.to, parseHtmlColor("#2ecc71"))

  let color =
    if overlap(d, s):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  ctx.line(s.at, s.to, color)

windowFrame = vec2(600, 600)
startFidget(drawMain)
