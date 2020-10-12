import bumpy, fidget, fidget/openglbackend, fidget/opengl/context, vmath

var
  a: seq[Vec2]
  b: seq[Vec2]

b.add(vec2(200, 100))
b.add(vec2(400, 130))
b.add(vec2(350, 300))
b.add(vec2(250, 330))

proc drawMain() =
  a.setLen(0)
  a.add(vec2(-20, -10) + mouse.pos)
  a.add(vec2(-30, -49) + mouse.pos)
  a.add(vec2(40, 60) + mouse.pos)
  a.add(vec2(30, 70) + mouse.pos)

  ctx.linePolygon(a, parseHtmlColor("#2ecc71"))

  let color =
    if overlap(a, b):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  ctx.linePolygon(b, color)

windowFrame = vec2(600, 600)
startFidget(drawMain)
