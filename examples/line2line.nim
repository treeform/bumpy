import bumpy, common, pixie/demo

# The lines always overlap unless you get them to be perfectly parallel.

var
  a: Line
  b: Line

a.a.x = 0
a.a.y = 100

b.a.x = 0
b.a.y = 400
b.b.y = 600

start()

while true:
  b.b.x = screen.width.float32

  screen.fill(rgba(255, 255, 255, 255))

  if window.mousePos.x > 300:
    a.b = window.mousePos.vec2
  else:
    a.b = vec2(screen.width.float32, 300)
  let windowEdge = Line(
    a: vec2(screen.width.float32, 0),
    b: vec2(screen.width.float32, screen.height.float32)
  )
  var at: Vec2
  if intersects(windowEdge, a, at):
    screen.strokeSegment(segment(a.a, at), parseHtmlColor("#2ecc71"))

  var color =
    if overlaps(a, b):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  screen.strokeSegment(segment(b.a, b.b), color)

  tick()
