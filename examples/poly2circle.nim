import bumpy, pixie/demo, vmath, chroma, common

var
  poly: seq[Vec2]
  circle: Circle

circle.radius = 50
poly.add(vec2(200, 100))
poly.add(vec2(400, 130))
poly.add(vec2(350, 300))
poly.add(vec2(250, 330))

start()

while true:
  screen.fill(rgba(255, 255, 255, 255))

  circle.pos = getMousePos()
  screen.fillCircle(circle, parseHtmlColor("#2ecc71"))

  var color =
    if overlaps(poly, circle):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  color.a = 0.75
  screen.fillPoly(poly, color)

  tick()
