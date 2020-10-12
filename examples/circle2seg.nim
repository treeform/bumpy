import chroma, bumpy, fidget, fidget/openglbackend, fidget/opengl/context, vmath

var
  a: Circle
  s: Segment
a.radius = 50
s.a.x = 50
s.a.y = 100
s.b.x = 300
s.b.y = 400

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

  ctx.line(s.a, s.b, color)

windowFrame = vec2(600, 600)
startFidget(drawMain)
