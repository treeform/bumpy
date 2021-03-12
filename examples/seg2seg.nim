import bumpy, pixie/demo, vmath, chroma
var
  d: Segment
  s: Segment

d.at.x = 300
d.at.y = 300

s.at.x = 50
s.at.y = 100
s.to.x = 300
s.to.y = 400

start()

while true:
  screen.fill(rgba(255, 255, 255, 255))

  d.to = getMousePos()
  screen.strokeSegment(d, parseHtmlColor("#2ecc71"))

  var color =
    if overlaps(d, s):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  color.a = 0.75
  screen.strokeSegment(s, color)

  tick()
