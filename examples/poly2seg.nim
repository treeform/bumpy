import bumpy, fidget, fidget/opengl/context, fidget/openglbackend, vmath

var
  poly: seq[Vec2]
  s: Segment

s.at.x = 100
s.at.y = 100

poly.add(vec2(200, 100))
poly.add(vec2(400, 130))
poly.add(vec2(350, 300))
poly.add(vec2(250, 330))

proc drawMain() =
  s.to = mouse.pos

  ctx.line(s.at, s.to, parseHtmlColor("#2ecc71"))

  let color =
    if overlaps(poly, s):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  ctx.linePolygon(poly, color)

windowFrame = vec2(600, 600)
startFidget(drawMain)
