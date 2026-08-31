# Bumpy - 2d geometry intersections library for Nim.

* `nimby install bumpy`

![Github Actions](https://github.com/treeform/bumpy/workflows/Github%20Actions/badge.svg)

[API reference](https://treeform.github.io/bumpy)

## About

Based on the book http://www.jeffreythompson.org/collision-detection/table_of_contents.php

Mostly used for vector 2d intersections checking for Pixie: https://github.com/treeform/pixie

Supported intersections:

Shape         | Point         | Circle        | Rectangle     | Segment       | Polygon       | Line          | Wedge          |
------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
Point         | ✅           | ✅            | ✅           | ✅            | ✅           | ✅            | ✅            |
Circle        | ✅           | ✅            | ✅           | ✅            | ✅           | ✅            | ✅            |
Rectangle     | ✅           | ✅            | ✅           | ✅            | ✅           | ✅            | ✅            |
Segment       | ✅           | ✅            | ✅           | ✅            | ✅           | ✅            | ✅            |
Polygon       | ✅           | ✅            | ✅           | ✅            | ✅           | ✅            | ✅            |
Line          | ✅           | ✅            | ✅           | ✅            | ✅           | ✅            | ✅            |
Wedge         | ✅           | ✅            | ✅           | ✅            | ✅           | ✅            | ✅            |

All shapes support `overlaps`.

```nim
if overlaps(circle, point):
  echo "Circle and point overlap"
```

And some shapes support `intersects` functions.

```nim
var at: Vec2
if intersects(line, segment, at):
  echo "Line and segment intersect at ", at
```
