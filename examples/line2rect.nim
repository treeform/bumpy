import bumpy, common, pixie/demo, vmath, chroma

# The lines always overlap unless you get them to be perfectly parallel.

var
  l: Line
  r: Rect

r.x = 150
r.y = 200
r.w = 300
r.h = 200

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
    if overlaps(l, r):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  screen.fillRect(r, color)

  tick()
