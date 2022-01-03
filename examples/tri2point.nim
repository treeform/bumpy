import bumpy, common, pixie/demo

var
  tri: seq[Vec2]
  point: Vec2

tri.add(vec2(200, 100))
tri.add(vec2(400, 130))
tri.add(vec2(350, 300))

start()

while true:
  screen.fill(rgba(255, 255, 255, 255))

  point = window.mousePos.vec2
  screen.fillCircle(circle(point, 10), parseHtmlColor("#2ecc71"))

  var color =
    if overlaps(tri, point):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  color.a = 0.75
  screen.fillPoly(tri, color)

  tick()
