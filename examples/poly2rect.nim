import bumpy, common

var
  poly: seq[Vec2]
  rect: Rect

rect.w = 50
rect.h = 60

poly.add(vec2(200, 100))
poly.add(vec2(400, 130))
poly.add(vec2(350, 300))
poly.add(vec2(250, 330))

start()

while true:
  screen.fill(rgba(255, 255, 255, 255))

  rect.xy = window.mousePos.vec2
  screen.fillRect(rect, parseHtmlColor("#2ecc71"))

  var color =
    if overlaps(poly, rect):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  color.a = 0.75
  screen.fillPoly(poly, color)

  tick()
