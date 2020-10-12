import bumpy, fidget, fidget/openglbackend, fidget/opengl/context, vmath

var
  poly: seq[Vec2]
  circle: Circle


circle.radius = 50

poly.add(vec2(200, 100))
poly.add(vec2(400, 130))
poly.add(vec2(350, 300))
poly.add(vec2(250, 330))

proc drawMain() =
  circle.pos = mouse.pos

  group "circle":
    box(
      circle.pos.x - circle.radius,
      circle.pos.y - circle.radius,
      circle.radius * 2,
      circle.radius * 2
    )
    cornerRadius circle.radius
    fill "#2ecc71", 0.75

  let color =
    if overlap(poly, circle):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  ctx.linePolygon(poly, color)

windowFrame = vec2(600, 600)
startFidget(drawMain)
