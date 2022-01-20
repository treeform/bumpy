import boxy, opengl, pixie, windy

export pixie, windy

var
  window*: Window
  screen*: Image
  ctx*: Context
  bxy: Boxy

proc tick*() =
  ## Called this every frame in a while loop.

  bxy.addImage("screen", screen, genMipmaps = false)

  bxy.beginFrame(window.size)
  bxy.drawRect(rect(vec2(0, 0), window.size.vec2), color(1, 1, 1, 1))
  bxy.drawImage("screen", vec2(0, 0))
  bxy.endFrame()

  swapBuffers(window)

  pollEvents()

  if window.closeRequested:
    quit()

proc start*(title = "Demo", windowSize = ivec2(800, 600)) =
  ## Start the demo.
  window = newWindow(title, windowSize)
  window.style = Decorated
  window.size = (window.size.vec2 * window.contentScale).ivec2

  makeContextCurrent(window)
  loadExtensions()

  let pixelSize = windowSize.vec2 * window.contentScale
  screen = newImage(pixelSize.x.int, pixelSize.y.int)
  ctx = newContext(screen)
  bxy = newBoxy()

proc fillPoly*(image: Image, poly: seq[Vec2], color: SomeColor) =
  let path = newPath()
  path.moveTo(poly[0])
  for p in poly[1..^1]:
    path.lineTo(p)
  path.closePath()
  image.fillPath(path, color)

proc strokePoly*(image: Image, poly: seq[Vec2], color: SomeColor) =
  let path = newPath()
  path.moveTo(poly[0])
  for p in poly[1..^1]:
    path.lineTo(p)
  path.closePath()
  image.strokePath(path, color)

proc fillRect*(image: Image, rect: Rect, color: SomeColor) =
  let p = newPath()
  p.rect(rect)
  image.fillPath(p, color)

proc fillCircle*(image: Image, circle: Circle, color: SomeColor) =
  let p = newPath()
  p.circle(circle)
  image.fillPath(p, color)

proc strokeCircle*(image: Image, circle: Circle, color: SomeColor) =
  let p = newPath()
  p.circle(circle)
  image.fillPath(p, color)

proc strokeSegment*(image: Image, segment: Segment, color: SomeColor) =
  let p = newPath()
  p.moveTo(segment.at)
  p.lineTo(segment.to)
  image.strokePath(p, color)
