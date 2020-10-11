import bumpy, fidget, fidget/openglbackend, fidget/opengl/context, vmath

var
  poly: seq[Vec2]
  point: Vec2

poly.add(vec2(200, 100))
poly.add(vec2(400, 130))
poly.add(vec2(350, 300))
poly.add(vec2(250, 330))

proc drawMain() =
  point = mouse.pos

  group "point":
    box point.x-10, point.y-10, 20, 20
    cornerRadius 10
    fill "#2ecc71", 0.75

  let color =
    if overlap(poly, point):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  ctx.linePolygon(poly, color)

windowFrame = vec2(600, 600)
startFidget(drawMain)
