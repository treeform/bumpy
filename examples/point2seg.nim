import bumpy, common

var
  a: Vec2
  s: Segment
s.at.x = 50
s.at.y = 100
s.to.x = 300
s.to.y = 400

start()

while true:
  screen.fill(rgba(255, 255, 255, 255))

  a = window.mousePos.vec2
  screen.strokeCircle(circle(a, 10), parseHtmlColor("#2ecc71"))

  var color =
    if overlaps(a, s): parseHtmlColor("#e74c3c")
    else: parseHtmlColor("#3498db")
  color.a = 0.75
  screen.strokeSegment(s, color)

  tick()
