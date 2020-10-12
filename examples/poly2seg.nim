import bumpy, fidget, fidget/openglbackend, fidget/opengl/context, vmath

var
  poly: seq[Vec2]
  s: Segment


s.a.x = 100
s.a.y = 100

poly.add(vec2(200, 100))
poly.add(vec2(400, 130))
poly.add(vec2(350, 300))
poly.add(vec2(250, 330))

proc drawMain() =
  s.b = mouse.pos

  ctx.line(s.a, s.b, parseHtmlColor("#2ecc71"))

  let color =
    if overlap(poly, s):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  ctx.linePolygon(poly, color)

windowFrame = vec2(600, 600)
startFidget(drawMain)
