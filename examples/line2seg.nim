import bumpy, common

# The lines always overlap unless you get them to be perfectly parallel.

var
  l: Line
  s: Segment

l.a.x = 0
l.a.y = 100

start()

while true:
  screen.fill(rgba(255, 255, 255, 255))

  s.at.x = 100
  s.at.y = 400
  s.to.x = screen.width.float32 - 100
  s.to.y = 500

  l.b = window.mousePos.vec2
  let windowEdge = Line(
    a: vec2(screen.width.float32, 0),
    b: vec2(screen.width.float32, screen.height.float32)
  )

  var at: Vec2
  if intersects(windowEdge, l, at):
    screen.strokeSegment(segment(l.a, at), parseHtmlColor("#2ecc71"))

  let color =
    if overlaps(l, s):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  screen.strokeSegment(segment(s.at, s.to), color)

  tick()
