import bumpy, fidget, fidget/openglbackend, fidget/opengl/context, vmath

var
  tri: seq[Vec2]
  point: Vec2

tri.add(vec2(200, 100))
tri.add(vec2(400, 130))
tri.add(vec2(350, 300))

proc drawMain() =
  point = mouse.pos

  group "point":
    box point.x-10, point.y-10, 20, 20
    cornerRadius 10
    fill "#2ecc71", 0.75

  let color =
    if overlap(tri, point):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  ctx.linePolygon(tri, color)

windowFrame = vec2(600, 600)
startFidget(drawMain)
