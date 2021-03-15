import bumpy, pixie/demo, vmath, chroma, common

# The lines always overlap unless you get them to be perfectly parallel.

var
  l: Line
  b: seq[Vec2]

b.add(vec2(200, 100))
b.add(vec2(400, 130))
b.add(vec2(350, 300))
b.add(vec2(250, 330))

start()

while true:
  screen.fill(rgba(255, 255, 255, 255))

  l.b = getMousePos()
  let windowEdge = Line(
    a: vec2(screen.width.float32, 0),
    b: vec2(screen.width.float32, screen.height.float32)
  )

  var at: Vec2
  if intersects(windowEdge, l, at):
    screen.strokeSegment(segment(l.a, at), parseHtmlColor("#2ecc71"))

  let color =
    if overlaps(l, b):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  screen.fillPoly(b, color)

  tick()
