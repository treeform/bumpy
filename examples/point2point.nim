import bumpy, common, pixie/demo

var a, b: Vec2
b.x = 300
b.y = 300

start()

while true:
  screen.fill(rgba(255, 255, 255, 255))

  a = window.mousePos.vec2
  screen.strokeCircle(circle(a, 10), parseHtmlColor("#2ecc71"))

  var color =
    if overlaps(a, b): parseHtmlColor("#e74c3c")
    else: parseHtmlColor("#3498db")
  color.a = 0.75
  screen.fillCircle(circle(b, 10), color)

  tick()
