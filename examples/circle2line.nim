import bumpy, chroma, common, pixie/demo, vmath

var
  c: Circle
  l: Line
c.radius = 50
l.a.x = 0
l.a.y = 100
l.b.x = 800
l.b.y = 400

start()

while true:
  screen.fill(rgba(255, 255, 255, 255))

  c.pos = getMousePos()
  screen.fillCircle(c, parseHtmlColor("#2ecc71"))

  var color =
    if overlaps(c, l): parseHtmlColor("#e74c3c")
    else: parseHtmlColor("#3498db")
  color.a = 0.75
  screen.strokeSegment(segment(l.a, l.b), color)

  tick()
