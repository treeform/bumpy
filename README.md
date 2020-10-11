# Bumpy - 2d collision library for nim.

Based on the book http://www.jeffreythompson.org/collision-detection/table_of_contents.php


Supported collisions:

Shape         | Point         | Circle        | Rectangle     | Segment       | Polygon       | Triangle      |
------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
Point         | ✅           | ✅           | ✅           | ✅           | ✅           |               |
Circle        | ✅           | ✅           | ✅           | ✅           |               |               |
Rectangle     | ✅           | ✅           | ✅           | ✅           |               |               |
Segment       | ✅           | ✅           | ✅           | ✅           |               |               |
Polygon       | ✅           |               |               |               |               |               |
Triangle      |               |               |               |               |               |               |

# API: bumpy

```nim
import bumpy
```

## **type** Circle


```nim
Circle = object
 pos*: Vec2
 radius*: float32
```

## **type** Segment


```nim
Segment = object
 a*: Vec2
 b*: Vec2
```

## **proc** circle


```nim
proc circle(pos: Vec2; radius: float32): Circle
```

## **proc** segment


```nim
proc segment(a, b: Vec2): Segment
```

## **proc** overlap

Do two points overlap? (Must be exactly equal.)

```nim
proc overlap(a, b: Vec2): bool
```

## **proc** overlap

Does point overlap a circle?

```nim
proc overlap(a: Vec2; b: Circle): bool
```

## **proc** overlap

Does circle overlap a point?

```nim
proc overlap(a: Circle; b: Vec2): bool
```

## **proc** overlap

Do two circles overlap?

```nim
proc overlap(a, b: Circle): bool
```

## **proc** overlap

Does point overlap a rectangle?

```nim
proc overlap(a: Vec2; b: Rect): bool
```

## **proc** overlap

Does a rect overlap a point?

```nim
proc overlap(a: Rect; b: Vec2): bool
```

## **proc** overlap

Do two rectangles overlap?

```nim
proc overlap(a, b: Rect): bool
```

## **proc** overlap

Does a circle overlap a rectangle?

```nim
proc overlap(a: Circle; b: Rect): bool
```

## **proc** overlap

Does a rect overlap a circle?

```nim
proc overlap(a: Rect; b: Circle): bool
```

## **proc** overlap

Does a point overlap a segment?

```nim
proc overlap(a: Vec2; s: Segment; buffer = 0.1): bool
```

## **proc** overlap

Does a segment overlap a point?

```nim
proc overlap(a: Segment; b: Vec2; buffer = 0.1): bool
```

## **proc** overlap

Does a circle overlap a segment?

```nim
proc overlap(c: Circle; s: Segment): bool
```

## **proc** overlap

Does a circle overlap a segment?

```nim
proc overlap(s: Segment; c: Circle): bool
```

## **proc** overlap

Do two segments overlap?

```nim
proc overlap(d, s: Segment): bool
```

## **proc** overlap

Does a segments overlap a rectangle?

```nim
proc overlap(s: Segment; r: Rect): bool
```

## **proc** overlap

Does a rectangle overlap a segment?

```nim
proc overlap(r: Rect; s: Segment): bool
```

## **proc** overlap

Does a polygon overlap a point?

```nim
proc overlap(poly: seq[Vec2]; p: Vec2): bool
```

## **proc** overlap

Does a point overlap a polygon?

```nim
proc overlap(p: Vec2; poly: seq[Vec2]): bool
```
