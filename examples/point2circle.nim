import bumpy, chroma, common, pixie/demo, vmath

var
  a: Vec2
  b: Circle
b.pos.x = 300
b.pos.y = 300
b.radius = 100

start()

while true:
  screen.fill(rgba(255, 255, 255, 255))

  a = getMousePos()
  screen.strokeCircle(circle(a, 10), parseHtmlColor("#2ecc71"))

  var color =
    if overlaps(a, b): parseHtmlColor("#e74c3c")
    else: parseHtmlColor("#3498db")
  color.a = 0.75
  screen.fillCircle(b, color)

  tick()
