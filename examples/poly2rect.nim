import bumpy, fidget, fidget/openglbackend, fidget/opengl/context, vmath

var
  poly: seq[Vec2]
  rect: Rect


rect.w = 50
rect.h = 60

poly.add(vec2(200, 100))
poly.add(vec2(400, 130))
poly.add(vec2(350, 300))
poly.add(vec2(250, 330))

proc drawMain() =
  rect.x = mouse.pos.x
  rect.y = mouse.pos.y

  group "rect":
    box rect.x, rect.y, rect.w, rect.h
    fill "#2ecc71", 0.75

  let color =
    if overlap(poly, rect):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  ctx.linePolygon(poly, color)

windowFrame = vec2(600, 600)
startFidget(drawMain)
