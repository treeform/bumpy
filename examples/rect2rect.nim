import bumpy, common, pixie/demo, vmath, chroma

var
  a: Rect
  b: Rect
a.w = 50
a.h = 40
b.x = 150
b.y = 200
b.w = 300
b.h = 200

start()

while true:
  screen.fill(rgba(255, 255, 255, 255))

  a.xy = getMousePos()
  screen.fillRect(a, parseHtmlColor("#2ecc71"))

  var color =
    if overlaps(a, b):
      parseHtmlColor("#e74c3c")
    else:
      parseHtmlColor("#3498db")
  color.a = 0.75
  screen.fillRect(b, color)

  tick()
