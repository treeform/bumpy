import pixie

proc fillPoly*(image: Image, poly: seq[Vec2], color: SomeColor) =
  var path: Path
  path.moveTo(poly[0])
  for p in poly[1..^1]:
    path.lineTo(p)
  path.closePath()
  image.fillPath(path, color)

proc strokePoly*(image: Image, poly: seq[Vec2], color: SomeColor) =
  var path: Path
  path.moveTo(poly[0])
  for p in poly[1..^1]:
    path.lineTo(p)
  path.closePath()
  image.strokePath(path, color)
