import bumpy, chroma, common, pixie/demo, vmath

var
  poly: seq[Vec2]
  s: Segment

s.at.x = 100
s.at.y = 100

poly.add(vec2(200, 100))
poly.add(vec2(400, 130))
poly.add(vec2(350, 300))
poly.add(vec2(250, 330))

start()

while true:
  screen.fill(rgba(255, 255, 255, 255))

  s.to = getMousePos()
  screen.strokeSegment(segment(s.at, s.to), parseHtmlColor("#2ecc71"))

  var color =
    if overlaps(poly, s):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  color.a = 0.75
  screen.fillPoly(poly, color)

  tick()
