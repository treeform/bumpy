import bumpy, chroma, pixie/demo, vmath

var
  s: Segment
  r: Rect

s.at.x = 400
s.at.y = 100

r.x = 150
r.y = 200
r.w = 300
r.h = 200

start()

while true:
  screen.fill(rgba(255, 255, 255, 255))

  s.to = getMousePos()
  screen.strokeSegment(segment(s.at, s.to), parseHtmlColor("#2ecc71"))

  var color =
    if overlaps(s, r):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  color.a = 0.75
  screen.fillRect(r, color)

  tick()
