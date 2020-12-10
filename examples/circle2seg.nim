import chroma, bumpy, fidget, fidget/openglbackend, fidget/opengl/context, vmath

var
  a: Circle
  s: Segment
a.radius = 50
s.at.x = 50
s.at.y = 100
s.to.x = 300
s.to.y = 400

proc drawMain() =
  a.pos = mouse.pos

  group "circle":
    box a.pos.x-a.radius, a.pos.y-a.radius, a.radius*2, a.radius*2
    cornerRadius a.radius
    fill "#2ecc71", 0.75

  let color =
    if overlap(a, s):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")

  ctx.line(s.at, s.to, color)

windowFrame = vec2(600, 600)
startFidget(drawMain)
